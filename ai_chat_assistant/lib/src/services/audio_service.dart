import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

/// Service for handling audio recording and playback
class AudioService {
  final Logger _logger = Logger();
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();

  bool _isRecording = false;
  bool _isPlaying = false;
  StreamSubscription<Uint8List>? _recordingSubscription;

  // Audio buffers
  final List<int> _recordingBuffer = [];
  final List<int> _playbackBuffer = [];
  final int _sampleRate = 24000; // OpenAI Realtime API uses 24kHz
  final int _recordingChunkMs = 50; // Send audio every 50ms (smaller chunks = better responsiveness)
  final int _playbackBufferMs = 200; // Buffer 200ms before playback (smoother audio)

  Timer? _playbackTimer;
  bool _isBuffering = false;

  bool get isRecording => _isRecording;
  bool get isPlaying => _isPlaying;

  /// Request microphone permission
  Future<bool> requestPermission() async {
    try {
      final status = await Permission.microphone.request();
      if (status.isGranted) {
        _logger.i('Microphone permission granted');
        return true;
      } else if (status.isPermanentlyDenied) {
        _logger.w('Microphone permission permanently denied');
        await openAppSettings();
        return false;
      } else {
        _logger.w('Microphone permission denied');
        return false;
      }
    } catch (e) {
      _logger.e('Error requesting microphone permission', error: e);
      return false;
    }
  }

  /// Start recording audio
  Future<void> startRecording(
    Function(Uint8List) onAudioData,
  ) async {
    try {
      if (_isRecording) {
        _logger.w('Already recording');
        return;
      }

      final hasPermission = await _recorder.hasPermission();
      if (!hasPermission) {
        _logger.e('No microphone permission');
        throw Exception('Microphone permission not granted');
      }

      _logger.i('Starting audio recording');

      // Configure recording for PCM16 format
      const config = RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: 24000,
        numChannels: 1,
        bitRate: 384000,
      );

      // Start recording to stream
      final stream = await _recorder.startStream(config);

      _isRecording = true;
      _recordingBuffer.clear();

      // Listen to the audio stream
      _recordingSubscription = stream.listen(
        (data) {
          _recordingBuffer.addAll(data);

          // Send audio data in smaller chunks (every 50ms worth of audio for better responsiveness)
          final bytesPerChunk = (_sampleRate * 2 * _recordingChunkMs) ~/ 1000;
          if (_recordingBuffer.length >= bytesPerChunk) {
            final chunk = Uint8List.fromList(
              _recordingBuffer.sublist(0, bytesPerChunk),
            );
            _recordingBuffer.removeRange(0, bytesPerChunk);
            onAudioData(chunk);
          }
        },
        onError: (error) {
          _logger.e('Recording stream error', error: error);
          stopRecording();
        },
        onDone: () {
          _logger.i('Recording stream done');
          _isRecording = false;
        },
      );

      _logger.i('Audio recording started successfully');
    } catch (e) {
      _logger.e('Error starting recording', error: e);
      _isRecording = false;
      rethrow;
    }
  }

  /// Stop recording audio
  Future<void> stopRecording() async {
    try {
      if (!_isRecording) {
        return;
      }

      _logger.i('Stopping audio recording');
      await _recordingSubscription?.cancel();
      await _recorder.stop();
      _isRecording = false;
      _recordingBuffer.clear();
      _logger.i('Audio recording stopped');
    } catch (e) {
      _logger.e('Error stopping recording', error: e);
    }
  }

  /// Play audio from PCM16 data with buffering
  Future<void> playAudio(Uint8List pcm16Data) async {
    try {
      // Add to playback buffer
      _playbackBuffer.addAll(pcm16Data);

      // Start buffered playback if not already buffering
      if (!_isBuffering && !_isPlaying) {
        _isBuffering = true;

        // Wait to accumulate enough audio (200ms) before playing
        final minBufferSize = (_sampleRate * 2 * _playbackBufferMs) ~/ 1000;

        if (_playbackBuffer.length >= minBufferSize) {
          await _playBufferedAudio();
        } else {
          // Start a timer to play once we have enough data
          _playbackTimer?.cancel();
          _playbackTimer = Timer(Duration(milliseconds: _playbackBufferMs), () {
            if (_playbackBuffer.isNotEmpty) {
              _playBufferedAudio();
            }
          });
        }
      }
    } catch (e) {
      _logger.e('Error queueing audio', error: e);
      _isBuffering = false;
    }
  }

  /// Play buffered audio data
  Future<void> _playBufferedAudio() async {
    try {
      if (_playbackBuffer.isEmpty) {
        _isBuffering = false;
        return;
      }

      // Get all buffered data
      final audioData = Uint8List.fromList(_playbackBuffer);
      _playbackBuffer.clear();
      _isBuffering = false;

      // Convert PCM16 to WAV format for playback
      final wavData = _convertPCM16ToWAV(audioData);

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/temp_audio_${DateTime.now().millisecondsSinceEpoch}.wav');
      await tempFile.writeAsBytes(wavData);

      // Play the audio
      await _player.stop(); // Stop any current playback
      await _player.play(DeviceFileSource(tempFile.path));
      _isPlaying = true;

      // Clean up after playback
      _player.onPlayerComplete.listen((_) {
        _isPlaying = false;
        tempFile.delete().catchError((e) {
          _logger.w('Failed to delete temp audio file', error: e);
          return tempFile; // Return the file to satisfy the error handler type
        });
      });
    } catch (e) {
      _logger.e('Error playing buffered audio', error: e);
      _isPlaying = false;
      _isBuffering = false;
    }
  }

  /// Convert PCM16 data to WAV format
  Uint8List _convertPCM16ToWAV(Uint8List pcm16Data) {
    final int dataSize = pcm16Data.length;
    final int fileSize = 36 + dataSize;

    final buffer = ByteData(44 + dataSize);

    // WAV header
    // RIFF chunk descriptor
    buffer.setUint8(0, 0x52); // 'R'
    buffer.setUint8(1, 0x49); // 'I'
    buffer.setUint8(2, 0x46); // 'F'
    buffer.setUint8(3, 0x46); // 'F'
    buffer.setUint32(4, fileSize, Endian.little);
    buffer.setUint8(8, 0x57); // 'W'
    buffer.setUint8(9, 0x41); // 'A'
    buffer.setUint8(10, 0x56); // 'V'
    buffer.setUint8(11, 0x45); // 'E'

    // fmt sub-chunk
    buffer.setUint8(12, 0x66); // 'f'
    buffer.setUint8(13, 0x6D); // 'm'
    buffer.setUint8(14, 0x74); // 't'
    buffer.setUint8(15, 0x20); // ' '
    buffer.setUint32(16, 16, Endian.little); // Sub-chunk size
    buffer.setUint16(20, 1, Endian.little); // Audio format (PCM)
    buffer.setUint16(22, 1, Endian.little); // Number of channels (mono)
    buffer.setUint32(24, _sampleRate, Endian.little); // Sample rate
    buffer.setUint32(28, _sampleRate * 2, Endian.little); // Byte rate
    buffer.setUint16(32, 2, Endian.little); // Block align
    buffer.setUint16(34, 16, Endian.little); // Bits per sample

    // data sub-chunk
    buffer.setUint8(36, 0x64); // 'd'
    buffer.setUint8(37, 0x61); // 'a'
    buffer.setUint8(38, 0x74); // 't'
    buffer.setUint8(39, 0x61); // 'a'
    buffer.setUint32(40, dataSize, Endian.little);

    // Copy PCM data
    for (int i = 0; i < dataSize; i++) {
      buffer.setUint8(44 + i, pcm16Data[i]);
    }

    return buffer.buffer.asUint8List();
  }

  /// Stop audio playback
  Future<void> stopPlayback() async {
    try {
      await _player.stop();
      _isPlaying = false;
      _logger.i('Audio playback stopped');
    } catch (e) {
      _logger.e('Error stopping playback', error: e);
    }
  }

  /// Pause audio playback
  Future<void> pausePlayback() async {
    try {
      await _player.pause();
      _logger.i('Audio playback paused');
    } catch (e) {
      _logger.e('Error pausing playback', error: e);
    }
  }

  /// Resume audio playback
  Future<void> resumePlayback() async {
    try {
      await _player.resume();
      _logger.i('Audio playback resumed');
    } catch (e) {
      _logger.e('Error resuming playback', error: e);
    }
  }

  /// Get current playback position
  Future<Duration?> getPosition() async {
    try {
      return await _player.getCurrentPosition();
    } catch (e) {
      _logger.e('Error getting playback position', error: e);
      return null;
    }
  }

  /// Set playback volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    try {
      await _player.setVolume(volume.clamp(0.0, 1.0));
    } catch (e) {
      _logger.e('Error setting volume', error: e);
    }
  }

  /// Dispose of resources
  void dispose() {
    _recordingSubscription?.cancel();
    _playbackTimer?.cancel();
    _recorder.dispose();
    _player.dispose();
    _recordingBuffer.clear();
    _playbackBuffer.clear();
  }
}

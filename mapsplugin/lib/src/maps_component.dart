import 'dart:async';
import 'dart:ui' as ui;

import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'constants.dart';
// import 'filters.dart';
import 'models/map_item.dart';
import 'map_item_view.dart';
import 'item_type.dart';

class MapsView extends StatefulWidget {
  const MapsView({
    super.key,
    required this.mapItems,
  });
  final List<MapItem> mapItems;

  @override
  State<MapsView> createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  late ClusterManager clusterManager;
  final CameraPosition _initialPosition =
      const CameraPosition(target: LatLng(25.1950, 55.2784), zoom: 10);
  // FilterParams selectedFilters = FilterParams.empty();
  late List<MapItem> unfilteredList;

  bool isMapFirstime = false;
  bool isMapMovedByHuman = false;
  int userInteractedWithMapMillis = -1;
  Completer<GoogleMapController> mapController = Completer();
  PageController hzListController = PageController(viewportFraction: 0.9);
  GoogleMapController? googleMapController;
  CameraPosition? cameraPosition;

  Set<Marker> markers = <Marker>{};

  @override
  void initState() {
    super.initState();
    unfilteredList = [...widget.mapItems];

    clusterManager = _initClusterManager();
    clusterManager.setItems(widget.mapItems);
    setState(() {
      isMapFirstime = true;
    });
  }

  void initMapController(GoogleMapController controller) async {
    mapController = Completer();
    mapController.complete(controller);
    final firstItem = widget.mapItems.firstOrNull;
    if (firstItem != null) {
      await zoomToPoint(firstItem.location);
    }
    setState(() {
      isMapMovedByHuman = true;
    });

    getMapBounds();
  }

  Future<void> getMapBounds() async {
    if (!isMapMovedByHuman) {
      return;
    }

    // final GoogleMapController mapCont = await mapController.future;
    //LatLngBounds bounds = await mapCont.getVisibleRegion();
    // params = params.copyWith(
    //   pageNumber: 1,
    //   northEast: ProviderLatLong(
    //     latitude: bounds.northeast.latitude,
    //     longitude: bounds.northeast.longitude,
    //   ),
    //   southWest: ProviderLatLong(
    //     latitude: bounds.southwest.latitude,
    //     longitude: bounds.southwest.longitude,
    //   ),
    // );

    isMapMovedByHuman = false;
    //await _getMyProviders();
    if (isMapFirstime) {
      Future.delayed(const Duration(milliseconds: 500), () {
        zoomToPoint(widget.mapItems.first.location, level: 10);
      });
    }
    setState(() {});
  }

  ClusterManager<MapItem> _initClusterManager() {
    return ClusterManager<MapItem>(
      widget.mapItems,
      _updateMarkers,
      markerBuilder: _markerBuilder,
    );
  }

  void _updateMarkers(Set<Marker> set) {
    setState(() {
      markers = set;
    });
  }

  Color _getIconColor(bool isSelected) {
    return isSelected ? Colors.red : Colors.blue;
  }

  Future<ui.Image> _fetchImage(String url, int size) async {
    var file = await DefaultCacheManager().getSingleFile(url);
    final codec = await ui.instantiateImageCodec(
      file.readAsBytesSync(),
      targetHeight: size,
      targetWidth: size,
    );
    return (await codec.getNextFrame()).image;
  }

  int findMarkerIndex(MapItem targetMarker) {
    int selectedIndex = -1; // Return -1 if the target marker is not found
    for (int i = 0; i < widget.mapItems.length; i++) {
      MapItem marker = widget.mapItems[i];
      if (marker.id == targetMarker.id) {
        selectedIndex = i;
        widget.mapItems[i] = widget.mapItems[i].copyWith(isSelected: true);
      } else {
        widget.mapItems[i] = widget.mapItems[i].copyWith(isSelected: false);
      }
    }
    clusterManager.setItems(widget.mapItems);
    return selectedIndex;
  }

  Future<void> zoomToPoint(LatLng latLng, {double level = 10}) async {
    final GoogleMapController mapCont = await mapController.future;
    //for moving marker closer to the center of visible map, offset is used
    const offset = -0.0006;
    final CameraPosition target = CameraPosition(
      target: LatLng(latLng.latitude + offset, latLng.longitude),
      zoom: level,
    );
    await mapCont.animateCamera(CameraUpdate.newCameraPosition(target));
  }

  Future<Marker> Function(Cluster<MapItem>) get _markerBuilder =>
      (cluster) async {
        final firstLocation = cluster.items.first;
        MediaQueryData queryData = MediaQuery.of(context);
        double devicePixelRatio = queryData.devicePixelRatio;

        Color iconColor = _getIconColor(
          firstLocation.isSelected,
        );

        if (widget.mapItems.first == firstLocation && isMapFirstime) {
          iconColor = Colors.red;
        }

        var imageUrl = firstLocation.logo;

        var iconBytes = await createMarkerIcon(
          firstLocation.name,
          imageUrl,
          cluster.items.length,
          devicePixelRatio,
          iconColor,
        );
        var counterIcon = await getClusterBitmap(
          120,
          text: cluster.items.length.toString(),
        );
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: firstLocation.location,
          onTap: () async {
            userInteractedWithMapMillis = DateTime.now().millisecondsSinceEpoch;
            var selectedMarkerIndex = findMarkerIndex([...cluster.items].first);

            zoomToPoint(firstLocation.location);

            await hzListController.animateToPage(
              selectedMarkerIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear,
            );
          },
          icon: cluster.items.length > 1
              ? counterIcon
              : iconBytes != null
                  ? BitmapDescriptor.fromBytes(iconBytes)
                  : BitmapDescriptor.defaultMarker,
        );
      };

  Future<Uint8List?> createMarkerIcon(String centreTitle, String imageUrl,
      int count, double devicePixelRatio, Color markerColor) async {
    const rectHeight = 200;

    ///Text Painter Start///
    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      maxLines: 1,
      textAlign: TextAlign.center,
      ellipsis: "...",
    );
    textPainter.text = TextSpan(
      text: centreTitle,
      style: const TextStyle(
        fontSize: rectHeight / 3,
        color: Colors.black,
        fontWeight: FontWeight.w700,
      ),
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: 550,
    );

    ///Text Painter End///

    ///Calculation for Size and Padding Start///
    const padding = rectHeight * 0.1;
    const imageContainer = rectHeight - 2 * padding;
    const imageSize = imageContainer - 2 * padding;
    const circleRadius = rectHeight / 4;
    double imageContainerPadding() {
      return padding + (imageContainer / 2);
    }

    double imagePadding() {
      return 2 * padding;
    }

    double textPadding() {
      return 0;
      //return imageContainer + padding * 2;
    }

    // final totalWidth = (textPainter.width + imageContainer + 6 * padding).toInt();
    // final totalWidth = (imageContainer + 3 * padding).toInt() - 12;
    const totalWidth = 200;
    const triangleWidth = 45;
    const triangleHeight = triangleWidth * 0.4;
    const totalHeight = rectHeight + triangleHeight + (circleRadius * 2);

    ///Calculation for Size and Padding  End///

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    ///Container1 Paint Start///
    ///Get.key.currentState!.context.primaryButtonColor

    final Paint paint = Paint()..color = markerColor;

    ///whole container
    Radius radius = const Radius.circular(25);
    // canvas.drawRRect(
    //   RRect.fromRectAndCorners(
    //     Rect.fromLTWH(
    //         0.0, padding, totalWidth.toDouble(), rectHeight.toDouble()),
    //     topLeft: radius,
    //     topRight: radius,
    //     bottomLeft: radius,
    //     bottomRight: radius,
    //   ),
    //   paint,
    // );

    ///Container1 Paint End///

    ///Container2 Paint Start///

    final Paint paint2 = Paint()..color = Colors.yellow;

    ///image container
    Radius radius2 = const Radius.circular(20);
    // canvas.drawRRect(
    //   RRect.fromRectAndCorners(
    //     Rect.fromCenter(
    //       center: Offset(
    //           imageContainerPadding(), (rectHeight.toDouble() / 2) + padding),
    //       width: imageContainer,
    //       height: imageContainer,
    //     ),
    //     topLeft: radius2,
    //     topRight: radius2,
    //     bottomLeft: radius2,
    //     bottomRight: radius2,
    //   ),
    //   paint2,
    // );

    ///Container2 Paint End///

    ///Image Paint Start///
    // ui.Image image = await _fetchImage(imageUrl, imageSize.toInt());
    ui.Image image = await _fetchImage(
      imageUrl,
      imageSize.toInt(),
    );
    canvas.drawImage(
        image,
        Offset(imageContainerPadding() - imageSize / 2,
            rectHeight / 2 - imageSize / 2 + padding),
        Paint());

    textPainter.paint(
      canvas,
      // Offset(
      //   textPadding(),
      //   ((rectHeight * 0.5) - textPainter.height * 0.5) + padding,
      // ),
      Offset(
        textPadding(),
        -textPainter.height * 0.5 + padding,
      ),
    );

    ///Image Paint End///

    ///Triangle Paint Start///
    ///Get.key.currentState!.context.primaryButtonColor
    final Paint trianglePaint = Paint()
      ..color = markerColor
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    final Path trianglePath = Path()
      ..moveTo(
          totalWidth / 2 - triangleWidth / 2, rectHeight.toDouble() + padding)
      ..lineTo(totalWidth / 2, triangleHeight + rectHeight.toDouble() + padding)
      ..lineTo(
          totalWidth / 2 + triangleWidth / 2, rectHeight.toDouble() + padding);
    canvas.drawPath(trianglePath, trianglePaint);

    ///Triangle Paint End///
    final img = await pictureRecorder
        .endRecording()
        .toImage(totalWidth.toInt() + 70, totalHeight.toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data?.buffer.asUint8List();
  }

  static Future<BitmapDescriptor> getClusterBitmap(int size,
      {String? text}) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);

    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
          fontSize: size / 3,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Maps View",
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     var result = await showModalBottomSheet(
      //       context: context,
      //       isDismissible: false,
      //       isScrollControlled: false,
      //       builder: (BuildContext context) {
      //         return Filters(
      //           selectedFilters: selectedFilters,
      //         );
      //       },
      //     );
      //     if (result != null) {
      //       widget.mapItems.clear();
      //       selectedFilters = result as FilterParams;
      //       if (selectedFilters.vehicleTypes.isEmpty &&
      //           selectedFilters.vehicleBrands.isEmpty) {
      //         widget.mapItems.addAll(unfilteredList);
      //         return;
      //       }
      //       if (selectedFilters.vehicleTypes.isNotEmpty) {
      //         widget.mapItems.addAll(unfilteredList
      //             .where((element) =>
      //                 selectedFilters.vehicleTypes.contains(element.type))
      //             .toList());
      //       }
      //       if (selectedFilters.vehicleBrands.isNotEmpty) {
      //         widget.mapItems.addAll(unfilteredList
      //             .where((element) =>
      //                 selectedFilters.vehicleBrands.contains(element.name))
      //             .toList());
      //       }

      //       clusterManager.setItems(widget.mapItems);
      //       if (widget.mapItems.isNotEmpty) {
      //         final CameraPosition target = CameraPosition(
      //           target: widget.mapItems.first.location,
      //           zoom: 10,
      //         );
      //         final GoogleMapController mapCont = await mapController.future;
      //         await mapCont
      //             .animateCamera(CameraUpdate.newCameraPosition(target));
      //       }

      //       setState(() {});
      //     }
      //   },
      //   child: const Icon(Icons.filter_list_rounded),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: Stack(
        children: [
          Listener(
            onPointerMove: (_) {
              setState(() {
                isMapMovedByHuman = true;
              });
            },
            child: GoogleMap(
              initialCameraPosition: _initialPosition,
              mapType: MapType.hybrid,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              markers: markers.toSet(),
              onCameraMoveStarted: () {},
              onCameraMove: (CameraPosition position) {
                clusterManager.onCameraMove(position);

                setState(() {
                  if (isMapMovedByHuman) {
                    isMapFirstime = false;
                  }
                  cameraPosition = position;
                });
                //controller.setDebounceTimer();
              },
              onCameraIdle: () {
                clusterManager.updateMap();
                //controller.setDebounceTimer();
              },
              onMapCreated: (GoogleMapController cont) async {
                googleMapController = cont;
                initMapController(cont);
                await googleMapController?.setMapStyle(AppConstants.mapStyle);
                clusterManager.setMapId(cont.mapId);
                setState(() {});
              },
              onTap: (LatLng lat) {},
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              bottom: true,
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Align(
                  //   alignment: AlignmentDirectional.topEnd,
                  //   child: Padding(
                  //     padding:
                  //         const EdgeInsetsDirectional.only(end: 16, bottom: 16),
                  //     child: InkWell(
                  //       onTap: () async {
                  //         //controller.checkLocationPermission();
                  //       },
                  //       child: Container(
                  //         height: 56,
                  //         width: 56,
                  //         decoration: ShapeDecoration(
                  //           color: Colors.blue,
                  //           shape: RoundedRectangleBorder(
                  //             side: const BorderSide(
                  //               width: 1.33,
                  //               color: Colors.white,
                  //             ),
                  //             borderRadius: BorderRadius.circular(100),
                  //           ),
                  //           shadows: [
                  //             BoxShadow(
                  //               color: Colors.black.withOpacity(0.1),
                  //               blurRadius: 15,
                  //               offset: const Offset(0, 4),
                  //               spreadRadius: 0,
                  //             )
                  //           ],
                  //         ),
                  //         padding: const EdgeInsets.all(16),
                  //         child: CustomImage(
                  //           imagePath: AppConstants.carSVG,
                  //           color: Colors.blue,
                  //           isIcon: true,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: widget.mapItems.isNotEmpty ? 167 : 0,
                    child: PageView.builder(
                      controller: hzListController,
                      onPageChanged: (index) async {
                        isMapFirstime = false;
                        userInteractedWithMapMillis =
                            DateTime.now().millisecondsSinceEpoch;
                        final item = widget.mapItems[index];
                        findMarkerIndex(item);
                        zoomToPoint(
                          item.location,
                          level: 10,
                        );
                      },
                      itemCount: widget.mapItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = widget.mapItems[index];
                        return MapItemView(
                          item: item,
                          onTap: () {},
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          backgroundColor: Colors.white,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

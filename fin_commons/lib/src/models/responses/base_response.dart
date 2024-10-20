class BaseResponse {
  late bool success;
  String? message;

  BaseResponse(this.success, {this.message});

  BaseResponse.fromJson(json) {
    success = true;
    message = json['message'] ?? 'Success';
  }

  toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}

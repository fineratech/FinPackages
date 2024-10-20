class RequestResponse {
  final bool success;
  final String? message;
  final dynamic data;

  RequestResponse(this.success, {this.message, this.data});

  factory RequestResponse.fromJson(json) {
    return RequestResponse(true, data: json, message: "Success");
  }

  toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
    };
  }
}

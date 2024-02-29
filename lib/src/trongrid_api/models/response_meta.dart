class TGridRespMeta {
  int? at;
  int? pageSize;

  TGridRespMeta({this.at, this.pageSize});

  TGridRespMeta.fromJson(Map<String, dynamic> json) {
    at = json['at'];
    pageSize = json['page_size'];
  }
}

class TGridRespError {
  bool? success;
  String? error;
  int? statusCode;

  TGridRespError({this.success, this.error, this.statusCode});

  TGridRespError.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    statusCode = json['statusCode'];
  }
}

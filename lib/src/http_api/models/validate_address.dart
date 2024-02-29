class ValidateAddressResp {
  bool? result;
  String? message;

  ValidateAddressResp({this.result, this.message});

  ValidateAddressResp.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
  }
}

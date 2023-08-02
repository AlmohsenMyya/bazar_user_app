class ReviewBody {
  String? _customerId;
  String? _comment;
  String? _rating;
  List<String>? _fileUpload;

  ReviewBody(
      {String? customerId,
        String? comment,
        String? rating,
        List<String>? fileUpload}) {
    _customerId = customerId;
    _comment = comment;
    _rating = rating;
    _fileUpload = fileUpload;
  }

  String? get customerId => _customerId;
  String? get comment => _comment;
  String? get rating => _rating;
  List<String>? get fileUpload => _fileUpload;

  ReviewBody.fromJson(Map<String, dynamic> json) {
    _customerId = json['customer_id'];
    _comment = json['comment'];
    _rating = json['rating'];
    _fileUpload = json['fileUpload'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_id'] = _customerId;
    data['comment'] = _comment;
    data['rating'] = _rating;
    data['fileUpload'] = _fileUpload;
    return data;
  }
}

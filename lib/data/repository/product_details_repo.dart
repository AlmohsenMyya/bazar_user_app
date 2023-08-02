import 'dart:io';
import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/body/review_body.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:http/http.dart' as http;

class ProductDetailsRepo {
  final DioClient? dioClient;
  ProductDetailsRepo({required this.dioClient});

  // Future<ApiResponse> getProduct(String productID) async {
  //   try {
  //     final response = await dioClient!.get(AppConstants.productDetailsUri+productID);
  //     return ApiResponse.withSuccess(response);
  //   } catch (e) {
  //     return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  //   }
  // }





  // رابط api  ياخذ id  المنتج ويعيد قائمة من مودل ReviewModel
  // المطلوب ياخذ id  الزبون  ويضيف التقييم لبياناته
  Future<ApiResponse> getReviews(String customerID) async {
    try {
      final response = await dioClient!.get(AppConstants.customerReviewUri+customerID);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  //    رابط api لاضافة تقييم المنتج يحتاج ل ReviewBody و التوكن و فايلات الصور
  Future<http.StreamedResponse> submitReview(ReviewBody reviewBody, List<File> files, String token) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.submitReviewUri}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    // for(int index=0; index < 3; index++) {
    //   if(files[index].path.isNotEmpty) {
    //     request.files.add(http.MultipartFile(
    //       'fileUpload[$index]',
    //       files[index].readAsBytes().asStream(),
    //       files[index].lengthSync(),
    //       filename: files[index].path.split('/').last,
    //     ));
    //   }
    // }
    request.fields.addAll(<String, String>{'user_id': reviewBody.customerId!,
      // 'comment': reviewBody.comment!,
      'rating': reviewBody.rating!});
    http.StreamedResponse response = await request.send();
    print("enddd - ${response.statusCode}");
    return response;
  }
}
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/body/seller_body.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/seller_info.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:http/http.dart' as http;

class ProfileRepo{
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  ProfileRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> getSellerInfo() async {
    try {
      final response = await dioClient!.get(AppConstants.sellerUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<http.StreamedResponse> updateProfile(SellerModel userInfoModel, SellerBody seller,  File? file, String token, String password) async {

    bool isActive= true ;
    String apiUrl = '${AppConstants.baseUrl}/api/v3/seller/update-isActive?is_active=${isActive ? 1 : 0}';
    // Create the HTTP request
    http.Response response1 = await http.put(Uri.parse(apiUrl), headers: <String, String>{'Authorization': 'Bearer $token'});


    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.sellerAndBankUpdate}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    Map<String, String> fields = {};
    if(file != null) {
      request.files.add(http.MultipartFile('image', file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split('/').last));
    }
    fields.addAll(<String, String>{
      '_method': 'put', 'f_name': userInfoModel.fName!, 'l_name': userInfoModel.lName!, 'phone': userInfoModel.phone!,
    });
    if(password.isNotEmpty) {
      fields.addAll({'password': password});
    }
    if (kDebugMode) {
      print(fields.toString());
    }
    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();
    return response;
  }


  Future<ApiResponse> withdrawBalance(List <String?> typeKey, List<String> typeValue,int? id, String balance) async {
    try {
      Map<String?, String> fields = {};

      for(var i = 0; i < typeKey.length; i++){
        fields.addAll(<String?, String>{
          typeKey[i] : typeValue[i]
        });
      }
      fields.addAll(<String, String>{
        'amount': balance,
        'withdraw_method_id': id.toString()
      });


      if (kDebugMode) {
        print('--here is type key =$id');
      }


      Response response = await dioClient!.post( AppConstants.balanceWithdraw,
          data: fields);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> deleteUserAccount() async {
    try {
      final response = await dioClient!.get(AppConstants.deleteAccount);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDynamicWithDrawMethod() async {
    try {
      final response = await dioClient!.get(AppConstants.dynamicWithdrawMethod);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // edit by almohsen
  Future<http.Response> updateIsActive(bool isActive, String token) async {

    // Construct the API endpoint URL
    String apiUrl = '${AppConstants.baseUrl}/api/v3/seller/update-isActive?is_active=${isActive?1:0}';
    // Create the HTTP request
    http.Response response = await http.put(Uri.parse(apiUrl), headers: <String, String>{'Authorization': 'Bearer $token'});
    http.Response response1 = await http.put(Uri.parse(apiUrl), headers: <String, String>{'Authorization': 'Bearer $token'});
    if (response1.statusCode == 200){
      print("finally repet");
      print("${response1.body}");
      // Do something if the API call was successful
    } else {
      if (kDebugMode) {
        print(" repet issue");
        print('${response1.statusCode} ${response1.reasonPhrase}');
      }
    }
    // Return the response
    return response;
  }
}
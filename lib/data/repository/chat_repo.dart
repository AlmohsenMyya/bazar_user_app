import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:sixvalley_vendor_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sixvalley_vendor_app/data/model/body/message_body.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class ChatRepo {
  final DioClient? dioClient;
  ChatRepo({required this.dioClient});

  Future<ApiResponse> getChatList(String type, int offset) async {
    try {
      final response = await dioClient!.get('${AppConstants.cartUri}$type?limit=30&offset=$offset');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> searchChat(String type, String search) async {
    try {
      final response = await dioClient!.get('${AppConstants.chatSearchUri}$type?search=$search');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getMessageList(String type, int offset, int? id) async {
    try {
      final response = await dioClient!.get('${AppConstants.messageUri}$type/$id?limit=300&offset=$offset');

      //AppConstants.messageUri = '/api/v3/seller/messages/get-message/'
      //type =  _userTypeIndex == 0? 'customer' : 'delivery-man'
      // id = userId
      // Required modifications : getMessageById + Emotion field + seenByCustomer + seenByDeliveryMan
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> sendMessageText(MessageBody messageBody, String type) async {
    try {
      final response = await dioClient!.post(
          '${AppConstants.sendMessageUri}$type',
          data: messageBody.toJson()
      );
      print(
          "sendMessage \n --------- \n type = $type --+-+---+---+-- \n  ${AppConstants.sendMessageUri}$type"
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> sendMessageMedia(MessageBody messageBody, String type, File file) async {
    try {
      print("id ${messageBody.sellerId.toString()}- postman "   );

      FormData formData = FormData.fromMap(  {
        'file': await MultipartFile.fromFile(file.path, filename: basename(file.path)),
        'id': messageBody.sellerId.toString(),
        'key': messageBody.messageType!,
        'message': messageBody.message!
      });

      final response = await dioClient!.post(
        '${AppConstants.sendMessageUri}$type',
        data: formData,
        options: Options(
          contentType: 'application/json; charset=UTF-8',
        ),
      );
      print("--sally-- ${response.data}");
      return ApiResponse.withSuccess(response);

    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));

    }
  }
  // Future<ApiResponse> sendMessage(String type, MessageBody messageBody) async {
  //   if (kDebugMode) {
  //     print('==body===>${messageBody.toJson()}');
  //
  //   }
  //   try {
  //
  //     final response = await dioClient!.post('${AppConstants.sendMessageUri}$type', data: messageBody.toJson());
  //
  //     return ApiResponse.withSuccess(response);
  //   } catch (e) {
  //     return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  //   }
  // }
}
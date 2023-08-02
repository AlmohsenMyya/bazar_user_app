import 'dart:io';

import 'package:sixvalley_vendor_app/data/model/response/chat_model.dart';

class MessageModel {
  int? totalSize;
  String? limit;
  String? offset;
  List<Message>? message;

  MessageModel({this.totalSize, this.limit, this.offset, this.message});

  MessageModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['message'] != null) {
      message = <Message>[];
      json['message'].forEach((v) {
        message!.add(Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (message != null) {
      data['message'] = message!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Message {
  int? id;
  int? userId;
  // edite by almohsen
  String? messageType;
  String ? fileUrl ;
  File? file ;
  String? selectedEmoji;
  String ? replyMessage ;
  String ? replyto ;
  String ? replyType ;
  String ? messageState ;
  //
  int? deliveryManId;
  String? message;
  int? sentByCustomer;
  int? sentByDeliveryMan;
  int? sentBySeller;
  int? seenBySeller;
  String? createdAt;
  String? updatedAt;
  Customer? customer;
  DeliveryMan? deliveryMan;

  Message(
      {this.id,
        // edite by almohsen
        this.selectedEmoji,
        this.messageType,
        this.fileUrl ,
        this.replyMessage,
        this.replyto ,
        this.replyType,
        this.messageState ,
        this.file,
        //
        this.userId,
        this.deliveryManId,
        this.message,
        this.sentByCustomer,
        this.sentByDeliveryMan,
        this.sentBySeller,
        this.seenBySeller,
        this.createdAt,
        this.updatedAt,
        this.customer,
      this.deliveryMan});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    // edite by almohsen
    fileUrl = json['file'] ;
    messageType = json['key'];
    selectedEmoji = json['selectedEmoji'] ;
    replyMessage = json['reply_message'];
    replyType = json['reply_type'] ;
    replyto =json ['reply_to'] ;
    messageState = json ['message_state'] ;
    //
    if(json['delivery_man_id'] != null){
      deliveryManId = int.parse(json['delivery_man_id'].toString());
    }

    message = json['message'];
    sentByCustomer = json['sent_by_customer'];
    if(json['sent_by_delivery_man'] != null){
      sentByDeliveryMan = int.parse(json['sent_by_delivery_man'].toString());
    }

    sentBySeller = json['sent_by_seller'];
    seenBySeller = json['seen_by_seller'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    customer = json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    deliveryMan = json['delivery_man'] != null ? DeliveryMan.fromJson(json['delivery_man']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    // edite by almohsen
    data['key'] = messageType ;
    data['file'] = fileUrl ;
    data['selectedEmoji'] = selectedEmoji ;
    data['reply_message'] = replyMessage ;
    data['reply_type'] = replyType ;
    data['message_state'] = messageState ;
    //
    data['user_id'] = userId;
    data['delivery_man_id'] = deliveryManId;
    data['message'] = message;
    data['sent_by_customer'] = sentByCustomer;
    data['sent_by_delivery_man'] = sentByDeliveryMan;
    data['sent_by_seller'] = sentBySeller;
    data['seen_by_seller'] = seenBySeller;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    if (deliveryMan != null) {
      data['delivery_man'] = deliveryMan!.toJson();
    }
    return data;
  }
}



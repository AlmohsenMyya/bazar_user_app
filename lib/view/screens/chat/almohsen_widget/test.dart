// import 'dart:collection';
// import 'dart:io';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:sixvalley_vendor_app/data/model/body/message_body.dart';
// import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
// import 'package:sixvalley_vendor_app/data/model/response/chat_model.dart';
// import 'package:sixvalley_vendor_app/data/model/response/message_model.dart';
// import 'package:sixvalley_vendor_app/data/repository/chat_repo.dart';
// import 'package:sixvalley_vendor_app/helper/api_checker.dart';
//
//
// class ChatProvider extends ChangeNotifier {
//   final ChatRepo? chatRepo;
//   ChatProvider({required this.chatRepo});
//
//   ///-- update
//   Queue<MessageBody> messageQueue = Queue();
//   bool isProcessingQueue = false;
//
//   ///----------
//   List<Chat>? _chatList;
//   List<Chat>? get chatList => _chatList;
//   List<Message>? _messageList ;
//   List<Message>? _oldmessageList = [];
//   List<Message>? get messageList => _messageList;
//   List<Message>? get oldmessageList => _oldmessageList;
//   bool _isSendButtonActive = false;
//   bool get isSendButtonActive => _isSendButtonActive;
//   int _userTypeIndex = 0;
//   int get userTypeIndex =>  _userTypeIndex;
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//   ChatModel? _chatModel;
//   ChatModel? get chatModel => _chatModel;
//   int _latestMessageId = 0;
//   bool _isSendingComplete = true ;
//   bool get isSendingComplete => _isSendingComplete;
//   void toggleisSendingComplete(bool bool) {
//     _isSendingComplete = bool ;
//     notifyListeners();
//   }
//
//   Future<void> getChatList(BuildContext context, int offset, {bool reload = false}) async {
//     if(reload){
//       _chatModel = null;
//     }
//
//     _isLoading = true;
//     ApiResponse apiResponse = await chatRepo!.getChatList(_userTypeIndex == 0 ? 'customer' : 'delivery-man', offset);
//     if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
//       if(offset == 1) {
//         _chatModel = null;
//         _chatModel = ChatModel.fromJson(apiResponse.response!.data);
//       }else {
//         _chatModel!.totalSize = ChatModel.fromJson(apiResponse.response!.data).totalSize;
//         _chatModel!.offset = ChatModel.fromJson(apiResponse.response!.data).offset;
//         _chatModel!.chat!.addAll(ChatModel.fromJson(apiResponse.response!.data).chat!);
//       }
//     } else {
//       ApiChecker.checkApi(apiResponse);
//     }
//     _isLoading = false;
//     notifyListeners();
//
//   }
//
//
//   Future<void> searchedChatList(BuildContext context, String search) async {
//     ApiResponse apiResponse = await chatRepo!.searchChat(_userTypeIndex == 0 ? 'customer' : 'delivery-man', search);
//     if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
//       _chatModel = ChatModel(totalSize: 10, limit: '10', offset: '1', chat: []);
//       apiResponse.response!.data.forEach((chat) {_chatModel!.chat!.add(Chat.fromJson(chat));});
//     } else {
//       ApiChecker.checkApi(apiResponse);
//     }
//     notifyListeners();
//   }
//   //
//   clearchat () {
//     _messageList = [] ;
//     _oldmessageList =[];
//     notifyListeners();
//
//   }
//   /// 11111111111111111111111111111111111111111
//   ///
//   void addFakeMessage(MessageBody fakeMessage, BuildContext context) {
//     print("fake");
//     _messageList = [] ;
//     final DateTime now = DateTime.now().toUtc();
//     final String formattedTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'").format(now);
//     Message ourMessage = Message(
//       sentByCustomer: null,
//       createdAt: formattedTime,
//       customer: null,
//       deliveryMan: null,
//       deliveryManId: null,
//       fileUrl: null,
//       id: 0,
//       message:" Message.message",
//       messageState: null,
//       messageType: fakeMessage.messageType,
//       seenBySeller: null,
//       sentByDeliveryMan: null,
//       sentBySeller: 1,
//       userId: fakeMessage.sellerId,
//       updatedAt: null,
//     );
//
//     // Add the fake message to the message list
//     oldmessageList!.insert(0, ourMessage);
//     // _messageList!.add(ourMessage);
//     // Notify listeners to update the UI
//     notifyListeners();
//   }
//   Future<void> getMessageList(int? id, int offset) async {
//     _messageList = [] ;
//     ApiResponse apiResponse = await chatRepo!.getMessageList(_userTypeIndex == 0? 'customer' : 'delivery-man', offset, id);
//
//     if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
//
//       _messageList!.addAll(MessageModel.fromJson(apiResponse.response!.data).message!);
//       // If there are no new messages, show the old messages instead
//
//       // Otherwise, add the new messages to the oldMessageList
//       _oldmessageList =[];
//       _oldmessageList = _messageList ;
//       _messageList=[];
//
//     } else {
//       ApiChecker.checkApi(apiResponse);
//     }
//     notifyListeners();
//   }
//   Future<void> updateMessageList(int? id, int offset) async {
//     _messageList=[];
//     ApiResponse apiResponse = await chatRepo!.getMessageList(_userTypeIndex == 0? 'customer' : 'delivery-man', offset, id);
//
//     if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
//
//       _messageList!.addAll(MessageModel.fromJson(apiResponse.response!.data).message!);
//
//       // Compare the new messages with the old messages
//       int newIndex = _messageList!.length - 1;
//       int oldIndex = _oldmessageList!.length - 1;
//       print("while start $newIndex // $oldIndex ");
//       while (newIndex >= 0 || oldIndex >= 0) {
//         final Message newMessage = _messageList![newIndex];
//         final Message oldMessage = _oldmessageList![oldIndex];
//
//
//
//         if (newMessage.id == oldMessage.id) {
//           // If the messages have the same ID, update the old message with the new message
//           // _oldmessageList![oldIndex] = newMessage;
//           break ;
//         } else if
//         (newMessage.sentBySeller == 1 && newMessage.id == oldMessage.id ) {
//           print("${newMessage.createdAt}");
//           _oldmessageList![oldIndex] = newMessage;
//           newIndex--;
//           oldIndex--;
//         }
//         else if  (newMessage.sentBySeller != 1){
//           // Otherwise, add the new message to the old message list
//           print("${newMessage.createdAt}");
//           _oldmessageList!.insert(0, newMessage);
//           newIndex--;
//           oldIndex--;
//         }
//       }
//       print("while end");
//       /// // If there are any remaining new messages, add them to the beginning of the old message list
//       // while (newIndex >= 0) {
//       //   final Message newMessage = _messageList![newIndex];
//       //   _oldmessageList!.insert(0, newMessage);
//       //   newIndex--;
//       // }
//       _messageList=[];
//     }
//
//     else {
//       ApiChecker.checkApi(apiResponse);
//     }
//
//     notifyListeners();
//   }
//
//   getOldMessageList()  {
//
//
//     _oldmessageList!.addAll(_messageList!);
//     notifyListeners();
//   }
// // edite by almohsen
//
//   void sendMessagequeue(MessageBody messageBody, BuildContext context) {
//
//     addFakeMessage(messageBody, context);
//     // Add message to queue
//     messageQueue.add(messageBody);
//
//     // Process queue if it is not already being processed
//     if (!isProcessingQueue) {
//       processQueue(context);
//     }
//   }
//   void processQueue(BuildContext context) {
//     if (messageQueue.isEmpty) {
//       // Queue is empty, stop processing
//       isProcessingQueue = false;
//       return;
//     }
//
//     MessageBody messageBody = messageQueue.removeFirst();
//     sendMessage(messageBody,context).then((value) {}).whenComplete(() {
//       processQueue(context);
//     });
//   }
//
//   Future<ApiResponse> sendMessage(MessageBody messageBody, BuildContext context) async {
//     _isSendingComplete = false ;
//     _isSendButtonActive = true;
//     String messageType = messageBody.messageType!.toLowerCase();
//     ApiResponse apiResponse;
//
//     if (messageType == "text") {
//       apiResponse = await chatRepo!.sendMessageText(messageBody, _userTypeIndex == 0? 'customer' : 'delivery-man');
//       print("-*/*//*/*/*/*/*/*/*/*/*/*/*/*/*/**/*/***/**/*/*/*/*/*/*/*");
//     } else if (messageType == "image" || messageType == "video" || messageType == "audio") {
//       print("-*/*//*/*/*/*/*/*/*/*/*/*/*/*/*/**/*/***/**/*/*/*/*/*/*/* file");
//       File? file = messageBody.mediaFile;
//
//       if (file != null) {
//         apiResponse = await chatRepo!.sendMessageMedia(messageBody, _userTypeIndex == 0? 'customer' : 'delivery-man', file);
//       } else {
//         apiResponse = ApiResponse.withError("Media file is missing");
//         print("-*/*//*/*/*/*/*/*/*/*/*/*/*/*/*/**/*/***/**/*/*/*/*/*/*/*missing");
//       }
//     } else {
//       apiResponse = ApiResponse.withError("Unsupported message type");
//       print("-*/*//*/*/*/*/*/*/*/*/*/*/*/*/*/**/*/***/**/*/*/*/*/*/*/*Unsupported");
//     }
//
//     if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
//       updateMessageList( messageBody.sellerId, 1).then((value) {
//         _isSendingComplete = true ;
//
//       });
//       print("-*/*//*/*/*/*/*/*/*/*/*/*/*/*/*/**/*/***/**/*/*/*/*/*/*/*200");
//     } else {
//       ApiChecker.checkApi( apiResponse);
//       print("-*/*//*/*/*/*/*/*/*/*/*/*/*/*/*/**/*/***/**/*/*/*/*/*/*/*404");
//     }
//
//     _isSendButtonActive = false;
//     notifyListeners();
//     return apiResponse;
//   }
//
//   void toggleSendButtonActivity() {
//     _isSendButtonActive = !_isSendButtonActive;
//     notifyListeners();
//
//   }
//
//   void setUserTypeIndex(BuildContext context, int index) {
//     _userTypeIndex = index;
//     _chatModel = null;
//     getChatList(context, 1);
//     notifyListeners();
//   }
//
// }

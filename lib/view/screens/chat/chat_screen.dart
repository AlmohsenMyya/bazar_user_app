import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/provider/chat_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/view/base/custom_app_bar.dart';
import 'package:sixvalley_vendor_app/view/screens/chat/widget/chat_shimmer.dart';
import 'package:sixvalley_vendor_app/view/screens/chat/widget/message_bubble.dart';
import 'package:sixvalley_vendor_app/view/screens/chat/widget/send_message_widget.dart';

import 'almohsen_widget/mybottom_textfield.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final int? userId;
  final int? index;

  const ChatScreen({Key? key, required this.userId, this.name = '', this.index})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ImagePicker picker = ImagePicker();
  bool isActive1 = false;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    Provider.of<ChatProvider>(context, listen: false).clearchat();
    Provider.of<ChatProvider>(context, listen: false).getChatList(context, 1);
    Provider.of<ChatProvider>(context, listen: false)
        .getMessageList(widget.userId, 1);
    Provider.of<ChatProvider>(context, listen: false).getOldMessageList();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    Provider.of<ChatProvider>(context, listen: false).getChatList(context, 1);
    Provider.of<ChatProvider>(context, listen: false)
        .getMessageList(widget.userId, 1);
    if (Provider.of<ChatProvider>(context, listen: false)
            .chatModel!
            .chat![widget.index!]
            .customer!
            .isActive ==
        '1') {
      isActive1 = true;
    } else {
      isActive1 = false;
    }
    Provider.of<ChatProvider>(context, listen: false).clearchat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),
      body: Consumer<ChatProvider>(builder: (context, chat, child) {
        if (chat.chatModel!.chat![widget.index!].customer!.isActive == '1') {
          isActive1 = true;
        } else {
          isActive1 = false;
        }
        return Column(children: [
          Stack(
            children: [
              CustomAppBar(
                title: widget.name,
              ),
              Positioned(
                top: 20,
                bottom: 0,
                right: 0,
                child: IconButton(
                  onPressed: () async {
                    await chat.getChatList(context, 1);
                    String? issactive = await chat
                        .chatModel!.chat![widget.index!].customer!.isActive;

                    if ((chat.chatModel!.chat![widget.index!].customer!
                            .isActive) ==
                        '0') {
                      setState(() {
                        isActive1 = false;
                        print(
                            "${chat.chatModel!.chat![widget.index!].customer!.isActive} 996367749");
                      });
                    } else if (chat.chatModel!.chat![widget.index!].customer!
                            .isActive ==
                        '1') {
                      setState(() {
                        isActive1 = true;
                        print(
                            "${chat.chatModel!.chat![widget.index!].customer!.isActive} 996367749");
                      });
                    }
                    print("onPressed is_active = $isActive1");
                  },
                  icon: Icon(
                    Icons.circle,
                    color: !isActive1 ? const Color(0xFFB0BEC5) : Colors.green,
                  ),
                ),
              ),
            ],
          ),

          Expanded(
            child: (chat.messageList != null && chat.messageList!.isNotEmpty) ||
                    (chat.oldmessageList != null &&
                        chat.oldmessageList!.isNotEmpty )
                ? ListView.builder(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    itemCount:
                        chat.messageList!.length + chat.oldmessageList!.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      if (index < chat.oldmessageList!.length) {
                        return MessageBubble(
                          color: false,
                          onleftSwip: () {},
                          message: chat.oldmessageList![index],
                        );
                      } else {
                        return MessageBubble(
                          color: true,
                          onleftSwip: () {},
                          message: chat.messageList![
                              index - chat.oldmessageList!.length],
                        );
                      }
                    },
                  )
                : const ChatShimmer(),
          ),

          MyBottomSendField(
            scrollController: scrollController,
            name: widget.name,
            id: widget.userId,
          ),
          // SendMessageWidget(id: widget.userId)
        ]);
      }),
    );
  }
}

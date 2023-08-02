import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/message_model.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/provider/chat_provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

import '../../../base/custom_image.dart';
import '../almohsen_widget/media_viewer_page.dart';
import '../almohsen_widget/myVoicePlayer.dart';
import '../almohsen_widget/video_player.dart';

class MessageBubble extends StatefulWidget {
  final Message message;
  final Function? onleftSwip;
  final bool color;

  const MessageBubble(
      {Key? key,
      required this.color,
      required this.message,
      required this.onleftSwip})
      : super(key: key);

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  String selectedEmoji = '';

  @override
  Widget build(BuildContext context) {
    bool isMe = widget.message.sentBySeller == 1;

    String? baseUrl =
        Provider.of<ChatProvider>(context, listen: false).userTypeIndex == 0
            ? Provider.of<SplashProvider>(context, listen: false)
                .baseUrls!
                .customerImageUrl
            : Provider.of<SplashProvider>(context, listen: false)
                .baseUrls!
                .sellerImageUrl;
    String? image =
        Provider.of<ChatProvider>(context, listen: false).userTypeIndex == 0
            ? widget.message.customer != null
                ? widget.message.customer?.image
                : ''
            : widget.message.deliveryMan!.image;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        isMe
            ? const SizedBox.shrink()
            : InkWell(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (_) => CustomrScreen(
                  //           seller: Provider.of<SellerProvider>(context,
                  //               listen: false)
                  //               .sellerModel)));
                },
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: CachedNetworkImage(
                      errorWidget: (ctx, url, err) => Image.asset(
                        Images.placeholderImage,
                        height: Dimensions.chatImage,
                        width: Dimensions.chatImage,
                        fit: BoxFit.cover,
                      ),
                      placeholder: (ctx, url) =>
                          Image.asset(Images.placeholderImage),
                      imageUrl: '$baseUrl/$image',
                      height: Dimensions.chatImage,
                      width: Dimensions.chatImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
        Expanded(
          child: GestureDetector(
            onLongPress: () {
              // _showEmojiPicker(context);
            },
            onTap: () {
              if (widget.message.fileUrl != null) {
                if (widget.message.messageType == "audio") {
                  // TODO: Handle audio file tapping
                } else if (widget.message.messageType == "image") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MediaViewerPage(
                        imageUrl: widget.message.fileUrl,
                        timestamp: widget.message.createdAt.toString(),
                      ),
                    ),
                  );
                }
              }
            },
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment:
                      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        margin: isMe
                            ? const EdgeInsets.fromLTRB(70, 5, 10, 5)
                            : const EdgeInsets.fromLTRB(10, 5, 70, 5),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(10),
                            bottomLeft: isMe
                                ? const Radius.circular(10)
                                : const Radius.circular(0),
                            bottomRight: isMe
                                ? const Radius.circular(0)
                                : const Radius.circular(10),
                            topRight: const Radius.circular(10),
                          ),
                          color: isMe
                              ? ColorResources.getImageBg(context)
                              : Theme.of(context).highlightColor,
                        ),
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            // !isMe
                            //     ? Text(
                            //   dateTime,
                            //   style: titilliumRegular.copyWith(
                            //     fontSize: Dimensions.fontSizeExtraSmall,
                            //     color: ColorResources.getHint(context),
                            //   ),
                            // )
                            //: const SizedBox.shrink(),
                            widget.message.file == null
                                ? widget.message.fileUrl != null
                                    ? widget.message.messageType == "audio"
                                        ? VoicePlayer(
                                            audioUrl: widget.message.fileUrl,
                                          )
                                        : widget.message.messageType == "video"
                                            ? Center(
                                                child: VideoPlayerWithControls(
                                                toBig: true,
                                                timestamp: widget
                                                    .message.createdAt
                                                    .toString(),
                                                videoUrl:
                                                    widget.message.fileUrl!,
                                              ))
                                            : CachedNetworkImage(
                                                imageUrl:
                                                    widget.message.fileUrl!,
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              )
                                    : widget.message.message!.isNotEmpty
                                        ? Text(
                                            widget.message.message!,
                                            textAlign: TextAlign.justify,
                                            style: titilliumRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                            ),
                                          )
                                        : const SizedBox.shrink()
                                : widget.message.messageType == "audio"
                                    ? VoicePlayer(
                                        audioFile: widget.message.file,
                                      )
                                    : widget.message.messageType == "video"
                                        ? Center(
                                            child: VideoPlayerWithControls(
                                            toBig: true,
                                            timestamp: widget.message.createdAt
                                                .toString(),
                                            videoFile: widget.message.file,
                                          ))
                                        : Image(image: FileImage(widget.message.file!),),

                            // CachedNetworkImage(
                            //                 imageUrl: widget.message.fileUrl!,
                            //                 placeholder: (context, url) =>
                            //                     const CircularProgressIndicator(),
                            //                 errorWidget:
                            //                     (context, url, error) =>
                            //                         const Icon(Icons.error),
                            //               ),

                            widget.message.fileUrl != null
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      widget.message.message!,
                                      textAlign: TextAlign.justify,
                                      style: titilliumRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),

                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              "    ${DateConverter.localDateToIsoStringAMPM(
                                DateTime.parse(
                                    widget.message.createdAt.toString()),
                              )}    ",
                              style: const TextStyle(fontSize: 7.5),
                            ),
                            isMe
                                ? widget.message.seenBySeller != null
                                    ? widget.color
                                        ? const Icon(
                                            Icons.check_box,
                                            size: 10,
                                            color: Colors.green,
                                          )
                                        : const Icon(
                                            Icons.check_box,
                                            size: 10,
                                            color: Colors.red,
                                          )
                                    : widget.message.file != null
                                        ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                                width: 20,
                                                height: 20,
                                                // color: Colors.red,
                                                child: const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              ),
                                          ],
                                        )
                                        // GestureDetector()
                                        : const Icon(
                                            Icons.check,
                                            size: 10,
                                          )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                    widget.message.selectedEmoji != null
                        ? Text(
                            widget.message.selectedEmoji!,
                            style: const TextStyle(fontSize: 16),
                          )
                        : const Text("")
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

// Update the _showEmojiPicker method to handle the selection
  void _showEmojiPicker(BuildContext context) async {
    selectedEmoji = (await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 25,
          backgroundColor: ColorResources.getImageBg(context),
          shadowColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: SizedBox(
            height: 300,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                // setState(() {
                //   widget.message.selectedEmoji = emoji.emoji;
                //   Navigator.pop(context);
                // });
              },
            ),
          ),
        );
      },
    ))!;

    // Add the selected emoji to the message
    setState(() {
      widget.message.selectedEmoji = selectedEmoji;
    });
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/chat_model.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/provider/chat_provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_snackbar.dart';
import 'package:sixvalley_vendor_app/view/screens/chat/chat_screen.dart';

import '../../../base/custom_image.dart';

class ChatCardWidget extends StatefulWidget {
  final Chat? chat;
  final int? index ;
  const ChatCardWidget({Key? key, this.chat, this.index}  ) : super(key: key);

  @override
  State<ChatCardWidget> createState() => _ChatCardWidgetState();
}

class _ChatCardWidgetState extends State<ChatCardWidget> {
  @override
  Widget build(BuildContext context) {
    String? baseUrl = Provider.of<ChatProvider>(context, listen: false).userTypeIndex == 0 ?
    Provider.of<SplashProvider>(context, listen: false).baseUrls!.customerImageUrl:
    Provider.of<SplashProvider>(context, listen: false).baseUrls!.deliveryManImageUrl;

    int? id = Provider.of<ChatProvider>(context, listen: false).userTypeIndex == 0 ?
    widget.chat!.customer?.id?? -1 : widget.chat!.deliveryManId;

    String? image = Provider.of<ChatProvider>(context, listen: false).userTypeIndex == 0 ?
    widget.chat!.customer != null? widget.chat!.customer?.image :'' : widget.chat!.deliveryMan?.image;

    String name = Provider.of<ChatProvider>(context, listen: false).userTypeIndex == 0 ?
    widget.chat!.customer != null?
    '${widget.chat!.customer?.fName} ${widget.chat!.customer?.lName}' :'Customer Deleted' :
    '${widget.chat!.deliveryMan?.fName??'Deliveryman'} ${widget.chat!.deliveryMan?.lName??'Deleted'}';


    return Column(
      children: [
        ListTile(
          leading: ClipOval(
              child: Container(
                width: 70,
                  height: 70,
                  color: Theme.of(context).highlightColor,
                  child: CustomImage(image: '$baseUrl/$image'))),

          title: Text(name, style: titilliumSemiBold),

          subtitle: Text(widget.chat!.message!, maxLines: 4,overflow: TextOverflow.ellipsis,
              style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),

          trailing: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(DateConverter.localDateToIsoStringAMPM(DateTime.parse(widget.chat!.createdAt!)),
                style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),

          ]),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) {
            return ChatScreen( name: name, userId: id, index:  widget.index);
          })),
        ),
        const Divider(height: 2, color: ColorResources.chatIconColor),
      ],
    );
  }
}

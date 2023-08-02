import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/order_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_image.dart';

import '../../../../data/model/response/review_model.dart';
import '../../../../provider/order_provider.dart';
import '../../../../provider/product_details_provider.dart';
import '../../../base/rating_bar.dart';
import '../../review/almohsen_review/review_dialog.dart';
import '../../review/almohsen_review/review_screen.dart';
import '../../review/almohsen_review/review_widget.dart';

class CustomerContactWidget extends StatelessWidget {
  final Order? orderModel;
  final String? averageReview;
  final List<ReviewModel>? reviewList;

  final Function? callback;

  const CustomerContactWidget(
      {Key? key,
      this.averageReview,
      this.reviewList,
      this.callback,
      this.orderModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault,
          vertical: Dimensions.paddingSizeMedium),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: ThemeShadow.getShadow(context)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(getTranslated('customer_information', context)!,
            style: robotoMedium.copyWith(
              color: ColorResources.titleColor(context),
              fontSize: Dimensions.fontSizeLarge,
            )),
        const SizedBox(height: Dimensions.paddingSizeDefault),
        Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CustomImage(
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                    image:
                        '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.customerImageUrl}/${orderModel!.customer!.image}')),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    '${orderModel!.customer!.fName ?? ''} '
                    '${orderModel!.customer!.lName ?? ''}',
                    style: titilliumRegular.copyWith(
                        color: ColorResources.titleColor(context),
                        fontSize: Dimensions.fontSizeDefault)),
                const SizedBox(
                  height: Dimensions.paddingSizeExtraSmall,
                ),
                Text('${orderModel!.customer!.phone}',
                    style: titilliumRegular.copyWith(
                        color: ColorResources.titleColor(context),
                        fontSize: Dimensions.fontSizeDefault)),
                const SizedBox(
                  height: Dimensions.paddingSizeExtraSmall,
                ),
                Text(orderModel!.customer!.email ?? '',
                    style: titilliumRegular.copyWith(
                        color: ColorResources.titleColor(context),
                        fontSize: Dimensions.fontSizeDefault)),
              ],
            )),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Column(
              children: [
                Container(
                  width: 150,
                  height: 45,
                  decoration: BoxDecoration(
                    color: ColorResources.grey,
                    borderRadius:
                        BorderRadius.circular(Dimensions.paddingSizeExtraLarge),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${double.parse(averageReview!= null ? '$averageReview' : "0.0" ).toStringAsFixed(1)} ${getTranslated('out_of_5', context) ?? "out_of_5"}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RatingBar(
                            rating: double.parse(averageReview != null ? '$averageReview' : "0.0" ),
                            // rating: double.parse(averageReview!),
                            size: 20,
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                5 == 5
                // مراجعة ؟
                    ? InkWell(
                        onTap: () {
                          // if(Provider.of<OrderProvider>(context, listen: false).orderTypeIndex == 1) {
                          Provider.of<ProductDetailsProvider>(context,
                                  listen: false)
                              .removeData();
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => ReviewBottomSheet(
                                  customerID:
                                      orderModel!.customer!.id.toString(),
                                  callback: callback));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: Dimensions.paddingSizeSmall),
                          padding: const EdgeInsets.symmetric(
                              vertical: Dimensions.paddingSizeExtraSmall,
                              horizontal: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                Dimensions.paddingSizeDefault),
                            border: Border.all(
                                width: 1,
                                color: Theme.of(context).primaryColor),
                          ),
                          child: Text(getTranslated('review', context)!,
                              style: titilliumRegular.copyWith(
                                fontSize: Dimensions.fontSizeExtraSmall,
                                color: ColorResources.getTextTitle(context),
                              )),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            )
          ],
        )
      ]),
    );
  }
}

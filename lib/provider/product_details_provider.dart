import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/data/model/body/review_body.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
// import 'package:sixvalley_vendor_app/data/model/response/product_details_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/response_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/review_model.dart';
import 'package:sixvalley_vendor_app/data/repository/product_details_repo.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/provider/product_provider.dart';
import 'package:sixvalley_vendor_app/view/base/custom_snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProductDetailsProvider extends ChangeNotifier {
  final ProductDetailsRepo? productDetailsRepo;
  ProductDetailsProvider({required this.productDetailsRepo});

  List<ReviewModel>? _reviewList;
  int? _imageSliderIndex;
  bool _wish = false;
  int? _quantity = 0;
  int? _variantIndex;
  List<int>? _variationIndex;
  int _rating = 0;
  bool _isLoading = false;
  int? _orderCount;
  int? _wishCount;
  String? _sharableLink;
  String? _errorText;
  bool _hasConnection = true;
  bool _isDetails = false;
  bool get isDetails =>_isDetails;

  List<ReviewModel>? get reviewList => _reviewList;
  int? get imageSliderIndex => _imageSliderIndex;
  bool get isWished => _wish;
  int? get quantity => _quantity;
  int? get variantIndex => _variantIndex;
  List<int>? get variationIndex => _variationIndex;
  int get rating => _rating;
  bool get isLoading => _isLoading;
  int? get orderCount => _orderCount;
  int? get wishCount => _wishCount;
  String? get sharableLink => _sharableLink;
  String? get errorText => _errorText;
  bool get hasConnection => _hasConnection;
  // ProductDetailsModel? _productDetailsModel;
  // ProductDetailsModel? get productDetailsModel => _productDetailsModel;



  // Future<void> getProductDetails(BuildContext context, String productId) async {
  //
  //   _isDetails = true;
  //   ApiResponse apiResponse = await productDetailsRepo!.getProduct(productId);
  //
  //   if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
  //     _isDetails = false;
  //     _productDetailsModel = ProductDetailsModel.fromJson(apiResponse.response!.data);
  //     if(_productDetailsModel != null){
  //       Provider.of<ProductProvider>(Get.context!, listen: false).initSellerProductList(Provider.of<ProductDetailsProvider>(Get.context!, listen: false).productDetailsModel!.userId.toString(), 1, Get.context!);
  //     }
  //
  //   } else {
  //     _isDetails = false;
  //     if(context.mounted){}
  //     showCustomSnackBar(apiResponse.error.toString(), Get.context!);
  //   }
  //   _isDetails = false;
  //   notifyListeners();
  // }


  Future<void> initProduct(int? customerId, BuildContext context) async {
    _hasConnection = true;
    _variantIndex = 0;
    ApiResponse reviewResponse = await productDetailsRepo!.getReviews(customerId.toString());
    if (reviewResponse.response != null && reviewResponse.response!.statusCode == 200) {
      // productDetailsRepo!.getProduct(productSlug.toString());
      _reviewList = [];
      reviewResponse.response!.data.forEach((reviewModel) => _reviewList!.add(ReviewModel.fromJson(reviewModel)));
      _imageSliderIndex = 0;
      _quantity = 1;
    } else {
      if(context.mounted){}
      ApiChecker.checkApi( reviewResponse);
    }
    notifyListeners();
  }


  // void initData(ProductDetailsModel product, int? minimumOrderQuantity, BuildContext context) {
  //   _variantIndex = 0;
  //   _quantity = minimumOrderQuantity;
  //   _variationIndex = [];
  //   for (int i=0; i<= product.choiceOptions!.length; i++) {
  //     _variationIndex!.add(0);
  //   }
  // }

  void removePrevReview() {
    _reviewList = null;
    _sharableLink = null;
  }

  // void getCount(String productID, BuildContext context) async {
  //   ApiResponse apiResponse = await productDetailsRepo!.getCount(productID);
  //   if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
  //     _orderCount = apiResponse.response!.data['order_count'];
  //     _wishCount = apiResponse.response!.data['wishlist_count'];
  //   } else {
  //     if(context.mounted){}
  //     ApiChecker.checkApi( apiResponse);
  //   }
  //   notifyListeners();
  // }

  // void getSharableLink(String productID, BuildContext context) async {
  //   ApiResponse apiResponse = await productDetailsRepo!.getSharableLink(productID);
  //   if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
  //     _sharableLink = apiResponse.response!.data;
  //   } else {
  //     if(context.mounted){}
  //     ApiChecker.checkApi( apiResponse);
  //   }
  // }

  void setErrorText(String? error) {
    _errorText = error;
    notifyListeners();
  }

  void removeData() {
    _errorText = null;
    _rating = 0;
    notifyListeners();
  }

  void setImageSliderSelectedIndex(int selectedIndex) {
    _imageSliderIndex = selectedIndex;
    notifyListeners();
  }

  void changeWish() {
    _wish = !_wish;
    notifyListeners();
  }

  void setQuantity(int value) {
    _quantity = value;
    notifyListeners();
  }

  void setCartVariantIndex(int? minimumOrderQuantity,int index, BuildContext context) {
    _variantIndex = index;
    _quantity = minimumOrderQuantity;
    notifyListeners();
  }

  void setCartVariationIndex(int? minimumOrderQuantity, int index, int i, BuildContext context) {
    _variationIndex![index] = i;
    _quantity = minimumOrderQuantity;
    notifyListeners();
  }

  void setRating(int rate) {
    _rating = rate;
    notifyListeners();
  }

  Future<ResponseModel> submitReview(ReviewBody reviewBody, List<File> files, String token) async {
    _isLoading = true;
    notifyListeners();

    http.StreamedResponse response = await productDetailsRepo!.submitReview(reviewBody, files, token);
    ResponseModel responseModel;
    if (response.statusCode == 200 ||  response.statusCode == 201) {
      _rating = 0;
      responseModel = ResponseModel(true , 'Review submitted successfully');
      _errorText = null;
      notifyListeners();
    } else {
      if (kDebugMode) {
        print('${response.statusCode} ${response.reasonPhrase}');
      }
      responseModel = ResponseModel( false, '${response.statusCode} ${response.reasonPhrase}');
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }
}

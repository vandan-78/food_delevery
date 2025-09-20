import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvvm_folder_strucutre/Model/product_model.dart';
import '../Core/Config/app_urls.dart';
import '../Data/Network/network_api_service.dart';

class ProductRepository {
  // final _apiService = NetworkApiService();

  Future<ProductResponse> fetchProductData() async {
    try{
      // final response = await _apiService.getApiResponse(AppUrl.dummyJsonProduct);
      // debugPrint("Product Data: ${ProductResponse.fromJson(response)}");
      String jsonString = await rootBundle.loadString('assets/fast_food_products.json');
      final data = json.decode(jsonString);
      return ProductResponse.fromJson(data);

    }catch(e){
      rethrow;
    }
  }


}
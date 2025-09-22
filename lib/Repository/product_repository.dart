import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvvm_folder_strucutre/Model/product_model.dart';
import '../Core/Config/app_urls.dart';
import '../Data/Network/network_api_service.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Product>> fetchProductData() async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .orderBy('id') // ✅ ensures proper numeric order
          .get();

      final products = snapshot.docs
          .map((doc) => Product.fromJson(doc.data()))
          .toList();

      return products;
    } catch (e) {
      throw Exception("Error fetching products: $e");
    }
  }
}
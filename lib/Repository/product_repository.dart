import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mvvm_folder_strucutre/Model/product_model.dart';


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

// class ProductRepository {
//   // final _apiService = NetworkApiService();
//   Future<List<Product>> fetchProductData() async {
//     try {
//       // final response = await _apiService.getApiResponse(AppUrl.dummyJsonProduct);
//       // debugPrint("Product Data: ${ProductResponse.fromJson(response)}");
//       String jsonString = await rootBundle.loadString('assets/fast_food_products.json');
//       final data = json.decode(jsonString);
//       return ProductResponse.fromJson(data).products;
//     } catch (e) {
//       rethrow;
//     }
//   }
// }



// class FirestoreUploader {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//   Future<void> uploadProductsFromJson() async {
//     try {
//       // Load JSON file
//       String jsonString = await rootBundle.loadString('assets/fast_food_products.json');
//       final Map<String, dynamic> data = json.decode(jsonString);
//
//       // Parse into ProductResponse
//       ProductResponse response = ProductResponse.fromJson(data);
//
//       // Upload each product
//       WriteBatch batch = firestore.batch();
//       for (var product in response.products) {
//         final docRef = firestore.collection('products').doc(product.id.toString());
//         batch.set(docRef, product.toJson());
//       }
//
//       await batch.commit();
//       print("✅ ${response.products.length} products uploaded to Firestore!");
//     } catch (e) {
//       print("❌ Error uploading products: $e");
//     }
//   }
// }
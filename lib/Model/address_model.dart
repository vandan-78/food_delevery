import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  final String id;
  final String userId;
  final String label;
  final String address;
  final bool isDefault;
  final Timestamp createdAt;

  AddressModel({
    required this.id,
    required this.userId,
    required this.label,
    required this.address,
    required this.isDefault,
    required this.createdAt,
  });

  // Firestore -> Model
  factory AddressModel.fromMap(Map<String, dynamic> map, String docId) {
    return AddressModel(
      id: docId,
      userId: map['userId'] ?? '',
      label: map['label'] ?? '',
      address: map['address'] ?? '',
      isDefault: map['isDefault'] ?? false,
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }

  // Model -> Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'label': label,
      'address': address,
      'isDefault': isDefault,
      'createdAt': createdAt,
    };
  }

  // ✅ Add copyWith
  AddressModel copyWith({
    String? id,
    String? userId,
    String? label,
    String? address,
    bool? isDefault,
    Timestamp? createdAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      label: label ?? this.label,
      address: address ?? this.address,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

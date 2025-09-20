import '../address_model.dart';

class AddressState {
  final List<AddressModel> addresses;
  final bool isLoading;
  final String? errorMessage;

  AddressState({
    required this.addresses,
    this.isLoading = false,
    this.errorMessage,
  });

  factory AddressState.initial() {
    return AddressState(
      addresses: [],
      isLoading: false,
      errorMessage: null,
    );
  }

  AddressState copyWith({
    List<AddressModel>? addresses,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AddressState(
      addresses: addresses ?? this.addresses,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../Repository/payment_service.dart';
// import '../core/theme/text_styles.dart';
//
// class CheckoutScreen extends ConsumerStatefulWidget {
//   final double subtotal;
//   final double shipping;
//   final double tax;
//   final double total;
//
//   const CheckoutScreen({
//     super.key,
//     required this.subtotal,
//     required this.shipping,
//     required this.tax,
//     required this.total,
//   });
//
//   @override
//   ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
// }
//
// class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
//   late PaymentService _paymentService;
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _paymentService = PaymentService();
//   }
//
//   @override
//   void dispose() {
//     _paymentService.dispose();
//     super.dispose();
//   }
//
//   Future<void> _startPayment() async {
//     setState(() => _isLoading = true);
//
//     try {
//       await _paymentService.startPayment(
//         widget.total,
//         FirebaseAuth.instance.currentUser?.email ?? '',
//         "9876543210", // TODO: get user phone number
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Error: $e"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDarkMode = theme.brightness == Brightness.dark;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Checkout',
//           style: TextStyles.titleLarge.copyWith(
//             color: isDarkMode ? Colors.white : Colors.black,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
//       ),
//       body: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               children: [
//                 // Order Summary ...
//                 const Spacer(),
//
//                 _buildPaymentButton(theme, isDarkMode),
//               ],
//             ),
//           ),
//
//           if (_isLoading)
//             Container(
//               color: Colors.black.withOpacity(0.3),
//               child: Center(
//                 child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation(theme.primaryColor),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPaymentButton(ThemeData theme, bool isDarkMode) {
//     return ElevatedButton(
//       onPressed: _isLoading ? null : _startPayment,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: theme.primaryColor,
//         minimumSize: const Size(double.infinity, 56),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//       ),
//       child: Text(
//         "Pay Securely ₹${widget.total.toStringAsFixed(2)}",
//         style: TextStyles.buttonLarge.copyWith(
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }

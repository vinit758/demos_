/// INTEGRATION POINT: Razorpay (or another Indian gateway).
/// 1) Create an order on YOUR backend (never put secret keys in Flutter).
/// 2) Open the gateway checkout with the returned order id.
/// 3) Verify the payment signature on your backend, then clear the cart.
class PaymentService {
  static Future<void> startPayment({required int amountInRupees, required Map<String, String> customer}) async {
    throw UnimplementedError('Payment gateway not configured. See lib/services/payment_service.dart');
  }
}

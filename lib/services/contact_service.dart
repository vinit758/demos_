/// INTEGRATION POINT: connect these to your backend / form service
/// (Firebase, Formspree, your own API, Mailchimp...). Until then they throw
/// and the UI tells the visitor the form is not connected yet.
class ContactService {
  static Future<void> send({required String name, required String email, required String phone, required String message}) async {
    throw UnimplementedError('Connect a backend in lib/services/contact_service.dart');
  }

  static Future<void> subscribe(String email) async {
    throw UnimplementedError('Connect a newsletter provider in lib/services/contact_service.dart');
  }
}

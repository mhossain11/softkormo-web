import '../../../core/services/firebase_service.dart';
import '../../../shared/models/contact_model.dart';

/// Data-source contract for contact submissions (Domain layer depends on
/// this abstraction, not on Firebase directly).
abstract class ContactRepository {
  Future<void> submit(ContactModel contact);
}

/// Firestore implementation stored in the `contacts` collection.
class FirestoreContactRepository implements ContactRepository {
  const FirestoreContactRepository();

  static const String _collection = 'contacts';

  @override
  Future<void> submit(ContactModel contact) async {
    await FirebaseService.submitDocument(_collection, contact.toMap());
  }
}

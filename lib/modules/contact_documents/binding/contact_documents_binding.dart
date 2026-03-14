import 'package:get/get.dart';
import '../controller/contact_documents_controller.dart';

class ContactDocumentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactDocumentsController>(() => ContactDocumentsController());
  }
}
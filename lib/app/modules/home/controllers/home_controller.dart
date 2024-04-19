import 'package:get/get.dart';
import 'package:machine_test_nectar/app/data/db/app_db.dart';
import 'package:machine_test_nectar/app/data/models/document_model.dart';
import 'package:machine_test_nectar/app/routes/app_pages.dart';

class HomeController extends GetxController {
  final RxInt selectedFileFormatIndex = 0.obs;

  final documentList = <DocumnetModel>[].obs;
  final filteredDocumentList = <DocumnetModel>[].obs;

  final fileFormats = <String>[].obs;
  final selectedFileFormat = ''.obs;

  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 1), () {
      _loadProductsFromDatabase();
    });
    super.onInit();
  }

  /// Fetch products from the database
  Future<void> _loadProductsFromDatabase() async {
    final documentDb = DocumentDbHelper();
    final documents = await documentDb.getDocuments();
    final files = await documentDb.getFileFormats();
    documentList.assignAll(documents);
    filteredDocumentList.assignAll(documents);
    documentList.value = documentList.reversed.toList();
    fileFormats.assignAll(files);
    selectedFileFormat.value = fileFormats.first;
    isLoading.value = false;
    update();
  }

  /// Filter documents based on the selected file format
  Future<void> filterDocuments() async {
    if (selectedFileFormat.value == "All") {
      filteredDocumentList.assignAll(documentList);
    } else {
      final filteredDocuments = documentList
          .where(
              (document) => document.documentType == selectedFileFormat.value)
          .toList();
      filteredDocumentList.assignAll(filteredDocuments);
    }
  }

  void goToCreatePage() {
    Get.toNamed(Routes.create)?.whenComplete(() {
      _loadProductsFromDatabase();
    });
  }

  bool isDateExpired(int index) {
    if (documentList[index].expiryDate != null) {
      return documentList[index].expiryDate!.isBefore(DateTime.now());
    }
    return false;
  }

  void goToDetailsPage({required DocumnetModel doc}) {
    Get.toNamed(
      Routes.create,
      arguments: {
        'document': doc,
      },
    )?.whenComplete(() {
      _loadProductsFromDatabase();
    });
  }
}

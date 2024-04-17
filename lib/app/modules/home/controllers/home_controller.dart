import 'package:get/get.dart';
import 'package:machine_test_nectar/app/data/db/app_db.dart';
import 'package:machine_test_nectar/app/data/models/document_model.dart';
import 'package:machine_test_nectar/app/routes/app_pages.dart';

class HomeController extends GetxController {
  final RxInt selectedFileFormatIndex = 0.obs;

  final documntList = <DocumnetModel>[].obs;

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
    documntList.assignAll(documents);
    documntList.value = documntList.reversed.toList();
    isLoading.value = false;
    update();
  }

  void goToCreatePage() {
    Get.toNamed(Routes.create)?.whenComplete(() {
      _loadProductsFromDatabase();
    });
  }

  bool isDateExpired(int index) {
    if (documntList[index].expiryDate != null) {
      return documntList[index].expiryDate!.isBefore(DateTime.now());
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

import 'package:get/get.dart';
import 'package:machine_test_nectar/app/data/db/app_db.dart';
import 'package:machine_test_nectar/app/data/models/document_model.dart';
import 'package:machine_test_nectar/app/modules/home/models/filter_model.dart';
import 'package:machine_test_nectar/app/routes/app_pages.dart';

class HomeController extends GetxController {
  RxList<FilterModel> fileFormats = <FilterModel>[
    FilterModel(title: 'All', isSelected: true),
    FilterModel(title: 'pdf'),
    FilterModel(title: 'doc'),
    FilterModel(title: 'xlsx'),
    FilterModel(title: 'mp4'),
    FilterModel(title: 'mp3'),
    FilterModel(title: 'png'),
  ].obs;

  final documntList = <DocumnetModel>[].obs;

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
  }

  /// function for displaying selected filters
  void filterItems(String filter) {
    for (var element in fileFormats) {
      element.isSelected = false;
      if (element.title == filter) {
        element.isSelected = true;
      }
    }
    update();
    fileFormats.refresh();
  }

  void goToCreatePage() {
    Get.toNamed(Routes.create)?.whenComplete(() {
      _loadProductsFromDatabase();
    });
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

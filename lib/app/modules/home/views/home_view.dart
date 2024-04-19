import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:machine_test_nectar/app/modules/home/controllers/home_controller.dart';
import 'package:machine_test_nectar/app/modules/home/widgets/item_list_widget.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.purple.shade100,
        actions: [
          Obx(() {
            return Visibility(
              visible: controller.fileFormats.isNotEmpty &&
                  controller.documentList.isNotEmpty,
              child: PopupMenuButton<String>(
                position: PopupMenuPosition.under,
                initialValue: controller.selectedFileFormat.value,
                itemBuilder: (BuildContext context) {
                  return controller.fileFormats.map((String e) {
                    return PopupMenuItem<String>(
                      value: e,
                      child: Text(e),
                    );
                  }).toList();
                },
                onSelected: (value) {
                  controller.selectedFileFormat.value = value;
                  controller.filterDocuments();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(Icons.filter_list_rounded),
                ),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        return controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : controller.filteredDocumentList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/json/no_data.json',
                          height: 200.0,
                          width: 200.0,
                        ),
                        const Text(
                          'No documents found',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                : const ItemListWidget();
      }),
      floatingActionButton: FloatingActionButton(
        heroTag: 'home',
        onPressed: () => controller.goToCreatePage(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

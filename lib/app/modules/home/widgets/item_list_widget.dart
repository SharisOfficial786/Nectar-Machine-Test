import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:machine_test_nectar/app/modules/home/controllers/home_controller.dart';

class ItemListWidget extends GetView<HomeController> {
  const ItemListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: controller.filteredDocumentList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              controller.goToDetailsPage(
                doc: controller.filteredDocumentList[index],
              );
            },
            child: Container(
              width: Get.width,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: controller.isDateExpired(index)
                    ? Colors.grey.shade100
                    : Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.filteredDocumentList[index].title ?? '',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: controller.isDateExpired(index)
                              ? Colors.red.shade200
                              : null,
                        ),
                      ),
                      if (controller.filteredDocumentList[index].expiryDate != null) ...[
                        const SizedBox(height: 5.0),
                        Text(
                          controller.filteredDocumentList[index].expiryDate
                              .toString()
                              .split(' ')
                              .first,
                          style: TextStyle(
                            color: controller.isDateExpired(index)
                                ? Colors.red.shade200
                                : null,
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    controller.filteredDocumentList[index].filePath
                        .toString()
                        .split('.')
                        .last,
                    style: TextStyle(
                      fontSize: 10.0,
                      color: controller.isDateExpired(index)
                          ? Colors.red.shade200
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (_, __) {
          return const SizedBox(height: 10.0);
        },
      );
    });
  }
}

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:machine_test_nectar/app/modules/home/controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: List.generate(controller.fileFormats.length, (index) {
                return Obx(() {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      controller
                          .filterItems(controller.fileFormats[index].title);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 20.0,
                      ),
                      margin: EdgeInsets.only(
                        right: index == controller.fileFormats.length - 1
                            ? 0.0
                            : 10.0,
                      ),
                      decoration: BoxDecoration(
                        color: controller.fileFormats[index].isSelected
                            ? Colors.deepPurple[100]
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(controller.fileFormats[index].title),
                    ),
                  );
                });
              }),
            ),
          ),
          Expanded(
            child: Obx(() {
              return controller.documntList.isEmpty
                  ? const CircularProgressIndicator()
                  : ListView.separated(
                      itemCount: controller.documntList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            controller.documntList[index].title ?? '',
                          ),
                          subtitle: Text(
                            controller.documntList[index].expiryDate
                                .toString()
                                .split(' ')
                                .first,
                          ),
                          trailing: Text(
                            controller.documntList[index].filePath
                                .toString()
                                .split('.')
                                .last,
                          ),
                          onTap: () {
                            controller.goToDetailsPage(
                              doc: controller.documntList[index],
                            );
                          },
                        );
                      },
                      separatorBuilder: (_, __) {
                        return const SizedBox(height: 10.0);
                      },
                    );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'home',
        onPressed: () => controller.goToCreatePage(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

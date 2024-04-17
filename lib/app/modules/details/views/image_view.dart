import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:machine_test_nectar/app/modules/details/controllers/details_controller.dart';

class ImageView extends StatefulWidget {
  const ImageView({super.key});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView>
    with SingleTickerProviderStateMixin {
  DetailsController controller = Get.put(DetailsController());

  late TransformationController transformationController;
  TapDownDetails? tapDownDetails;

  late AnimationController animationController;
  Animation<Matrix4>? animation;

  final double minScale = 1;
  final double maxScale = 3;

  @override
  void initState() {
    transformationController = TransformationController();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        transformationController.value = animation!.value;
      });

    super.initState();
  }

  @override
  void dispose() {
    transformationController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        centerTitle: true,
        backgroundColor: Colors.purple.shade100,
      ),
      body: GestureDetector(
        onDoubleTapDown: (details) => tapDownDetails = details,
        onDoubleTap: () {
          final position = tapDownDetails!.localPosition;

          const double scale = 3;
          final x = -position.dx * (scale - 1);
          final y = -position.dy * (scale - 1);
          final zoomed = Matrix4.identity()
            ..translate(x, y)
            ..scale(scale);

          final end = transformationController.value.isIdentity()
              ? zoomed
              : Matrix4.identity();

          animation = Matrix4Tween(
            begin: transformationController.value,
            end: end,
          ).animate(
            CurveTween(curve: Curves.easeOut).animate(animationController),
          );
          animationController.forward(from: 0);
        },
        child: InteractiveViewer(
          transformationController: transformationController,
          clipBehavior: Clip.none,
          minScale: minScale,
          maxScale: maxScale,
          child: Image.file(
            File(controller.filePath),
            height: Get.height,
            width: Get.width,
          ),
        ),
      ),
    );
  }
}

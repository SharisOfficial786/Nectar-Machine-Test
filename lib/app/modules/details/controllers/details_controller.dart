import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class DetailsController extends GetxController {
  String filePath = Get.arguments['filePath'];

  AudioPlayer player = Get.arguments?['audioPlayer'];
}

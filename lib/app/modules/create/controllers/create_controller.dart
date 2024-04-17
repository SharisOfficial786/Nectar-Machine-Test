import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:machine_test_nectar/app/data/db/app_db.dart';
import 'package:machine_test_nectar/app/data/models/document_model.dart';
import 'package:machine_test_nectar/app/modules/create/models/file_selector_model.dart';
import 'package:machine_test_nectar/app/modules/details/views/audio_player_view.dart';
import 'package:machine_test_nectar/app/modules/details/views/audio_recorder_view.dart';
import 'package:machine_test_nectar/app/routes/app_pages.dart';
import 'package:machine_test_nectar/app/widgets/app_snackbar.dart';
import 'package:open_file_plus/open_file_plus.dart';

class CreateController extends GetxController with GetTickerProviderStateMixin {
  late AnimationController _animationController;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final ImagePicker picker = ImagePicker();
  late AudioPlayer player;

  DocumnetModel? documentData = Get.arguments?['document'];

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController fileTypeController = TextEditingController();
  Rx<File?> file = Rx<File?>(null);
  final RxBool showLinearprogressIndicator = true.obs;
  final RxBool showPadding = false.obs;

  String? get filePath => file.value?.path.split('/').last;

  final List<String> fileFormats = [
    'Document',
    'Video',
    'Audio',
    'Image',
  ];

  List<FileSelectorModel> fileSelectorList = [];

  @override
  void onInit() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animationController.forward();

    _loadEditableData();

    fileSelectorList = [
      FileSelectorModel(
        title: 'Photo',
        icon: 'camera',
        onTap: () async {
          accessCamera(isVideo: false);
        },
      ),
      FileSelectorModel(
        title: 'Video',
        icon: 'video',
        onTap: () {
          accessCamera(isVideo: true);
        },
      ),
      FileSelectorModel(
        title: 'Audio',
        icon: 'audio',
        onTap: () => showRecordPopUp(),
      ),
      FileSelectorModel(
        title: 'Doc',
        icon: 'document',
        onTap: () async => await selectFile(),
      ),
    ];

    super.onInit();
  }

  /// for loading data for edit
  void _loadEditableData() {
    if (documentData != null) {
      titleController.text = documentData?.title ?? '';
      descriptionController.text = documentData?.description ?? '';
      expiryDateController.text = documentData?.expiryDate != null
          ? (documentData?.expiryDate.toString().split(' ').first ?? '')
          : '';
      fileTypeController.text = documentData?.documentType ?? '';
      file.value = File(documentData?.filePath ?? '');
    }
  }

  /// for checking alphabets only
  bool isAlphabet(String text) {
    final RegExp alphabetExp = RegExp(r'^[a-zA-Z]+$');
    return alphabetExp.hasMatch(text);
  }

  /// for selecting file
  Future<void> selectFile() async {
    Get.back();
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file.value = File(result.files.single.path!);
      update();
    }
  }

  /// for removing file
  void removeFile() {
    file.value = null;
    showLinearprogressIndicator.value = true;
    showPadding.value = false;
  }

  /// for showing date picker
  Future<void> pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      expiryDateController.text = pickedDate.toString().split(' ').first;
    }
  }

  /// for selecting doc type
  void selectDocTypeFromDropdown(String type) {
    fileTypeController.text = type;
    update();
  }

  /// for recording video/capture photo from camera / gallery
  Future<void> accessCamera({required isVideo}) async {
    Get.back();
    XFile? cameraFile;

    if (isVideo) {
      cameraFile = await picker.pickVideo(source: ImageSource.camera);
    } else {
      cameraFile = await picker.pickImage(source: ImageSource.camera);
    }

    if (cameraFile != null) {
      file.value = File(cameraFile.path);
    }
  }

  /// show the audio recorder
  void showRecordPopUp() {
    Get.back();
    Get.bottomSheet(
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: const AudioRecorderView(),
      ),
      isDismissible: false,
      enableDrag: false,
    ).then((value) {
      if (value != null) {
        String path = value as String;
        file.value = File(path);
      }
    });
  }

  /// insert documnet into db
  Future<void> insertDocumnetToDb() async {
    try {
      await DocumentDbHelper()
          .insertDocument(
        DocumnetModel(
          title: titleController.text,
          description: descriptionController.text,
          filePath: file.value?.path,
          expiryDate: expiryDateController.text.isNotEmpty
              ? DateTime.parse(expiryDateController.text)
              : null,
          documentType: fileTypeController.text,
        ),
      )
          .then((value) {
        if (value.isSuccess) {
          Get.back();
          AppSnackbar.showSnackbar(
            'Success',
            value.message,
          );
        } else {
          AppSnackbar.showSnackbar(
            'Failed',
            value.message,
          );
        }
      });
    } catch (error) {
      AppSnackbar.showSnackbar(
        'Error',
        'Error in adding document. Please try again later',
      );
    }
  }

  /// update the db
  Future<void> updateDocumnetToDb(int id) async {
    try {
      await DocumentDbHelper()
          .updateDocument(
        DocumnetModel(
          id: id,
          title: titleController.text,
          description: descriptionController.text,
          filePath: file.value?.path,
          expiryDate: expiryDateController.text.isNotEmpty
              ? DateTime.parse(expiryDateController.text)
              : null,
          documentType: fileTypeController.text,
        ),
      )
          .then((value) {
        if (value.isSuccess) {
          Get.back();
          AppSnackbar.showSnackbar(
            'Success',
            value.message,
          );
        } else {
          AppSnackbar.showSnackbar(
            'Failed',
            value.message,
          );
        }
      });
    } catch (error) {
      AppSnackbar.showSnackbar(
        'Error',
        'Error in updating document. Please try again later',
      );
    }
  }

  /// view the doc
  void goToDetails() {
    if (['mp4', 'mkv', 'mov', 'avi', 'webm', 'wmv']
        .contains(file.value?.path.split('.').last.toLowerCase())) {
      Get.toNamed(
        Routes.video,
        arguments: {
          'filePath': file.value?.path,
        },
      );
    } else if (['mp3', 'm4a', 'wav', 'ogg']
        .contains(file.value?.path.split('.').last.toLowerCase())) {
      _showAudioPlayerSheet();
    } else if (['jpeg', 'jpg', 'png', 'gif']
        .contains(file.value?.path.split('.').last.toLowerCase())) {
      Get.toNamed(
        Routes.image,
        arguments: {
          'filePath': file.value?.path,
        },
      );
    } else if (file.value?.path.split('.').last.toLowerCase() == 'pdf') {
      Get.toNamed(
        Routes.pdf,
        arguments: {
          'filePath': file.value?.path,
        },
      );
    } else {
      openOtherFiles();
    }
  }

  /// open other file types
  Future<void> openOtherFiles() async {
    final result = await OpenFile.open(file.value?.path);

    if (result.type == ResultType.noAppToOpen) {
      AppSnackbar.showSnackbar('Error', 'No app installed to open this file');
    }
  }

  /// show the audio player
  Future<void> _showAudioPlayerSheet() async {
    player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.stop);

    await player
        .setSource(DeviceFileSource(file.value?.path ?? ''))
        .whenComplete(() {
      Get.bottomSheet(
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    player.stop();
                    Get.back();
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
              AudioPlayerView(player: player),
            ],
          ),
        ),
        isDismissible: false,
        enableDrag: false,
      ).whenComplete(() {
        player.stop();
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    player.dispose();
    super.dispose();
  }
}

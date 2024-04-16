class DocumnetModel {
  final int? id;
  final String? title;
  final String? description;
  final String? filePath;
  final DateTime? expiryDate;
  final String? documentType;

  DocumnetModel({
    this.id,
    this.title,
    this.description,
    this.filePath,
    this.expiryDate,
    this.documentType,
  });

  factory DocumnetModel.fromMap(Map<String, dynamic> map) {
    return DocumnetModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      filePath: map['filePath'],
      expiryDate: map['expiryDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['expiryDate'])
          : null,
      documentType: map['documentType'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "filePath": filePath,
      "expiryDate": expiryDate?.millisecondsSinceEpoch,
      "documentType": documentType,
    };
  }
}

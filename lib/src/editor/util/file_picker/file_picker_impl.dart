import 'dart:typed_data';

import 'package:appflowy_editor/src/editor/util/file_picker/file_picker_service.dart';
import 'package:file_picker/file_picker.dart' as fp;

class FilePicker implements FilePickerService {
  @override
  Future<String?> getDirectoryPath({String? title}) {
    return fp.FilePicker.getDirectoryPath(dialogTitle: title);
  }

  @override
  Future<FilePickerResult?> pickFile({
    String? dialogTitle,
    String? initialDirectory,
    fp.FileType type = fp.FileType.any,
    List<String>? allowedExtensions,
    Function(fp.FilePickerStatus p1)? onFileLoading,
  }) async {
    final file = await fp.FilePicker.pickFile(
      dialogTitle: dialogTitle,
      initialDirectory: initialDirectory,
      type: type,
      allowedExtensions: allowedExtensions,
      onFileLoading: onFileLoading,
    );
    if (file == null) {
      return null;
    }
    return FilePickerResult([file]);
  }

  @override
  Future<FilePickerResult?> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    fp.FileType type = fp.FileType.any,
    List<String>? allowedExtensions,
    Function(fp.FilePickerStatus p1)? onFileLoading,
  }) async {
    final files = await fp.FilePicker.pickFiles(
      dialogTitle: dialogTitle,
      initialDirectory: initialDirectory,
      type: type,
      allowedExtensions: allowedExtensions,
      onFileLoading: onFileLoading,
    );
    if (files.isEmpty) {
      return null;
    }
    return FilePickerResult(files);
  }

  @override
  Future<String?> saveFile({
    required String fileName,
    required Uint8List bytes,
    String? mimeType,
    String? dialogTitle,
    String? initialDirectory,
  }) async {
    final uri = await fp.FilePicker.saveFile(
      fileName: fileName,
      bytes: bytes,
      mimeType: mimeType ?? 'application/octet-stream',
      dialogTitle: dialogTitle,
      initialDirectory: initialDirectory,
    );
    return uri?.toString();
  }
}

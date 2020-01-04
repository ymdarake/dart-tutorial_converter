import 'package:converter/src/converter.dart';
import 'package:prompter_ymdarake/prompter_ymdarake.dart';
import 'dart:io';
import 'package:convert/convert.dart';

void main() {
  final prompter = Prompter();
  final choice = prompter.askBinary('Are you here to convert an image?');
  if (!choice) {
    exit(0);
  }

  final format = prompter.askMultiple('Select format:', buildFormatOptions());
  final selectedFile =
      prompter.askMultiple('Select an image to convert:', buildFileOptions());

  final newPath = convertImage(selectedFile, format);

  final shoulOpen = prompter.askBinary('Open the image?');

  if (shoulOpen) {
    Process.run('open', [newPath]);
  }
}

List<Option> buildFormatOptions() {
  return [
    Option('Convert to jpeg', 'jpeg'),
    Option('Convert to png', 'png'),
  ];
}

List<Option> buildFileOptions() {
  return Directory.current.listSync().where((entity) {
    return FileSystemEntity.isFileSync(entity.path) &&
        entity.path.contains(RegExp(r'\.(png|jpg|jpeg)'));
  }).map((entity) {
    final filename = entity.path.split(Platform.pathSeparator).last;
    return Option(filename, entity);
  }).toList();
}

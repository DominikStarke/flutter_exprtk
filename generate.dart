import 'dart:io';

Future<void> main(List<String> args) async {
  if (args.length != 3 || args.length != 4) {
    print('Expecting 4 or 3 parameters! See README!');
    return;
  }
  String name = args[0];
  print('Plugin name: $name');
  String classCase = toClassCase(name);
  print('Class name; $classCase');
  String bundle = args[1];
  print('Bundle: $bundle');
  String version = args[2];
  print('Version: $version');
  String? repository;
  if (args.length == 4) {
    repository = args[3];
    print('Repository: $repository');
  } else {
    print('Repository: Not set!');
  }
  bool ios = false;
  bool android = false;
  bool web = false;
  bool windows = false;
  bool foundPlatformInterface = false;
  bool foundMain = false;
  bool foundLicense = false;
  bool foundReadme = false;
  bool foundChangelog = false;
  await for (FileSystemEntity entity in Directory.current.list()) {
    String name = entity.path.replaceAll('\\', '/');
    int index = name.lastIndexOf('/');
    if (index >= 0) {
      name = name.substring(index);
    }
    if (entity is Directory) {
      if (name == 'NAME_ios') {
        print('Targeting ios');
        ios = true;
      } else if (name == 'NAME_android') {
        print('Targeting android');
        android = true;
      } else if (name == 'NAME_web') {
        print('Targeting web');
        web = true;
      } else if (name == 'NAME_windows') {
        print('Targeting windows');
        windows = true;
      } else if (name == 'NAME_platform_interface') {
        foundPlatformInterface = true;
      } else if (name == 'NAME') {
        foundMain = true;
      }
    } else if (entity is File) {
      if (name == 'FEDERATED_CHANGELOG_TEMPLATE.md') {
        foundChangelog = true;
      } else if (name == 'FEDERATED_README_TEMPLATE.md') {
        foundReadme = true;
      } else if (name == 'FEDERATED_LICENSE_TEMPLATE') {
        foundLicense = true;
      }
    }
  }
  if (!foundMain) {
    print('NAME template foulder not fond!');
    return;
  }
  if (!foundPlatformInterface) {
    print('NAME_platform_interface foulder not found!');
    return;
  }
  if (!foundLicense) {
    print('FEDERATED_LICENSE_TEMPLATE not found!');
    return;
  }
  if (!foundReadme) {
    print('FEDERATED_README_TEMPLATE not found!');
    return;
  }
  if (!foundChangelog) {
    print('FEDERATED_CHANGELOG_TEMPLATE not found!');
    return;
  }
  if (!(ios || android || web || windows)) {
    print('No target!');
    return;
  }
}

String toClassCase(String name) {
  return name.split('_').map(capitalize).join();
}

String capitalize(String s) {
  if (s.length == 0) {
    return s;
  } else if (s.length == 1) {
    return s.toUpperCase();
  } else {
    return s.substring(0, 1).toUpperCase() + s.substring(1);
  }
}

Future<void> rewriteReadme(File readme, String platform, String version) async {
  String underscorePlatform = '_' + platform.toLowerCase();
  String content = await readme.readAsString();
  content = content
      .replaceAll('_PLATFORM', underscorePlatform)
      .replaceAll('PLATFORM', platform)
      .replaceAll('VERSION', version);
  await readme.writeAsString(content);
}

Future<void> rewriteChangelog(File changelog, String version) async {
  String content = await changelog.readAsString();
  content = content.replaceAll('VERSION', version);
  await changelog.writeAsString(content);
}

Future<void> rewriteDartFile(File file, String name, String className) async {
  String content = await file.readAsString();
  content = content.replaceAll('NAME', name).replaceAll('CLASS', className);
  await file.writeAsString(content);
}

Future<void> rewritePubspec(File file, String name, String className,
    String bundleIdentifier, String version, String? repository) async {
  String content = await file.readAsString();
  content = content
      .replaceAll('NAME', name)
      .replaceAll('CLASS', className)
      .replaceAll('BUNDLE', bundleIdentifier)
      .replaceAll('VERSION', version);
  if (repository != null) {
    content = content.replaceAll('GITHUB', repository);
  } else {
    List<String> lines = content.split('\n');
    lines.removeAt(2);
    content = lines.join('\n');
  }
  await file.writeAsString(content, flush: true);
}

Future<void> rewriteMainPubspec(File file, String name, String version,
    String? repository, bool ios, bool android, bool windows, bool web) async {
  await rewritePubspec(file, name, '', '', version, repository);
  String content = await file.readAsString();
  List<String> lines = [];
  Iterator<String> iterator = content.split('\n').iterator;
  bool inFlutterSection = false;
  while (iterator.moveNext()) {
    if (inFlutterSection) {
      String label = iterator.current.trimLeft();
      if (label == 'ios:' && !ios) {
        iterator.moveNext();
        continue;
      } else if (label == 'android:' && !android) {
        iterator.moveNext();
        continue;
      } else if (label == 'web:' && !web) {
        iterator.moveNext();
        continue;
      } else if (label == 'windows:' && !windows) {
        iterator.moveNext();
        continue;
      }
    } else if (iterator.current.trimRight() == 'flutter:') {
      inFlutterSection = true;
    } else {
      if (iterator.current.startsWith('  ' + name + '_ios') && !ios) {
        continue;
      } else if (iterator.current.startsWith('  ' + name + '_android') &&
          !android) {
        continue;
      } else if (iterator.current.startsWith('  ' + name + '_web') && !web) {
        continue;
      } else if (iterator.current.startsWith('  ' + name + '_windows') &&
          !windows) {
        continue;
      }
    }
    lines.add(iterator.current);
  }
  content = lines.join('\n');
  await file.writeAsString(content);
}

Future<void> cleanUp() async {
  await new File('README.md').delete();
  await new File('FEDERATED_CHANGELOG_TEMPLATE.md').delete();
  await new File('FEDERATED_README_TEMPLATE.md').delete();
  await new File('FEDERATED_LICENSE_TEMPLATE').delete();
  await new File('LICENSE').delete();
  await new File('generate.dart').delete();
}

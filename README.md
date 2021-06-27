#flutter_federated_plugin_template

A manually created template for federated flutter plugins.
You can use this template to create federated plugins until [`flutter create` is able to create plugins in federal structure](https://github.com/flutter/flutter/issues/43284).

## Get started
First, clone this repository, then do the following:
1. Delete all folders belonging to platforms you don't want to support
2. Create a file named `FEDERATED_LICENSE_TEMPLATE` in this folder, which will automatically be copied to all subfolders
3. Edit `FEDERATED_README_TEMPLATE.md` and `FEDERATED_CHANGELOG_TEMPLATE.md` to fit your needs
4. Run `dart generate.dart plugin_name bundle_identifier version repo_base` with your `plugin_name`, `bundle_identifier` (e.g. `eu.epnw`) and `version` (e.g. `1.0.0`) in this folder to create the template structure.
  If you plan to publish your package on github you can set `repo_base` so the `repository` fields in all `pubspec.yaml` are set up correctly. If you omit it, no `repository` field is set.
5. Manually check the `NAME/lib/src/workarounds` folder and remove code form there that you don't need.
6. Implement your plugin (and don't forget to implement `NAME_paltform_interface/lib/src/NAME_platform_unsupported.dart` as well)
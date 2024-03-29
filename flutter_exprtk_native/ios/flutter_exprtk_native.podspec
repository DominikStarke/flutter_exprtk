#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_exprtk_native.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_exprtk_native'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/flutter_exprtk.cpp'
  s.compiler_flags = '-x objective-c++'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # s.subspec 'flutter_exprtk' do |sp|
  #   sp.source_files = 'Classes/flutter_exprtk.cpp'
  #   sp.compiler_flags = '-x objective-c++'
  # end
end

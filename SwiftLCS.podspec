Pod::Spec.new do |spec|
  spec.name             = 'SwiftLCS'
  spec.version          = '1.3.4'
  spec.summary          = 'SwiftLCS is a Swift implementation of longest common subsequence (LCS) algorithm.'
  spec.homepage         = 'https://github.com/Frugghi/SwiftLCS'
  spec.license          = 'MIT'
  spec.authors          = { 'Tommaso Madonia' => 'tommaso@madonia.me' }
  spec.social_media_url = 'https://twitter.com/Frugghi'
  spec.source           = { :git => 'https://github.com/Frugghi/SwiftLCS.git', :tag => spec.version.to_s }

  spec.requires_arc     = true
  spec.swift_versions   = ['4.2', '5.0']
  spec.default_subspec  = 'Core'

  spec.ios.deployment_target = '8.0'
  spec.osx.deployment_target = '10.10'
  spec.tvos.deployment_target = '9.0'
  spec.watchos.deployment_target = '2.0'

  spec.subspec 'Core' do |core|
      core.source_files = 'Source/SwiftLCS/SwiftLCS.swift'
  end

  #spec.test_spec do |test_spec|
  #  test_spec.source_files = 'SwiftLCS Tests/*.swift'
  #end

end

Pod::Spec.new do |spec|
  spec.name             = "SwiftLCS"
  spec.version          = "1.0"
  spec.summary          = "SwiftLCS is a Swift implementation of longest common subsequence (LCS) algorithm."
  spec.homepage         = "https://github.com/Frugghi/SwiftLCS"
  spec.license          = "MIT"
  spec.authors          = { "Tommaso Madonia" => "tommaso@madonia.me" }
  spec.social_media_url = "https://twitter.com/Frugghi"
  spec.source           = { :git => "https://github.com/Frugghi/SwiftLCS.git", :tag => spec.version.to_s }

  spec.requires_arc    = true
  spec.default_subspec = "Foundation"

  spec.ios.deployment_target = "8.0"
  spec.osx.deployment_target = "10.9"
  spec.watchos.deployment_target = "2.0"
  spec.tvos.deployment_target = "9.0"

  spec.subspec 'Core' do |core|
      core.source_files = 'SwiftLCS/SwiftLCS.swift'
  end

  spec.subspec 'Foundation' do |foundation|
      foundation.source_files = 'SwiftLCS/SwiftLCS+Foundation.swift'
      foundation.dependency	    'SwiftLCS/Core'
  end

end

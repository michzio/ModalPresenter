Pod::Spec.new do |s|

  s.name = "ModalPresenter"
  s.version = "0.1.0"
  s.summary = "SwiftUI modal presentation missing view modifier."

  s.swift_version = '5.6'
  s.platform = :ios
  s.ios.deployment_target = '13.0'

  s.description = <<-DESC
  SwiftUI modal presentation missing view modifier. That enables similar to .sheet() or .fullScreenCover()
  presnt views modally over full screen using different presentation contexts, styles and transitions. 
  It uses UIKit modal presentation tools underneath. You can just add presentModal(isPresented: ...) or presentModal(item: ...) 
  to use it in your app
  DESC

  s.homepage = "https://github.com/michzio/ModalPresenter"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "Michał Ziobro" => "swiftui.developer@gmail.com" }

  s.source = { :git => "https://github.com/michzio/ModalPresenter.git", :tag => "#{s.version}" }

  s.source_files = "Sources/**/*.swift"
  s.exclude_files = [
    "Example/**/*.swift", 
    "Tests/**/*.swift"
  ]

  s.framework = "UIKit"

  s.dependency 'Introspect', '~> 0.1'
  
end

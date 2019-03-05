Pod::Spec.new do |s|
  s.name            = "Dertisch"
  s.version         = "0.6.1"
  s.summary         = "A lightweight framework for Swift apps."
  s.description     = <<-DESC
  Dertisch is a swifty MVP framework for Swift apps built around dependency injection
  DESC
  s.homepage        = "https://github.com/josephbeuysmum/Dertisch"
  s.license         = "MIT"
  s.author          = {"Richard Willis" => "richard@josephbeuysmum.co.uk"}
  s.platform        = :ios, "10.0"
  s.source          = {:git => "https://github.com/josephbeuysmum/Dertisch.git", :tag => "#{s.version}"}
  s.source_files    = "Dertisch/**/*.{h,m,swift}"
  s.swift_version   = "4.2"
end

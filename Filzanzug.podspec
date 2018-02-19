Pod::Spec.new do |s|
  s.name            = "Filzanzug"
  s.version         = "0.0.7"
  s.summary         = "A lightweight VIPER framework for Swift apps."
  s.description     = <<-DESC
  Filzanzug is lightweight VIPER framework for Swift built using a 'write once, read never' ('WORN') dependency injection system,
  meaning properties are injected once and not publicly accessible thereafter.
  DESC
  s.homepage        = "http://josephbeuysmum.co.uk"
  s.license         = "MIT"
  s.author          = { "Richard Willis" => "richard@josephbeuysmum.co.uk" }
  s.platform        = :ios, "10.0"
  s.source          = { :git => "https://github.com/josephbeuysmum/Filzanzug.git", :tag => "0.0.7"  }
  s.source_files    = "Filzanzug/**/*.{h,m,swift}"
  s.swift_version   = "4"
  s.dependency "Swinject"
  s.dependency "SwinjectStoryboard"
end

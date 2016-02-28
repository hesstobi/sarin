# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sarin/version'

Gem::Specification.new do |spec|
  spec.name          = "sarin"
  spec.version       = Sarin::VERSION
  spec.authors       = ["Tobias Hess"]
  spec.email         = ["me@tobiashess.de"]

  spec.summary       = %q{SARIN: Sigma ROX Indoor Cycling Converter}
  spec.description   = %q{Redefine the GPS-Position in your Sigma Log File (SLF) with a synthetic circle arownd the mean postion. This is usfull if want to share your indoor training. }
  spec.homepage      = "https://github.com/hesstobi/sarin.git"
  spec.license       = "MIT"


  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = ["sarin"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.add_runtime_dependency 'clamp', '~> 1.0'
  spec.add_runtime_dependency 'nokogiri', '~> 1.6'
end

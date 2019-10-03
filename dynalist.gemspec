lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dynalist/version"

Gem::Specification.new do |spec|
  spec.name          = "dynalist"
  spec.version       = Dynalist::VERSION
  spec.authors       = ["4geru"]
  spec.email         = ["westhouse51@gmail.com"]

  spec.summary       = "this is dynalist api client gem"
  spec.description   = "this is dynalist api client gem"
  spec.homepage      = "https://github.com/4geru/dynalist"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/4geru/dynalist"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "pry-byebug"
  spec.add_dependency "faraday"
end

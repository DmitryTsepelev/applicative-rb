require_relative "lib/applicative/version"

Gem::Specification.new do |spec|
  spec.name = "applicative"
  spec.version = Applicative::VERSION
  spec.authors = ["DmitryTsepelev"]
  spec.email = ["dmitry.a.tsepelev@gmail.com"]
  spec.homepage = "https://github.com/DmitryTsepelev/applicative-rb"
  spec.summary = "An experimental set of primitives to write Ruby in the applicative style"

  spec.license = "MIT"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/DmitryTsepelev/applicative-rb/issues",
    "changelog_uri" => "https://github.com/DmitryTsepelev/applicative-rb/blob/master/CHANGELOG.md",
    "documentation_uri" => "https://github.com/DmitryTsepelev/applicative-rb/blob/master/README.md",
    "homepage_uri" => "https://github.com/DmitryTsepelev/applicative-rb",
    "source_code_uri" => "https://github.com/DmitryTsepelev/applicative-rb"
  }

  spec.files = [
    Dir.glob("lib/**/*"),
    "README.md",
    "CHANGELOG.md",
    "LICENSE.txt"
  ].flatten

  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 3.1.0"
end

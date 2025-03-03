# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "blogify/version"

Gem::Specification.new do |spec|
  spec.name          = "blogify"
  spec.version       = Blogify::VERSION
  spec.authors       = ["David Paluy"]
  spec.summary       = "Rails engine for adding blog functionality"
  spec.homepage      = "http://github.com/dpaluy/blogify"
  spec.licenses      = ["MIT"]
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 3.0.0"
  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.metadata = {
    "homepage_uri" => spec.homepage,
    "source_code_uri" => "https://github.com/dpaluy/blogify",
    "changelog_uri" => "https://github.com/dpaluy/blogify/blob/main/CHANGELOG.md",
    "rubygems_mfa_required" => "true"
  }

  spec.add_dependency "rails", ">= 8.0.0"
end
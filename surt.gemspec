# frozen_string_literal: true

require_relative "lib/surt/version"

Gem::Specification.new do |s|
  s.name        = "surt"
  s.version     = Surt::VERSION
  s.summary     = "Generate SURT URIs"
  s.description = "Generate SURT (Sort-friendly URI Reordering Transform) keys from URLs, as used in web archiving."
  s.authors     = ["Mark Johnson"]
  s.email       = "mijho@hey.com"
  s.homepage    = "https://github.com/mijho/ruby-surt"
  s.license     = "MIT"

  s.required_ruby_version = ">= 3.0"

  s.metadata = {
    "homepage_uri"    => s.homepage,
    "source_code_uri" => s.homepage,
    "bug_tracker_uri" => "#{s.homepage}/issues"
  }

  s.files       = Dir["lib/**/*.rb"] + ["bin/surt", "README.md", "LICENSE"]
  s.bindir      = "bin"
  s.executables = ["surt"]
  s.require_paths = ["lib"]
end

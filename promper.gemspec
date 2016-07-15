# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'promper/version'
require 'promper/gab_tree'

Gem::Specification.new do |spec|
  spec.name          = "promper"
  spec.version       = Promper::VERSION
  spec.authors       = ["prettycities"]
  spec.email         = ["david@davidcyze.com"]

  spec.summary       = %q{Extract similar sounding phoneme constructions from English word(s).}
  spec.description   = %q{This gem takes English words, converts them to their IPA equivalent, and then uses a tree data structure to query a database and identify other English words that have a similar phonetic makeup. It uses RubyTree and StringToIpa.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = (`git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) } << [
    'lib/promper/gab_tree.rb', 'lib/promper/db.rb', 'lib/promper/gab_tree_processor.rb', 'lib/promper/master.yml', 'lib/promper/matching.rb',
    'lib/promper/refiners/dict_refine.rb']).flatten
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency "rubytree"
  spec.add_runtime_dependency "string_to_ipa"
end

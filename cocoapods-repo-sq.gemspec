# coding: utf-8

# This source file is part of the cocoapods-repo-sq plugin under the Apache 2.0
# license:
#
#    Copyright 2018 Square Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#
# =============================================================================

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cocoapods_repo_sq'

Gem::Specification.new do |spec|
  spec.name          = 'cocoapods-repo-sq'
  spec.version       = CocoapodsRepoSq::VERSION
  spec.version       = "#{spec.version}.#{ENV['TRAVIS_BUILD_NUMBER']}" if ENV['TRAVIS']
  spec.authors       = ['Square, Inc.']
  spec.email         = ['developers@squareup.com']
  spec.description   = 'Support for Square SDK Repositories on Cocoapods'
  spec.summary       = 'Support for Square SDK Repositories on Cocoapods. For more information see https://docs.connect.squareup.com'
  spec.homepage      = 'https://github.com/square/cocoapods-repo-sq'
  spec.license       = 'Apache-2.0'

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'cocoapods', '~> 1', '>= 1.4.0'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'yard', '~> 0.9'
end

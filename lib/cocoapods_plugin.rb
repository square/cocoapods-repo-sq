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

# plugin main source files
require 'cocoapods_repo_sq/repository_store'
require 'cocoapods_repo_sq/repository'
require 'cocoapods_repo_sq/source'
require 'cocoapods_repo_sq/downloader'

# plugin repo-sq command line support
require 'pod/command/repo_sq'

Pod::HooksManager.register('cocoapods-repo-sq', :source_provider) do |context, options|
  name = options.fetch('repository', nil)
  raise Pod::Informative, "repository is needed for `cocoapods-repo-sq``" unless name

  repository_store = CocoapodsRepoSq::RepositoryStore.default
  unless repository_store.exists?(name)
    raise Pod::Informative, "Square SDK repository `#{name}` does not exist"
  end

  repository = repository_store.get(name)
  CocoapodsRepoSq::Repository.current = repository

  # update specs when `pod update` is being ran
  if ARGV.include?('--repo-update') ||
     (ARGV.include?('update') && !ARGV.include?('--no-repo-update'))
    repository.update_specs
  end
  context.add_source(CocoapodsRepoSq::Source.new(repository))
end

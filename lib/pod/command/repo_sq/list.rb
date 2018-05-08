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

module Pod
  class Command
    class RepoSq < Command
      # Subclass of {RepoSq}
      # Provides support for the `pod repo-sq list` command, which lists the
      # Square SDK repositories currently registered on the user's cocoapods
      # local repositories store.
      class List < RepoSq
        self.summary = 'List configured Square SDK repositories'

        self.description = <<-DESC
          List all Square SDK repositories added to your local Cocoapod's sources registry.
        DESC

        # Lists all Square SDK repositories registered on the current user
        # {CocoapodsRepoSq::RepositoryStore}.
        def run
          repositories = repository_store.list

          repositories.each do |repository|
            UI.title "Square SDK repository: #{repository.name}" do
              UI.puts " - URL:  #{repository.url}"
              UI.puts " - Path: #{repository.path}"
            end
          end
          UI.puts "\n"

          n = repositories.length
          UI.puts "#{n} #{n != 1 ? 'repositories' : 'repository'}".green
        end
      end
    end
  end
end

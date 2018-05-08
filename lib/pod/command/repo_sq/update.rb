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
      # Provides support for the `pod repo-sq remove` command, which updates
      # the targeted Square SDK repository on the user's cocoapods local
      # repositories store.
      class Update < RepoSq
        self.summary = 'Update Square SDK repository specs'

        self.description = <<-DESC
          Updates Square SDK repository for your application `NAME`.
        DESC

        self.arguments = [
          CLAide::Argument.new('NAME', true),
        ]

        def initialize(argv)
          @name = argv.shift_argument
          super
        end

        # Validates that the required argument `NAME` is present.
        def validate!
          super
          help! '`NAME` is required.' unless @name
        end

        # Updates the podspecs of Square SDK repository on the current user
        # {CocoapodsRepoSq::RepositoryStore}.
        def run
          UI.section("Updating Square SDK repository `#{@name}`") do
            repository = repository_store.get(@name)
            repository.update_specs
          end
        end
      end
    end
  end
end

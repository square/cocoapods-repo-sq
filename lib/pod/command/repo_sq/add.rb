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
      # Provides support for the `pod repo-sq add` which adds a Square SDK
      # repository to the user's cocoapods local repositories store.
      class Add < RepoSq
        # Default Square SDK repositories server URL.
        # This URL can be customized by providing a fourth undocumented
        # parameter to this command but not intended for public use.
        #
        # @return [String]
        #   default Square SDK repositories server URL.
        DEFAULT_URL = 'https://sdk.squareup.com/ios'

        self.summary = 'Add a Square SDK repository'

        self.description = <<-DESC
          Add a Square SDK repository for your application to your local Cocoapod's
          sources registry. The remote can later be referred to by `NAME`.
        DESC

        self.arguments = [
          CLAide::Argument.new('NAME', true),
          CLAide::Argument.new('USERNAME', true),
          CLAide::Argument.new('PASSWORD', true),
        ]

        def initialize(argv)
          @name = argv.shift_argument
          @username = argv.shift_argument
          @password = argv.shift_argument
          @url = argv.shift_argument || DEFAULT_URL
          super
        end

        # Validates that all required arguments are present: `NAME`, `USERNAME`
        # and `PASSWORD`
        def validate!
          super
          unless @name && @username && @password
            help! 'Adding a Square SDK repository needs a `NAME`, `USERNAME` and a `PASSWORD`.'
          end
        end

        # Registers a Square SDK repository on the current user
        # {CocoapodsRepoSq::RepositoryStore}.
        # It checks that the user name and password are valid and that the
        # repository exists on the Square server.
        def run
          section = "Adding Square SDK repository `#{@name}`"
          UI.section(section) do
            repository = repository_store.register(@name, @username, @password, @url)
            begin
              repository.update_specs
            rescue => e
              repository_store.remove(@name)
              raise Informative, "Could not add `#{@name}`.\n" \
                                 "#{e.class.name}: #{e.message}"
            end
          end
        end
      end
    end
  end
end

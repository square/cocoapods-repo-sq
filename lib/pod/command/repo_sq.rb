# coding: utf-8
#
# Copyright 2018 Square Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require 'pod/command/repo_sq/add'
require 'pod/command/repo_sq/list'
require 'pod/command/repo_sq/remove'
require 'pod/command/repo_sq/update'

module Pod
  class Command
    # Subclass of Pod::Command to provide `pod repo-sq` command to manage Square SDK repositories
    #
    class RepoSq < Command
      self.abstract_command = true

      self.summary = 'Manage Square SDK repositories'
      self.default_subcommand = 'list'

      private
      def repository_store
        @repository_store ||= CocoapodsRepoSq::RepositoryStore.default
      end
    end
  end
end

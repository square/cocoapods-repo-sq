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
require 'simplecov'
SimpleCov.start

require 'pathname'
ROOT = Pathname.new(File.expand_path('../../', __FILE__))
$:.unshift((ROOT + 'lib').to_s)
$:.unshift((ROOT + 'spec').to_s)

require 'bundler/setup'
require 'bacon'
require 'mocha-on-bacon'
require 'pretty_bacon'
require 'cocoapods'

Mocha::Configuration.prevent(:stubbing_non_existent_method)

require 'cocoapods_plugin'

TEST_REPOS_PATH = File.expand_path(File.join(File.dirname(__FILE__), 'test-repos'))
CocoapodsRepoSq::RepositoryStore.class_eval do
  @default = new(TEST_REPOS_PATH)
end

#-----------------------------------------------------------------------------#

module Pod

  # Disable the wrapping so the output is deterministic in the tests.
  #
  UI.disable_wrap = true

  # Redirects the messages to an internal store.
  #
  module UI
    @output = []
    @warnings = []

    class << self
      attr_accessor :output
      attr_accessor :warnings

      def puts(message = '')
        @output << "#{message}\n"
      end

      def warn(message = '', actions = [])
        @warnings << "#{message}\n"
      end

      def print(message)
        @output << message
      end

      def reset
        self.title_level = 0
        self.output.clear
        self.warnings.clear
      end
    end
  end
end

#-----------------------------------------------------------------------------#


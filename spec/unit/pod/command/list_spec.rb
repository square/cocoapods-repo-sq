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
  describe Command::RepoSq::List do
    before { UI.reset }

    it 'it is returned by running `pod repo-sq`' do
      Command.parse(%w(repo-sq)).should.be.instance_of Command::RepoSq::List
    end

    it 'it is returned by running `pod repo-sq list`' do
      Command.parse(%w(repo-sq list)).should.be.instance_of Command::RepoSq::List
    end

    it 'lists one repository when one present' do
      argv = CLAide::ARGV.new([])
      command = Command::RepoSq::List.new(argv)
      repository = CocoapodsRepoSq::Repository.new('repo-4', 'app-4', 'pass-4', 'http://app4.com', '/path/to/repo4')
      CocoapodsRepoSq::RepositoryStore.default.expects(:list).returns([repository])
      command.run
      UI.output.should.equal [
        "\e[33m\nSquare SDK repository: repo-4\e[0m\n",
        " - URL:  http://app4.com\n",
        " - Path: /path/to/repo4\n",
        "\n\n",
        "\e[32m1 repository\e[0m\n"
      ]
      UI.warnings.should.equal []
    end

    it 'lists multiple repositories when present' do
      argv = CLAide::ARGV.new([])
      command = Command::RepoSq::List.new(argv)
      repository_1 = CocoapodsRepoSq::Repository.new('repo-4', 'app-4', 'pass-4', 'http://app4.com', '/path/to/repo4')
      repository_2 = CocoapodsRepoSq::Repository.new('repo-5', 'app-5', 'pass-5', 'http://app5.com', '/path/to/repo5')
      CocoapodsRepoSq::RepositoryStore.default.expects(:list).returns([repository_1, repository_2])
      command.run
      UI.output.should.equal [
        "\e[33m\nSquare SDK repository: repo-4\e[0m\n",
        " - URL:  http://app4.com\n",
        " - Path: /path/to/repo4\n",
        "\e[33m\nSquare SDK repository: repo-5\e[0m\n",
        " - URL:  http://app5.com\n",
        " - Path: /path/to/repo5\n",
        "\n\n",
        "\e[32m2 repositories\e[0m\n"
      ]
      UI.warnings.should.equal []
    end
  end
end

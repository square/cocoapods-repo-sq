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
  describe Command::RepoSq::Add do
    before { UI.reset }

    it 'it is returned by running `pod repo-sq add ...`' do
      Command.parse(%w(repo-sq add)).should.be.instance_of Command::RepoSq::Add
    end

    it 'it shows an error message when there are missing arguments' do
      argv = CLAide::ARGV.new(%w(repo-1 app-4))
      command = Command::RepoSq::Add.new(argv)
      lambda{ command.validate! }.
        should.raise(CLAide::Help).
        message.should.match /Adding a Square SDK repository needs a `NAME`, `USERNAME` and a `PASSWORD`./
    end

    it 'invokes CocoapodsRepoSq::RepositoryStore.add with default URL' do
      repository = mock('repo')
      repository.expects(:update_specs)
      argv = CLAide::ARGV.new(%w(repo-1 app-4 pass-4))
      command = Command::RepoSq::Add.new(argv)
      CocoapodsRepoSq::RepositoryStore.default.expects(:register).with('repo-1', 'app-4', 'pass-4', Command::RepoSq::Add::DEFAULT_URL).returns(repository)
      command.run
      UI.output.should.equal ["Adding Square SDK repository `repo-1`\n"]
      UI.warnings.should.equal []
    end

    it 'invokes CocoapodsRepoSq::RepositoryStore.add with custom URL when present' do
      repository = mock('repo')
      repository.expects(:update_specs)
      argv = CLAide::ARGV.new(%w(repo-1 app-4 pass-4 custom-url))
      command = Command::RepoSq::Add.new(argv)
      CocoapodsRepoSq::RepositoryStore.default.expects(:register).with('repo-1', 'app-4', 'pass-4', 'custom-url').returns(repository)
      command.run
      UI.output.should.equal ["Adding Square SDK repository `repo-1`\n"]
      UI.warnings.should.equal []
    end

    it 'cleans repository path if it fails to download specs' do
      error = StandardError.new('error')
      repository = mock('repo')
      repository.expects(:update_specs).raises(error)
      argv = CLAide::ARGV.new(%w(fail-1 app-4 pass-4))
      command = Command::RepoSq::Add.new(argv)
      CocoapodsRepoSq::RepositoryStore.default.expects(:register).with('fail-1', 'app-4', 'pass-4', Command::RepoSq::Add::DEFAULT_URL).returns(repository)
      lambda{ command.run }.
        should.raise(Informative)
      UI.output.should.equal ["Adding Square SDK repository `fail-1`\n"]
      UI.warnings.should.equal []
    end
  end
end

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
  describe Command::RepoSq::Remove do
    before { UI.reset }

    it 'it is returned by running `pod repo-sq remove ...`' do
      Command.parse(%w(repo-sq remove)).should.be.instance_of Command::RepoSq::Remove
    end

    it 'it shows an error message when there are missing arguments' do
      argv = CLAide::ARGV.new([])
      command = Command::RepoSq::Remove.new(argv)
      lambda{ command.validate! }.
        should.raise(CLAide::Help).
        message.should.match /`NAME` is required./
    end

    it 'removes repository from the store' do
      argv = CLAide::ARGV.new(%w(repo-4))
      command = Command::RepoSq::Remove.new(argv)
      CocoapodsRepoSq::RepositoryStore.default.expects(:remove).with('repo-4')
      command.run
      UI.output.should.equal ["Removing Square SDK repository `repo-4`\n"]
      UI.warnings.should.equal []
    end
  end
end

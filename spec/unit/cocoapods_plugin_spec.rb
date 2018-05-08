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

describe 'Plugin Hook' do
  before do
    CocoapodsRepoSq::Repository.current = nil
  end

  describe 'registration' do
    it 'should register plugin as a :source_provider' do
      Pod::HooksManager.registrations.should.include(:source_provider)
      Pod::HooksManager.registrations[:source_provider][0].plugin_name.should.equal('cocoapods-repo-sq')
    end
  end

  describe 'installation' do
    before { @block = Pod::HooksManager.registrations[:source_provider][0].block }

    it 'should fail when `repository` is not provided' do
      lambda { @block.call(nil, {}) }.
        should.raise(Pod::Informative).
        message.should.match /repository is needed for `cocoapods-repo-sq`/
    end

    it 'should fail when a repository does not exist for `repository`' do
      lambda { @block.call(nil, { 'repository' => 'non-existant' }) }.
        should.raise(Pod::Informative).
        message.should.match /Square SDK repository `non-existant` does not exist/
    end

    it 'should set the current repository and configure a CocoapodsRepoSq::Source' do
      context = mock('context')
      context.expects(:add_source)

      CocoapodsRepoSq::Repository.current.should.be.nil?
      @block.call(context, { 'repository' => 'repo-1' })
      CocoapodsRepoSq::Repository.current.should.not.be.nil?
    end

    it 'should update repository specs when running `pod update`' do
      repository_name = 'repo-1'
      repository = mock('repository')
      repository.expects(:update_specs)
      repository.expects(:path).returns('/path')
      store = CocoapodsRepoSq::RepositoryStore.default
      store.expects(:exists?).with(repository_name).returns(true)
      store.expects(:get).with(repository_name).returns(repository)
      context = mock('context')
      context.expects(:add_source)
      ARGV = ['update']

      CocoapodsRepoSq::Repository.current.should.be.nil?
      @block.call(context, { 'repository' => repository_name })
      CocoapodsRepoSq::Repository.current.should.not.be.nil?
    end

    it 'should update repository specs when running `pod install --repo-update`' do
      repository_name = 'repo-1'
      repository = mock('repository')
      repository.expects(:update_specs)
      repository.expects(:path).returns('/path')
      store = CocoapodsRepoSq::RepositoryStore.default
      store.expects(:exists?).with(repository_name).returns(true)
      store.expects(:get).with(repository_name).returns(repository)
      context = mock('context')
      context.expects(:add_source)
      ARGV = ['install', '--repo-update']

      CocoapodsRepoSq::Repository.current.should.be.nil?
      @block.call(context, { 'repository' => repository_name })
      CocoapodsRepoSq::Repository.current.should.not.be.nil?
    end

    it 'should not update repository specs when running `pod update --no-repo-update`' do
      repository_name = 'repo-1'
      repository = mock('repository')
      repository.expects(:path).returns('/path')
      store = CocoapodsRepoSq::RepositoryStore.default
      store.expects(:exists?).with(repository_name).returns(true)
      store.expects(:get).with(repository_name).returns(repository)
      context = mock('context')
      context.expects(:add_source)
      ARGV = ['--no-repo-update', '--verbose', 'update']

      CocoapodsRepoSq::Repository.current.should.be.nil?
      @block.call(context, { 'repository' => repository_name })
      CocoapodsRepoSq::Repository.current.should.not.be.nil?
    end
  end
end

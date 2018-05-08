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

module CocoapodsRepoSq
  describe RepositoryStore do
    describe 'initialize' do
      it 'should use Cocoapods home directory when nothing is passed' do
        expected_path = File.join(Pod::Config.instance.home_dir, 'repo-sq')
        store = RepositoryStore.new

        store.instance_eval('@path').should.equal expected_path
        Dir.exists?(expected_path).should.be.true?
      end

      it 'should allow customizing the base repository path' do
        expected_path = File.join(File.dirname(__FILE__), 'repo-sq')
        store = RepositoryStore.new(expected_path)

        store.instance_eval('@path').should.equal expected_path
        Dir.exists?(expected_path).should.be.true?
      end
    end

    describe 'instance methods' do
      before do
        @store = CocoapodsRepoSq::RepositoryStore.default
        @base_path = @store.instance_eval('@path')
      end

      describe 'exists?' do
        it 'checks for the existence of the settings file' do
          name = 'repo-1'
          File.expects(:exists?).with(File.join(@base_path, name, '.settings.yml')).returns(true)
          @store.exists?(name).should.be.true?
        end
      end

      describe 'list' do
        it 'lists all existing repositories' do
          repositories = @store.list
          repositories.count.should.equal 2
          repositories.each{ |r| r.should.be.instance_of Repository }
          repositories.map(&:name).sort.should.equal ['repo-1', 'repo-2']
        end
      end

      describe 'get' do
        it 'returns nil when repository does not exist' do
          repository = @store.get('repo-3')
          repository.should.be.nil?
        end

        it 'returns a valid repository object when repository exists' do
          repository = @store.get('repo-1')
          repository.should.be.instance_of Repository
          repository.name.should.equal 'repo-1'
          repository.username.should.equal 'app-1'
          repository.password.should.equal 'pass-1'
          repository.url.should.equal 'http://app-1.com/'
        end
      end

      describe 'register' do
        it 'raises an exception when the repository already exists' do
          lambda{ @store.register('repo-1', 'app-1', 'pass-1', 'url-1') }.
            should.raise(Pod::Informative).
            message.should.match /Square SDK repository `repo-1` is already configured/
        end

        it 'cleans repository path if it fails to register' do
          error = StandardError.new('error')
          @store.expects(:store_settings!).raises(error)
          @store.expects(:remove).with('repo-4')

          lambda{ @store.register('repo-4', 'app-4', 'pass-4', 'url-4') }.
            should.raise(StandardError)
        end

        it 'creates settings file and returns repository when successfully adding it' do
          repository = @store.register('repo-4', 'app-4', 'pass-4', 'url-4')
          repository.name.should.equal 'repo-4'
          repository.username.should.equal 'app-4'
          repository.password.should.equal 'pass-4'
          repository.url.should.equal 'url-4'
          File.exists?(File.join(@base_path, 'repo-4', '.settings.yml')).should.be.true?
          @store.remove('repo-4').should.be.true?
        end
      end

      describe 'remove' do
        it 'returns false when no repository is removed' do
          @store.remove('repo-7').should.be.false?
          Dir.exists?(File.join(@base_path, 'repo-3')).should.be.false?
        end

        it 'creates settings file and returns repository when successfully adding it' do
          @store.register('repo-4', 'app-4', 'pass-4', 'url-4')
          File.exists?(File.join(@base_path, 'repo-4', '.settings.yml')).should.be.true?

          @store.remove('repo-4').should.be.true?
          Dir.exists?(File.join(@base_path, 'repo-4')).should.be.false?
        end
      end
    end
  end
end

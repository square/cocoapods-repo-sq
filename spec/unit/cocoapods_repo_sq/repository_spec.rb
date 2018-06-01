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
  describe Repository do
    before do
      @name = 'repo-1'
      @username = 'app-1'
      @password = 'pass-1'
      @url = 'http://app-1.com'
      @path = '/path/to/repo'
      @repository = Repository.new(@name, @username, @password, @url, @path)
    end

    it 'should initialize the repository with provided settings' do
      @repository.name.should.equal(@name)
      @repository.username.should.equal(@username)
      @repository.password.should.equal(@password)
      @repository.url.should.equal(@url)
      @repository.path.should.equal(@path)
    end

    it 'should download specifications when calling update_specs' do
      downloader = mock('downloader')
      downloader.expects(:download)

      new_specs_path = File.join(@path, 'Specs.new')
      specs_path = File.join(@path, 'Specs')
      CocoapodsRepoSq::Downloader.expects(:new).with(new_specs_path, "specs.zip", :repository => @repository).returns(downloader)

      Dir.expects(:exists?).with(new_specs_path).returns(true)
      FileUtils.expects(:rm_rf).with(new_specs_path)

      new_specs_file = File.join(new_specs_path, "file.zip")
      File.expects(:exists?).with(new_specs_file).returns(true)
      FileUtils.expects(:rm).with(new_specs_file)

      Dir.expects(:exists?).with(specs_path).returns(true)
      FileUtils.expects(:rm_rf).with(specs_path)

      FileUtils.expects(:mv).with(new_specs_path, specs_path)

      @repository.update_specs
    end
  end
end

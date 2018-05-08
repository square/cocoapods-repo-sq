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
  describe Downloader do
    before do
      store = RepositoryStore.default
      @repository = store.get('repo-1')
      Repository.current = store.get('repo-2')
    end

    it 'registers Square in the list of downloaders' do
      Pod::Downloader.downloader_class_by_key.should.include :square
      Pod::Downloader.downloader_class_by_key[:square].should.equal Downloader
    end

    it 'should download a file from the provided repository' do
      dest_path = File.join(File.dirname(__FILE__))
      downloader = Downloader.new(dest_path, "specs-resource.zip", :repository => @repository)

      output_file = Pathname(File.join(dest_path, 'file.zip'))
      downloader.expects(:curl!).with('-u', "app-1:pass-1", '-f', '-L', '-o', output_file, 'http://app-1.com/specs-resource.zip', '--create-dirs', '--netrc-optional')
      downloader.expects(:unzip!).with(output_file, '-d', Pathname(dest_path))

      downloader.download
    end

    it 'should download a file from the current repository when none if provided' do
      dest_path = File.join(File.dirname(__FILE__))
      downloader = Downloader.new(dest_path, "specs-resource.zip", {})

      output_file = Pathname(File.join(dest_path, 'file.zip'))
      downloader.expects(:curl!).with('-u', "app-2:pass-2", '-f', '-L', '-o', output_file, 'http://app-2.com/specs-resource.zip', '--create-dirs', '--netrc-optional')
      downloader.expects(:unzip!).with(output_file, '-d', Pathname(dest_path))

      downloader.download
    end
  end
end

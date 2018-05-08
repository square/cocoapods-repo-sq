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

# Main namespace for cocoapods-repo-sq plugin
module CocoapodsRepoSq
  # Class that represents the credentials needed to access a Square SDK
  # repository of {https://guides.cocoapods.org/syntax/podspec.html podspecs}
  # for a given Square Application. Responsible for downloading a copy of the
  # repository from Square servers and cache it on the local filesystem.
  class Repository
    class << self
      # Square SDK repository set by the plugin initialization on the
      # {https://guides.cocoapods.org/syntax/podfile.html#plugin Podfile}.
      # This setting is used by the {Downloader} class to know which repository
      # to download files from in the context of a `pod install` or `pod update`
      # command call. When a podspec indicates a Square source it does not have
      # a Square SDK repository reference to provide to the Downloader class so
      # this global setting is used instead.
      #
      # @return [CocoapodsRepoSq::Repository]
      #   current Square SDK repository
      attr_accessor :current
    end

    # @return [String]
    #   nickname under which a Square SDK repository was registered on the
    #   {RepositoryStore}.
    attr_reader :name

    # @return [String]
    #   server user name used to access a specific Square SDK repository.
    attr_reader :username

    # @return [String]
    #   server password used to access a specific Square SDK repository.
    attr_reader :password

    # @return [String]
    #   Square SDK repositories server url.
    attr_reader :url

    # @return [String]
    #   local filesystem path where this repository cache of podspecs is stored.
    attr_reader :path

    # @param name [String]
    #   nickname under which a Square SDK repository was registered on the
    #   {RepositoryStore}.
    #
    # @param username [String]
    #   server user name used to access a specific Square SDK repository.
    #
    # @param password [String]
    #   server password used to access a specific Square SDK repository.
    #
    # @param url [String]
    #   Square SDK repositories server url.
    #
    # @param path [String]
    #   local filesystem path where this repository cache of podspecs is stored.
    def initialize(name, username, password, url, path)
      @name = name
      @username = username
      @url = url
      @password = password
      @path = path
    end

    # Updates the local copy of the podspecs from the Square SDK repository
    def update_specs
      # download new specs to a temp directory
      new_specs_path = get_temporary_path
      downloader = Downloader.new(new_specs_path, "specs.zip", :repository => self)
      downloader.download

      # perform cleanup
      specs_path = File.join(@path, 'Specs')
      FileUtils.rm(File.join(new_specs_path, "file.zip"))
      FileUtils.rm_rf(specs_path)
      FileUtils.mv(new_specs_path, specs_path)
      nil
    end

    private
    def get_temporary_path
      temp_path = File.join(@path, 'Specs.new')
      FileUtils.rm_rf(temp_path)
      temp_path
    end
  end
end

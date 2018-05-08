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
require 'yaml'

# Main namespace for cocoapods-repo-sq plugin
module CocoapodsRepoSq
  # Class responsible for managing user configured Square SDK repositories.
  # Repository settings and a local copy of the podspecs are stored on the
  # filesystem inside Cocoapods' home directory.
  class RepositoryStore
    # Default store located in Cocoapods's home directory.
    # Used by the plugin to look for registered repositories or by the `repo-sq`
    # commands to manage registered repositories.
    #
    # @return [RepositoryStore]
    #   the default RepositoryStore
    def self.default
      @default ||= new
    end

    # @param path [String]
    #   the path where all Square SDK repositories will be stored. If no path
    #   is provided a default `$COCOAPODS_HOME/repo-sq` will be used
    def initialize(path = nil)
      path ||= File.join(Pod::Config.instance.home_dir, 'repo-sq')
      @path = ensure_path(path)
    end

    # Indicates if a Square SDK repository has been added to the store
    #
    # @param name [String]
    #   the Square SDK repository name to look for
    #
    # @return [Boolean]
    #   `true` if the targeted Square SDK repository is configured in this
    #   repository store, otherwise `false`.
    def exists?(name)
      File.exists?(settings_path(name))
    end

    # Returns all repositories currently configured in the store as a list of
    # {Repository} objects
    #
    # @return [Array<Repository>]
    #   the list of all Square SDK repositories
    def list
      Dir[File.join(@path, '*')].map do |dir|
        name = File.basename(dir)
        get(name)
      end.compact
    end

    # Returns a {Repository} instance if a Square SDK repository exists in the
    # store with the given name
    #
    # @param name [String]
    #   the Square SDK repository name to look for
    #
    # @return [Repository]
    #   a Square SDK repository
    def get(name)
      return unless exists?(name)

      settings = load_settings!(name)
      Repository.new(
        settings[:name],
        settings[:username],
        settings[:password],
        settings[:url],
        repository_path(name)
      )
    end

    # Registers a Square SDK repository on the local store
    #
    # @param name [String]
    #   the Square SDK repository name.
    #
    # @param username [String]
    #   the Square SDK repository username.
    #
    # @param password [String]
    #   the Square SDK repository password.
    #
    # @param url [String]
    #   the Square SDK repositories server URL.
    #
    # @return [Repository]
    #   a Square SDK repository
    #
    # @raise [Pod::Informative]
    #   if the repository has already been configured
    def register(name, username, password, url)
      if exists?(name)
        message = "Square SDK repository `#{name}` is already configured"
        raise Pod::Informative, message
      end

      begin
        store_settings!(name, username, password, url)
        Repository.new(name, username, password, url, repository_path(name))
      rescue => error
        remove(name)
        raise error
      end
    end

    # Removes a Square SDK repository from the local store
    #
    # @param name [String]
    #   the name of the Square SDK Repository to be removed.
    #
    # @return [Boolean]
    #   `true` if the targeted Square SDK repository was removed from the store,
    #   otherwise `false`.
    def remove(name)
      path = repository_path(name)
      File.exists?(path) && FileUtils.rm_rf(path) && true
    end

    private
    def load_settings!(name)
      YAML.load_file(settings_path(name))
    end

    def store_settings!(name, username, password, url)
      settings = {
        name: name,
        username: username,
        password: password,
        url: url
      }

      settings_filename = settings_path(name)
      ensure_path(File.dirname(settings_filename))
      File.open(settings_filename, 'w') { |f| YAML.dump(settings, f) }
    end

    def ensure_path(path)
      FileUtils.mkpath(path)
      path
    end

    def repository_path(name)
      File.join(@path, name)
    end

    def settings_path(name)
      File.join(repository_path(name), '.settings.yml')
    end
  end
end

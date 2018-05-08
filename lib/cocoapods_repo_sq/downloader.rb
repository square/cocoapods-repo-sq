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
  # Implemenents a {https://github.com/CocoaPods/cocoapods-downloader
  # downloader strategy} to support downloading files from a Square SDK
  # repository server over the HTTPS protocol with
  # {https://tools.ietf.org/html/rfc7617 Basic HTTP Authentication RFC7617}
  class Downloader < ::Pod::Downloader::Http
    # Helper module used to override the {::Pod::Downloader::downloader_class_by_key} method to
    # include a `:square` key pointing to {Downloader}. This allows square to be
    # defined as the protocol for downloading Pods on the
    # {https://guides.cocoapods.org/syntax/podspec.html#source
    # podfile source setting}
    module Extensions
      # Map of downloaded classes supported by Cocoapods available to the
      # {https://guides.cocoapods.org/syntax/podspec.html#source podfile source
      # setting}. Square is included to add support for Square SDK repository
      # hosted podspecs and pods.
      #
      # @return [Hash{Symbol=>Class}]
      #   a map where the key is a symbol used in the podspec source
      #   setting such as `:http`, `:git`, `:square` and the class is the one
      #   responsible for implementing a particular download strategy
      def downloader_class_by_key
        super.merge(:square => Downloader)
      end
    end

    # Options accepted by this dowmloader strategy.
    # The base class already supports `:flatten`, `:type`, `:sha256`, `:sha1`.
    # {Downloader} supports passing a `:repository` option to indicate which
    # Square SDK repository to download files from. If none is provided, it
    # will try to use the current repository. See {Repository#current}
    #
    # @return [Array<Symbol>]
    #   a list of accepted options
    def self.options
      super + [:repository]
    end

    # Square SDK repository to be used by this downloader.
    # It can be passed as an option when initializing this class or also taken
    # from the current repository. See {Repository#current}
    #
    # @return [CocoapodsRepoSq::Repository]
    #   a Square SDK repository
    def repository
      @repository ||= options.fetch(:repository) { Repository.current }
    end

    private
    def download_file(full_filename)
      auth = "#{repository.username}:#{repository.password}"
      download_url = File.join(repository.url, url)
      curl! '-u', auth, '-f', '-L', '-o', full_filename, download_url, '--create-dirs', '--netrc-optional'
    end
  end
end

Pod::Downloader.class_eval do
  class << self
    # override `downloader_class_by_key` method. See documentation on the
    # prepended class
    prepend ::CocoapodsRepoSq::Downloader::Extensions
  end
end

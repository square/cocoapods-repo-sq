CocoapodsRepoSq
===============
[![Gem Version](https://badge.fury.io/rb/cocoapods-repo-sq.svg)](http://rubygems.org/gems/cocoapods-repo-sq)
[![Build Status](https://travis-ci.org/square/cocoapods-repo-sq.svg?branch=master)](https://travis-ci.org/square/cocoapods-repo-sq)
[![Apache 2 licensed](https://img.shields.io/badge/license-Apache2-blue.svg)](https://github.com/square/cocoapods-repo-sq/blob/master/LICENSE)

Adds support for Square SDK Repositories to Cocoapods

## Installation

    $ gem install cocoapods-repo-sq

## Usage

### Integrate in your project

Add a Square SDK Repository to your local cocoapods registry. `NAME` is a nickname you'll use to refer to this repository later in your `Podfile` and other `pod repo-sq` commands:
```shell
$ pod repo-sq add NAME USERNAME PASSWORD
```

Specify your Square SDK repository in your `Podfile`:
```ruby
plugin 'cocoapods-repo-sq', :repository => 'NAME'

target 'MyTarget' do
  pod 'SquareSDK'
end
```

### Commands

Add

    $ pod repo-sq add NAME USERNAME PASSWORD

List

    $ pod repo-sq list

Update

    $ pod repo-sq update NAME

Remove

    $ pod repo-sq remove NAME

## Multiple Applications

If you have multiple Square Applications you will have multiple SDK Repositories. `cocoapods-repo-sq` supports this by allowing you to add multiple repositories to your registry. Just remember to point your `Podfile` to the right one using the `plugin 'cocoapods-repo-sq', :repository => 'NAME'` statement.

## Contributing

We are currently not accepting code contributions to this repository. If you found a bug or have a feature request please [Submit it here](https://github.com/square/cocoapods-repo-sq/issues/new).

If you are curious about Cocoapods and its plugin system take a look at the following guides:
- https://blog.cocoapods.org/CocoaPods-0.28/
- https://guides.cocoapods.org/reference.html
- https://github.com/CocoaPods/cocoapods-plugins

## Building

    $ rake build

## Testing

    $ rake specs

## License

    Copyright 2018 Square Inc.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

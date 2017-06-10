# Acknowledgements `fastlane` plugin

[![Fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-acknowledgements)
![Build Status](https://api.travis-ci.org/simonrice/fastlane-plugin-acknowledgements.svg)
![](http://ruby-gem-downloads-badge.herokuapp.com/fastlane-plugin-acknowledgements)
[![Twitter: @_simonrice](https://img.shields.io/badge/contact-@_simonrice-blue.svg?style=flat)](https://twitter.com/_simonrice)
[![License](https://img.shields.io/badge/license-Beerware_🍺-green.svg?style=flat)](https://github.com/simonrice/fastlane-plugin-acknowledgements/blob/master/LICENSE)

Helping developers give credit where it's rightfully due in an automated fashion!

This plugin builds on the good work done by Christophe Knage on [iOS AcknowledgementGenerator](https://github.com/cvknage/iOS-AcknowledgementGenerator) in the form of a Fastlane plugin, along with adding the ability to strip unwanted markdown from license files.

By the way, Christophe if you're reading this, I owe you a drink should I ever meet you 🍻.

## Getting started

### 1.  Gather your license files

Place all of your licenses from your various dependencies in a directory (e.g., a `licenses` folder in your project directory).  Each license file should be named after your dependency (so an Alamofire license file should be called `Alamofire.license`)

### 2.  Create a settings bundle in your project

You'll see the acknowledgements in your app's settings scene, so create a settings bundle & ensure it is included in your target.

### 3.  Add Plugin

```bash
fastlane add_plugin acknowledgements
```

### 4.  Use the plugin in the Fastfile

```ruby
acknowledgements(
  settings_bundle: 'path/to/settings.bundle',
  license_path: 'path/to/licenses'
)
```

You can also specify a different extension for your licenses using the optional `license_extension` parameter:

```ruby
license_extension: '.acknowledgement'
```

## Run tests for this plugin

To run both the tests & code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://github.com/fastlane/fastlane/blob/master/fastlane/docs/PluginsTroubleshooting.md) doc in the main `fastlane` repo.

## Using `fastlane` Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://github.com/fastlane/fastlane/blob/master/fastlane/docs/Plugins.md).

## License

Released under the BEER-WARE License 🍺. See the
[LICENSE](https://github.com/simonrice/fastlane-plugin-acknowledgements/blob/master/LICENSE)
file for more information.

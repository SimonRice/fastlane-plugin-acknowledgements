require 'CFPropertyList'
require 'redcarpet'

module Fastlane
  module Actions
    class AcknowledgementsAction < Action

      ACKNOWLEDGEMENT_GENERATOR_LICENSE = '"THE BEER-WARE LICENSE" (Revision 42):' +
        '
        ' +
        '<http://www.knage.net> & <https://simonrice.com> wrote this file. As long as you retain this notice you ' +
        'can do whatever you want with this stuff. If we meet some day, and you think ' +
        'this stuff is worth it, you can buy me a beer in return Christophe Vallinas Knage & Simon Rice.'

        def self.create_acknowledgement(name, content, settings_bundle)
          # Create a arbitrary data structure of basic data types
          acknowledgement = {
            'StringsTable' => 'ThirdPartyLicenses',
            'PreferenceSpecifiers' => [{
              'Type' => 'PSGroupSpecifier',
              'FooterText' => content
              }]
          }

          # Generate name for acknowledgement plist
          acknowledgementName = "Acknowledgement-" + name

          # Generate item for acknowledgement list
          acknowledgementListItem = {
                  'Type' => 'PSChildPaneSpecifier',
                  'Title' => name,
                  'File' => acknowledgementName
              }

          # Create plist file
          plist = CFPropertyList::List.new
          plist.value = CFPropertyList.guess(acknowledgement)
          plist.save(settings_bundle + "/" + acknowledgementName + ".plist", CFPropertyList::List::FORMAT_XML)

          # return
          acknowledgementListItem
      end

      def self.save_acknowledgement_list(acknowledgementListItems, settings_bundle)
          # Create a arbitrary data structure of basic data types
          acknowledgementList = {
            'StringsTable' => 'ThirdPartyLicenses',
            'PreferenceSpecifiers' => acknowledgementListItems
          }

          # Create plist file
          plist = CFPropertyList::List.new
          plist.value = CFPropertyList.guess(acknowledgementList)
          plist.save(settings_bundle + "/Acknowledgements.plist", CFPropertyList::List::FORMAT_XML)
      end

      def self.run(params)
        # UI.message "Parameter API Token: #{params[:api_token]}"

        settings_bundle = params[:settings_bundle]
        acknowledgement_list = Array.new
        Dir.glob("#{params[:license_path]}/*#{params[:license_extension]}") do |file|
            UI.message "Parsing: #{file.split('/').last}..."

            # Extract name
            license_file_name = File.basename(file)
            project_name = license_file_name.split('.').first

            # Extract license
            license_file = File.open(file)
            project_license = license_file.read

            # Create Acknowledgement- plist
            parser = Redcarpet::Markdown.new(renderer, extensions = {})
            acknowledgement_item = create_acknowledgement(project_name, project_license, settings_bundle)
            license_file.close
            acknowledgement_list.push(acknowledgement_item)
        end

        # Push AcknowledgementGenerator License
        acknowledgement_generator_license = create_acknowledgement("AcknowledgementGenerator (Fastlane Edition)", ACKNOWLEDGEMENT_GENERATOR_LICENSE, settings_bundle)
        acknowledgement_list.push(acknowledgement_generator_license)
        sorted_acknowledgements = acknowledgement_list.sort_by { |item| item["Title"].downcase }

        # Create Acknowledgements plist
        UI.message "Adding acknowledgements to #{settings_bundle}..."
        save_acknowledgement_list(sorted_acknowledgements, settings_bundle)

        # All finished
        UI.success "Acknowledgement Generator Finished"
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Use Fastlane to give credit where it's rightfully due"
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "You can use this action to do cool things..."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :settings_bundle,
                                       env_name: "FL_ACKNOWLEDGEMENTS_SETTINGS_BUNDLE",
                                       description: "Location of the settings bundle file",
                                       verify_block: proc do |value|
                                          UI.user_error!("No Settings Bundle path for AcknowledgementsAction given, pass using `settings_bundle: 'path/to/settings.bundle'`") unless (value and not value.empty?)
                                          UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
                                       end),

          FastlaneCore::ConfigItem.new(key: :license_path,
                                       env_name: "FL_ACKNOWLEDGEMENTS_LICENSE_PATH",
                                       description: "Path containing the license files",
                                       verify_block: proc do |value|
                                          UI.user_error!("No License path for AcknowledgementsAction given, pass using `license_path: 'path/to/licenses/'`") unless (value and not value.empty?)
                                          UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
                                       end),

          FastlaneCore::ConfigItem.new(key: :license_path,
                                       env_name: "FL_ACKNOWLEDGEMENTS_LICENSE_EXTENSION",
                                       description: "File extension for license files.  Defaults to '.license'.",
                                       default_value: '.license'),
        ]
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["@_simonrice", "@cvknage"]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end

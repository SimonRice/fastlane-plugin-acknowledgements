require 'CFPropertyList'

require 'redcarpet'
require 'redcarpet/render_strip'

module Fastlane
  module Actions
    class AcknowledgementsAction < Action
      ACKNOWLEDGEMENT_GENERATOR_LICENSE = '"THE BEER-WARE LICENSE" (Revision 42):' \
        '
        ' \
        '<http://www.knage.net> & <https://simonrice.com> wrote this file. As long as you retain this notice you ' \
        'can do whatever you want with this stuff. If we meet some day, and you think ' \
        'this stuff is worth it, you can buy me a beer in return Christophe Vallinas Knage & Simon Rice.'.freeze

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
        acknowledgement_name = "Acknowledgement-#{name}"

        # Generate item for acknowledgement list
        acknowledgement_list_item = {
          'Type' => 'PSChildPaneSpecifier',
          'Title' => name,
          'File' => acknowledgement_name
        }

        # Create plist file
        plist = CFPropertyList::List.new
        plist.value = CFPropertyList.guess(acknowledgement)
        plist.save("#{settings_bundle}/#{acknowledgement_name}.plist", CFPropertyList::List::FORMAT_XML)

        # return
        acknowledgement_list_item
      end

      def self.save_acknowledgement_list(acknowledgement_list_items, settings_bundle)
        # Create a arbitrary data structure of basic data types
        acknowledgement_list = {
          'StringsTable' => 'ThirdPartyLicenses',
          'PreferenceSpecifiers' => acknowledgement_list_items
        }

        # Create plist file
        plist = CFPropertyList::List.new
        plist.value = CFPropertyList.guess(acknowledgement_list)
        plist.save("#{settings_bundle}/Acknowledgements.plist", CFPropertyList::List::FORMAT_XML)
      end

      def self.run(params)
        # UI.message "Parameter API Token: #{params[:api_token]}"

        settings_bundle = params[:settings_bundle]
        acknowledgement_list = []
        Dir.glob("#{params[:license_path]}/*#{params[:license_extension]}") do |file|
          UI.message "Parsing: #{file.split('/').last}..."

          # Extract name
          license_file_name = File.basename(file)
          project_name = license_file_name.split('.').first

          # Extract license
          license_file = File.open(file)
          project_license = license_file.read
          parser = Redcarpet::Markdown.new(Redcarpet::Render::StripDown, space_after_headers: true)
          project_license = parser.render(project_license)

          # Create Acknowledgement- plist
          acknowledgement_item = create_acknowledgement(project_name, project_license, settings_bundle)
          license_file.close
          acknowledgement_list.push(acknowledgement_item)
        end

        # Push AcknowledgementGenerator License
        acknowledgement_generator_license = create_acknowledgement('AcknowledgementGenerator (Fastlane Edition)', ACKNOWLEDGEMENT_GENERATOR_LICENSE, settings_bundle)
        acknowledgement_list.push(acknowledgement_generator_license)
        sorted_acknowledgements = acknowledgement_list.sort_by { |item| item['Title'].downcase }

        # Create Acknowledgements plist
        UI.message "Adding acknowledgements to #{settings_bundle}..."
        save_acknowledgement_list(sorted_acknowledgements, settings_bundle)

        # All finished
        UI.success 'Acknowledgement Generator Finished'
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Use Fastlane to give credit where it's rightfully due."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :settings_bundle,
                                       env_name: 'FL_ACKNOWLEDGEMENTS_SETTINGS_BUNDLE',
                                       description: 'Location of the settings bundle file',
                                       verify_block: proc do |value|
                                         UI.user_error!("No Settings Bundle path for AcknowledgementsAction given, pass using `settings_bundle: 'path/to/settings.bundle'`") unless value && !value.empty?
                                         UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
                                       end),

          FastlaneCore::ConfigItem.new(key: :license_path,
                                       env_name: 'FL_ACKNOWLEDGEMENTS_LICENSE_PATH',
                                       description: 'Path containing the license files',
                                       verify_block: proc do |value|
                                         UI.user_error!("No License path for AcknowledgementsAction given, pass using `license_path: 'path/to/licenses/'`") unless value && !value.empty?
                                         UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
                                       end),

          FastlaneCore::ConfigItem.new(key: :license_extension,
                                       env_name: 'FL_ACKNOWLEDGEMENTS_LICENSE_EXTENSION',
                                       description: "File extension for license files.  Defaults to '.license'.",
                                       default_value: '.license')
        ]
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ['@_simonrice', '@cvknage']
      end

      def self.is_supported?(_platform)
        true
      end
    end
  end
end

# -*- coding: utf-8 -*-

require "fileutils"

module Magellan
  module Cli
    module FileAccess

      class NotSelected < Magellan::Cli::Error
      end

      DEFAULT_SELECTION_FILENAME = File.expand_path("~/.config/magellan/magellan-cli")

      module_function

      def selection_filename
        ENV["MAGELLAN_CLI_CONFIG_FILE"] || DEFAULT_SELECTION_FILENAME
      end

      def remove_selection_file
        File.exist?(selection_filename) && File.delete(selection_filename)
      end

      def load_selections
        File.readable?(selection_filename) ? YAML.load_file(selection_filename) : {}
      end

      # check if ~/.config/magellan directory exists.
      def ensure_config_dir
        return if ENV["MAGELLAN_CLI_CONFIG_FILE"]
        default_dir = File.dirname(DEFAULT_SELECTION_FILENAME)
        unless File.directory?(default_dir)
          # This is notification message to be displayed at the first time magellan-cli invoked.
          puts I18n.t(:config_file, scope: [:base, :notification])
          FileUtils.mkdir_p(default_dir)
        end
      end

      # @param [Class|String] obj Resource class or resource name
      def load_selection(obj)
        if obj.respond_to?(:parameter_name)
          name = obj.parameter_name
          label = obj.name.split(/::/).last.underscore
        else
          name = label = obj
        end
        sel = load_selections
        s = sel[name]
        raise NotSelected, I18n.t(:not_selected, scope: [:file_access, :load_selection], label: label) unless s
        return s
      end

      def update_selections(hash = nil)
        sel = load_selections
        sel.update(hash) if hash
        yield(sel) if block_given?
        filepath = selection_filename
        unless File.exist?(File.dirname(filepath))
          FileUtils.mkdir_p(File.dirname(filepath))
        end
        open(filepath, "w") do |f|
          f.chmod 0600
          YAML.dump(sel, f)
        end
      end
    end
  end
end

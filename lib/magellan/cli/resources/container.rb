# -*- coding: utf-8 -*-
require "magellan/cli/resources"

module Magellan
  module Cli
    module Resources

      class Container < Base
        self.resource_key = "container~instance"
        self.resource_dependency = {"stage" => Stage::VERSION_PARAMETER_NAME}
        self.hidden_fields = %w[created_at updated_at].map(&:freeze).freeze
        self.multiline_fields = %w[docker_properties_json links_yaml publishings_yaml volumes_yaml env_yaml].map(&:freeze).freeze
        self.field_associations = {
          "stage_version_id" => {name: "stage", resource: "stage~version"},
          "container_image_id" => {name: "image", class: "Image"},
        }
      end

    end
  end
end

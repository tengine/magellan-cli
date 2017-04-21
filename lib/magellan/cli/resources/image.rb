# -*- coding: utf-8 -*-
require "magellan/cli/resources"

module Magellan
  module Cli
    module Resources

      class Image < Base
        self.resource_key = "container~image"
        self.resource_dependency = {"stage" => Stage::VERSION_PARAMETER_NAME}
        self.hidden_fields = %w[function_id function_type created_at updated_at].map(&:freeze).freeze
        self.field_associations = {"stage_version_id" => {name: "stage", resource: "stage~version"} }
      end

    end
  end
end

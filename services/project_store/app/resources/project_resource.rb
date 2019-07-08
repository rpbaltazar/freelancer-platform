# frozen_string_literal: true

class ProjectResource < ApplicationResource
  attributes :name, :hourly_rate, :currency
  filter :primary_identifier
end

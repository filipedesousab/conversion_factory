# frozen_string_literal: true

require_relative 'conversion_factory/build'
require_relative 'conversion_factory/entities'
require_relative 'conversion_factory/errors'
require_relative 'conversion_factory/version'

module ConversionFactory
  module_function

  def build(**params)
    Build.new(**params)
  end
end

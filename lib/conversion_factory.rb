# frozen_string_literal: true

require_relative 'conversion_factory/version'
require_relative 'conversion_factory/build'
require_relative 'conversion_factory/errors'

module ConversionFactory
  module_function

  def build(**params)
    Build.new(**params)
  end
end

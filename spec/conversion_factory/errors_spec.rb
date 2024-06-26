# frozen_string_literal: true

RSpec.describe ConversionFactory::Errors do
  after { ConversionFactory.configuration.raise_exception = true }

  it do
    msg = 'Lorem ipsum...'
    conversion_factory = ConversionFactory.build
    conversion_factory.push_error(ConversionFactory::Errors::NonExistentFile.new)
    conversion_factory.push_error(msg)

    expect(conversion_factory.errors.to_s).to eq(['ConversionFactory::Errors::NonExistentFile', msg])
  end
end

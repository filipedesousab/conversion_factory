# frozen_string_literal: true

require_relative '../../support/html_to_image_converter'

RSpec.describe ConversionFactory::Entities::Performer do
  let(:converter) { HTMLToImageConverter.new }
  let(:output_path) { "#{File.dirname(__FILE__)}/../../support/tmp" }
  let(:file_path) { 'spec/fixtures/text-plain.html' }
  let(:input_file) { ConversionFactory::Entities::InputFile.new(file: file_path) }

  describe '#converter' do
    context 'when converter is passed by argument' do
      it do
        performer = described_class.new(converter: converter)

        expect(performer.converter).to eq(converter)
      end
    end

    context 'when the converter is assigned' do
      it do
        performer = described_class.new
        performer.converter = converter

        expect(performer.converter).to eq(converter)
      end
    end
  end

  describe '#output_path' do
    context 'when the output_path is a string' do
      let(:performer) { described_class.new(output_path: output_path) }

      it { expect(performer.output_path.class).to eq(Pathname) }
      it { expect(performer.output_path.to_s).to eq(output_path) }
    end

    context 'when the output_path is a Pathname object' do
      let(:performer) { described_class.new(output_path: Pathname.new(output_path)) }

      it { expect(performer.output_path.to_s).to eq(output_path) }
    end

    context 'when the output_path is assigned' do
      it do
        performer = described_class.new(output_path: output_path)
        performer.output_path = another_output_path = '/tmp/another_output_path'

        expect(performer.output_path.to_s).to eq(another_output_path)
      end
    end
  end

  describe '#output_extension' do
    context 'when output_extension is passed by argument' do
      it do
        output_extension = 'jpg'
        performer = described_class.new(output_extension: output_extension)

        expect(performer.output_extension).to eq(output_extension)
      end
    end

    context 'when the output_extension is assigned' do
      it do
        performer = described_class.new(output_extension: 'jpg')
        performer.output_extension = another_output_extension = 'png'

        expect(performer.output_extension.to_s).to eq(another_output_extension)
      end
    end
  end

  describe '#run' do
    context 'when you dont have the output_path' do
      it do
        performer = described_class.new(converter: converter, output_extension: 'xyz')

        expect { performer.run(input_file) }.to raise_error(
          ConversionFactory::Errors::EmptyOutputPath,
          "Empty output path to #{input_file.file} and #{converter.name}"
        )
      end
    end

    context 'when you dont have the output_extension' do
      it do
        performer = described_class.new(converter: converter, output_path: output_path)

        expect { performer.run(input_file) }.to raise_error(
          ConversionFactory::Errors::EmptyOutputExtension,
          "Empty output extension to #{input_file.file} and #{converter.name}"
        )
      end
    end

    context 'when arguments are valid' do
      let(:performer) { described_class.new(converter: converter, output_path: output_path, output_extension: 'xyz') }

      before { performer.run(input_file) }

      after { performer.output_path.delete }

      it { expect(File.exist?(output_path)).to be(true) }
      it { expect(converter.success).to be(true) }
    end
  end
end

# frozen_string_literal: true

require_relative 'support/html_to_image_converter'

RSpec.describe ConversionFactory do
  let(:input_file_path) { 'spec/fixtures/text-plain.html' }
  let(:converter) { HTMLToImageConverter.new }

  it 'has a version number' do
    expect(ConversionFactory::VERSION).not_to be_nil
  end

  describe '#input_files' do
    context 'when the input is a string' do
      let(:conversion_factory) { described_class.build(input_files: [{ file: input_file_path }]) }

      it { expect(conversion_factory.input_files.first.class).to eq(ConversionFactory::Entities::InputFile) }
      it { expect(conversion_factory.input_files.first.file.path).to eq(input_file_path) }
    end

    context 'when the input is a InputFile object' do
      let(:input_file) { ConversionFactory::Entities::InputFile.new(file: input_file_path) }
      let(:conversion_factory) { described_class.build(input_files: [input_file]) }

      it { expect(conversion_factory.input_files.first.class).to eq(ConversionFactory::Entities::InputFile) }
      it { expect(conversion_factory.input_files.first.file.path).to eq(input_file_path) }
    end

    context 'when the input is assigned' do
      it do
        conversion_factory = described_class.build(input_files: [{ file: input_file_path }])
        conversion_factory.input_files = [{ file: __FILE__ }]

        expect(conversion_factory.input_files.first.file.path).to eq(__FILE__)
      end
    end
  end

  describe '#output_path' do
    context 'when set tmp path automatically' do
      let(:conversion_factory) { described_class.build }

      it { expect(conversion_factory.output_path.class).to eq(Pathname) }
      it { expect(conversion_factory.output_path.to_s).to eq(Dir.tmpdir) }
    end

    context 'when output_path is passed by argument' do
      it do
        output_path = '/tmp/output_path'
        conversion_factory = described_class.build(output_path: output_path)

        expect(conversion_factory.output_path.to_s).to eq(output_path)
      end
    end

    context 'when the output_path is a Pathname object' do
      it do
        output_path = '/tmp/output_path'
        conversion_factory = described_class.build(output_path: Pathname.new(output_path))

        expect(conversion_factory.output_path.to_s).to eq(output_path)
      end
    end

    context 'when the output_path is assigned' do
      it do
        conversion_factory = described_class.build
        conversion_factory.output_path = output_path = '/tmp/output_path'

        expect(conversion_factory.output_path.to_s).to eq(output_path)
      end
    end
  end

  describe '#performers' do
    context 'when the performer receives the default output_path' do
      it do
        conversion_factory = described_class.build(performers: [{ 'converter' => converter }])

        expect(conversion_factory.performers.first.output_path).to(
          eq(conversion_factory.output_path)
        )
      end
    end

    context 'when the output_path is defined for the performer' do
      let(:output_path) { '/tmp/output_path' }

      it do
        conversion_factory = described_class.build(performers: [{ converter: converter,
                                                                  output_path: output_path }])

        expect(conversion_factory.performers.first.output_path.to_s).to eq(output_path)
      end
    end

    context 'when the performers is assigned' do
      it do
        conversion_factory = described_class.build
        conversion_factory.performers = [{ 'converter' => converter }]

        expect(conversion_factory.performers.first.converter).to eq(converter)
      end
    end
  end

  describe '#run' do
    context 'when the performers were not passed' do
      it do
        conversion_factory = described_class.build

        expect(conversion_factory.run).to eq([])
      end
    end

    context 'when passed a input_files with params' do
      let(:output_path) { '/tmp/output_path' }
      let(:output_filename) { 'file1' }
      let(:conversion_factory) do
        described_class.build(input_files: [{ file: input_file_path, output_path: output_path,
                                              output_filename: output_filename }],
                              performers: [{ converter: converter }])
      end

      before { conversion_factory.run }

      it do
        message = converter.generate_message(input_file_path: input_file_path, output_path: output_path,
                                             output_filename: output_filename)

        expect { conversion_factory.run }.to output(a_string_including(message)).to_stdout
      end
    end
  end
end

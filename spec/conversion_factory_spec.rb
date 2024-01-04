# frozen_string_literal: true

RSpec.describe ConversionFactory do
  let(:input_file_path) { 'spec/fixtures/text-plain.html' }
  let(:converter) do
    methods = proc do |_|
      def convert(input: nil, content_type: nil, output_path: nil, output_filename: nil)
        self.input = input
        self.content_type = content_type
        self.output_path = output_path
        self.output_filename = output_filename
        true
      end
    end

    Struct.new(:input, :content_type, :output_path, :output_filename, keyword_init: true, &methods)
          .new(input: nil, content_type: nil, output_path: nil, output_filename: nil)
  end

  it 'has a version number' do
    expect(ConversionFactory::VERSION).not_to be_nil
  end

  describe '#input' do
    context 'when the input is a string' do
      let(:conversion_factory) { described_class.build(input: input_file_path) }

      it { expect(conversion_factory.input.class).to eq(File) }
      it { expect(conversion_factory.input.path).to eq(input_file_path) }
    end

    context 'when the input is a File object' do
      let(:conversion_factory) { described_class.build(input: File.new(input_file_path)) }

      it { expect(conversion_factory.input.class).to eq(File) }
      it { expect(conversion_factory.input.path).to eq(input_file_path) }
    end

    context 'when the input is assigned' do
      it do
        conversion_factory = described_class.build(input: input_file_path)
        conversion_factory.input = __FILE__

        expect(conversion_factory.input.path).to eq(__FILE__)
      end
    end

    context 'when the file is not found' do
      it do
        file_path = 'spec/fixtures/non_existent_file.html'

        expect do
          described_class.build(input: file_path)
        end.to raise_error(ConversionFactory::Errors::NonExistentFile)
      end
    end
  end

  describe '#content_type' do
    context 'when it automatically identifies' do
      it do
        conversion_factory = described_class.build(input: input_file_path)

        expect(conversion_factory.content_type).to eq('text/html')
      end
    end

    context 'when content_type is passed by argument' do
      it do
        content_type = 'other'
        conversion_factory = described_class.build(input: input_file_path, content_type: content_type)

        expect(conversion_factory.content_type).to eq(content_type)
      end
    end

    context 'when the content_type is assigned' do
      it do
        conversion_factory = described_class.build(input: input_file_path)
        conversion_factory.content_type = content_type = 'other'

        expect(conversion_factory.content_type).to eq(content_type)
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

  describe '#output_filename' do
    context 'when output_filename is passed by argument' do
      it do
        output_filename = 'file1'
        conversion_factory = described_class.build(output_filename: output_filename)

        expect(conversion_factory.output_filename).to eq(output_filename)
      end
    end

    context 'when the output_path is assigned' do
      it do
        conversion_factory = described_class.build
        conversion_factory.output_filename = output_filename = 'file1'

        expect(conversion_factory.output_filename).to eq(output_filename)
      end
    end
  end

  describe '#converters' do
    context 'when hash keys are not symbols and are transformed' do
      it do
        conversion_factory = described_class.build(converters: [{ 'converter' => converter }])

        expect(conversion_factory.converters.first.keys).to match_array([:converter])
      end
    end

    context 'when the converters is assigned' do
      it do
        conversion_factory = described_class.build
        conversion_factory.converters = [{ 'converter' => converter }]

        expect(conversion_factory.converters).to eq([{ converter: converter }])
      end
    end
  end

  describe '#run' do
    context 'when the converters were not passed' do
      it do
        conversion_factory = described_class.build

        expect(conversion_factory.run).to eq([])
      end
    end

    context 'when passed a converter without params' do
      let(:conversion_factory) do
        described_class.build(converters: [{ converter: converter }])
      end

      before { conversion_factory.run }

      it { expect(conversion_factory.run).to eq([true]) }
      it { expect(converter.content_type).to eq(conversion_factory.content_type) }
      it { expect(converter.output_path).to eq(conversion_factory.output_path) }
      it { expect(converter.output_filename).to eq(conversion_factory.output_filename) }
    end

    context 'when passed a converter with params' do
      let(:output_path) { '/tmp/output_path' }
      let(:output_filename) { 'file1' }
      let(:conversion_factory) do
        described_class.build(converters: [{ converter: converter,
                                             output_path: output_path,
                                             output_filename: output_filename }])
      end

      before { conversion_factory.run }

      it { expect(converter.output_path.to_s).to eq(output_path) }
      it { expect(converter.output_filename).to eq(output_filename) }
    end
  end
end

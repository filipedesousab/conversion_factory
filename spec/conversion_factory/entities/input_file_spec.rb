# frozen_string_literal: true

RSpec.describe ConversionFactory::Entities::InputFile do
  let(:filename) { 'text-plain' }
  let(:file_path) { "spec/fixtures/#{filename}.html" }

  describe '#file' do
    context 'when the file is a string' do
      let(:input_file) { described_class.new(file: file_path) }

      it { expect(input_file.file.class).to eq(Pathname) }
      it { expect(input_file.file.to_s).to eq(file_path) }
    end

    context 'when the file is a Pathname object' do
      let(:input_file) { described_class.new(file: Pathname.new(file_path)) }

      it { expect(input_file.file.class).to eq(Pathname) }
      it { expect(input_file.file.to_s).to eq(file_path) }
    end

    context 'when the file is a FIle object' do
      let(:input_file) { described_class.new(file: File.new(file_path)) }

      it { expect(input_file.file.class).to eq(Pathname) }
      it { expect(input_file.file.to_s).to eq(file_path) }
    end

    context 'when the file is assigned' do
      it do
        input_file = described_class.new(file: file_path)
        input_file.file = __FILE__

        expect(input_file.file.to_s).to eq(__FILE__)
      end
    end

    context 'when the file is not found' do
      it do
        file_path = 'spec/fixtures/non_existent_file.html'

        expect { described_class.new(file: file_path) }.to raise_error(
          ConversionFactory::Errors::NonExistentFile,
          "Non existent file to path #{file_path}"
        )
      end
    end
  end

  describe '#content_type' do
    context 'when it automatically identifies' do
      it do
        input_file = described_class.new(file: file_path)

        expect(input_file.content_type).to eq('text/html')
      end
    end

    context 'when content_type is passed by argument' do
      it do
        content_type = 'other'
        input_file = described_class.new(file: file_path, content_type: content_type)

        expect(input_file.content_type).to eq(content_type)
      end
    end

    context 'when the content_type is assigned' do
      it do
        input_file = described_class.new(file: file_path)
        input_file.content_type = content_type = 'other'

        expect(input_file.content_type).to eq(content_type)
      end
    end
  end

  describe '#output_path' do
    let(:output_path) { '/tmp/output_path' }

    context 'when the output_path is a string' do
      let(:input_file) { described_class.new(output_path: output_path) }

      it { expect(input_file.output_path.class).to eq(Pathname) }
      it { expect(input_file.output_path.to_s).to eq(output_path) }
    end

    context 'when the output_path is a Pathname object' do
      it do
        input_file = described_class.new(output_path: Pathname.new(output_path))

        expect(input_file.output_path.to_s).to eq(output_path)
      end
    end

    context 'when the output_path is assigned' do
      it do
        input_file = described_class.new(output_path: output_path)
        input_file.output_path = another_output_path = '/tmp/another_output_path'

        expect(input_file.output_path.to_s).to eq(another_output_path)
      end
    end
  end

  describe '#output_filename' do
    context 'when it automatically identifies' do
      it do
        input_file = described_class.new(file: file_path)

        expect(input_file.output_filename).to eq(filename)
      end
    end

    context 'when output_filename is passed by argument' do
      it do
        output_filename = 'file1'
        input_file = described_class.new(output_filename: output_filename)

        expect(input_file.output_filename).to eq(output_filename)
      end
    end

    context 'when the output_filename is assigned' do
      it do
        input_file = described_class.new
        input_file.output_filename = output_filename = 'file1'

        expect(input_file.output_filename).to eq(output_filename)
      end
    end
  end

  describe '#output_extension' do
    context 'when output_extension is passed by argument' do
      it do
        output_extension = 'jpg'
        input_file = described_class.new(output_extension: output_extension)

        expect(input_file.output_extension).to eq(output_extension)
      end
    end

    context 'when the output_extension is assigned' do
      it do
        input_file = described_class.new
        input_file.output_extension = output_extension = 'jpg'

        expect(input_file.output_extension).to eq(output_extension)
      end
    end
  end

  describe '#output_type' do
    context 'when output_type is passed by argument' do
      it do
        output_type = 'jpeg'
        input_file = described_class.new(output_type: output_type)

        expect(input_file.output_type).to eq(output_type)
      end
    end

    context 'when the output_type is assigned' do
      it do
        input_file = described_class.new
        input_file.output_type = output_type = 'jpg'

        expect(input_file.output_type).to eq(output_type)
      end
    end
  end
end

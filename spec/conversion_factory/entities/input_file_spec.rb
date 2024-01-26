# frozen_string_literal: true

RSpec.describe ConversionFactory::Entities::InputFile do
  let(:file_path) { 'spec/fixtures/text-plain.html' }

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

        expect do
          described_class.new(file: file_path)
        end.to raise_error(ConversionFactory::Errors::NonExistentFile)
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
end

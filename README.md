# ConversionFactory

ConversionFactory is a library that facilitates the conversion of multiple files with multiple converters.
With ConversionFactory you can select several input files, even of different types and define different converters with their appropriate settings, in addition to being able to select the file storage location generally or individually for each file and converter.
You may be wondering how a converter will be able to convert file types other than what it accepts. Each converter will only convert supported files, others will be ignored.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'conversion_factory'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install conversion_factory

## Usage

Using ConversionFactory is quite simple. Basically an instance of the ConversionFactory is created passing a list of files to be converted and a list of converters.

```ruby
converter = HTMLToImageConverter.new

conversion_factory = ConversionFactory.build(input_files: [{ file: '/path/to/file' }],
                                             performers: [{ converter: converter }])
conversion_factory.run
```
> Converters must follow an interface expected by the ConversionFactory, as mentioned later. You can create your own converter or use an available one.

Arguments expected by `ConversionFactory.build`
|Argument   |Description                                                                                      |Required|Accepted types      |
|-----------|-------------------------------------------------------------------------------------------------|--------|--------------------|
|input_files|List of files to be converted with their arguments                                               |false   |Array               |
|performers |List of converters with their arguments                                                          |false   |Array               |
|output_path|Default output path. When not defined, the temporary path will be set to default, usually `/tmp`.|false   |[String \| Pathname]|

Arguments expected by `input_files`
|Argument        |Description                                                            |Required|Accepted types      |
|----------------|-----------------------------------------------------------------------|--------|--------------------|
|file            |File to be converted                                                   |true    |[String \| Pathname]|
|content_type    |MIME type of the file. When not defined, it is automatically identified|false   |String              |
|output_path     |File output path                                                       |false   |[String \| Pathname]|
|output_filename |Generated file name                                                    |false   |String              |

Arguments expected by `performers`
|Argument        |Description         |Required|Accepted types      |
|----------------|--------------------|--------|--------------------|
|converter       |Converter to be used|true    |Object              |
|output_path     |File output path    |false   |[String \| Pathname]|

### Converter

The converter must have at least one method called `convert` that receives input, content_type, output_path and output_filename as keyword arguments.

Example of a converter

```ruby
class HTMLToImageConverter
  ACCEPTED_TYPES = ['text/html'].freeze

  def convert(input:, content_type: nil, output_path: nil, output_filename: nil)
    raise ConversionFactory::Errors::InvalidType unless ACCEPTED_TYPES.include?(content_type)

    kit = IMGKit.new(File.new(input))
    kit.to_file("#{output_path}/#{output_filename}.jpg")
  end
end
```
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/filipedesousab/conversion_factory. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/filipedesousab/conversion_factory/blob/main/CODE_OF_CONDUCT.md).

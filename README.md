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
|output_extension|Generated file extension                                               |false   |String              |
|output_type     |Generated file type                                                    |false   |String              |

Arguments expected by `performers`
|Argument        |Description          |Required|Accepted types      |
|----------------|---------------------|--------|--------------------|
|converter       |Converter to be used |true    |Converter Object    |
|output_path     |File output path     |false   |[String \| Pathname]|
|output_extension|File output extension|false   |String              |
|output_type     |File output type     |false   |String              |

### Errors output

By default errors are generated, but it is possible to disable them by setting the raise_exception setting to false.

The errors are
|Error                                          |Message                                                  |
|-----------------------------------------------|---------------------------------------------------------|
|ConversionFactory::Errors::EmptyOutputExtension|Empty output extension to /path/to/file and ConverterName|
|ConversionFactory::Errors::EmptyOutputPath     |Empty output path to /path/to/file and ConverterName     |
|ConversionFactory::Errors::EmptyOutputType     |Empty output type to /path/to/file and ConverterName     |
|ConversionFactory::Errors::InvalidInputType    |                                                         |
|ConversionFactory::Errors::InvalidOutputType   |                                                         |
|ConversionFactory::Errors::NonExistentFile     |Non existent file to path /path/to/non_existent_file     |

Erros can be accessed through the errors method of the builded instance of ConversionFactory.
The errors method return a list of errors generated during the execution of compilation.
The errors method can return a list of errors messages using the `to_s` method.

```ruby
conversion_factory = ConversionFactory.build(...)
conversion_factory.run
conversion_factory.errors # [#<ConversionFactory::Errors::NonExistentFile: Non existent file to path /path/to/non_existent_file>, #<StandardError: Lorem ipsum...>]
conversion_factory.errors.to_s # ["Non existent file to path /path/to/non_existent_file", "Lorem ipsum..."]
```

### Configuration

Is possible change default values configurations.

|Config         |Default value|Accepted types      |Description                                                                                                                               |
|---------------|-------------|--------------------|------------------------------------------------------------------------------------------------------------------------------------------|
|output_path    |Dir.tmpdir   |[String \| Pathname]|Output of converted files. It works globally, but will be overwritten if the output_path is defined in the performer or in the input_file|
|raise_exception|true         |boolean             |By default, errors are generated, but it is possible to disable them through this configuration|

```ruby
# config/initializers/conversion_factory.rb

ConversionFactory.configure do |config|
  config.output_path = 'output/path'
  config.raise_exception = false
end
```

### Converter

The converter must have at least one method called `convert` that receives input, content_type, output_path and output_filename as keyword arguments.

|Method                  |Required|Description                                                                                                     |
|------------------------|--------|----------------------------------------------------------------------------------------------------------------|
|name                    |true    |Converter name to be displayed in messages                                                                      |
|convert                 |true    |Processes the conversion. Must receive input, content_type, output_path and output_filename as keyword arguments|
|default_output_type     |true    |Converter default output type                                                                                   |
|default_output_extension|true    |Converter default output extension                                                                              |

Example of a converter

```ruby
class HTMLToImageConverter
  ACCEPTED_INPUT_TYPES = ['text/html'].freeze
  ACCEPTED_OUTPUT_TYPES = %w[jpeg png].freeze

  def name
    'HTMLToImageConverter'
  end

  def default_output_type
    'jpeg'
  end

  def default_output_extension
    'jpg'
  end

  def convert(input:, content_type: nil, output_path: nil, output_filename: nil, output_extension: nil, output_type: nil)
    raise ConversionFactory::Errors::InvalidInputType unless ACCEPTED_INPUT_TYPES.include?(content_type.to_s)
    raise ConversionFactory::Errors::InvalidOutputType unless ACCEPTED_OUTPUT_TYPES.include?(output_type.to_s)

    kit = IMGKit.new(File.new(input))
    kit = kit.to_img(output_type.to_sym)
    kit.to_file("#{output_path}/#{output_filename}.#{output_extension || output_type}")
  end
end
```
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/filipedesousab/conversion_factory. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/filipedesousab/conversion_factory/blob/main/CODE_OF_CONDUCT.md).

# EdifactConverter

Converts a MedCom Edifact message to a MedCom XML message.
Details regarding MedCom definitions http://medcom.dk

## Installation

Add this line to your application's Gemfile:

    gem 'edifact_converter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install edifact_converter

## Usage

```
edifact_converter [options] file
    -x, --xml                        Convert from Edifact to XML
    -e, --edi                        Convert from XML to Edifact
    -l, --logfile FILE               Write log to FILE
    -h, --help                       Display this screen
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/edifact_converter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

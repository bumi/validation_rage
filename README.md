# ValidationRage

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'validation_rage'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install validation_rage

## Usage

ValidationRage::LogNotifier.new(:logger => Rails.logger, :log_level => :warn).subscribe!
ActiveRecord::Base.descendants.each {|m| m.send(:include, ValidationRage::ModelExtension) }

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

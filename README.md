# Opal: Shimmer

Shimmer is an application state and configuration management library built with [Opal](http://opalrb.org), a Ruby-to-JS compiler.

## Installation

Add this line to your application's Gemfile:

    gem 'opal-shimmer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install opal-shimmer

## Usage

Shimmer is very easy to use right out of the box. I'm assuming you'll be using it within the context of a Rails application for this tutorial. Make sure you add `//= require shimmer` to your application.js manifest file.

    # Set up the config object:
    config = Shimmer::Config.new
    
    # Set some values:
    config.somevalue = "Wow"
    config.othervalue = ['This', 'is', 'great!']
    
    # Get some values:
    puts config.somevalue  # > "Wow"
    
    # Use namespaces to define very specific values:
    config.several.levels.deep.stringvalue = "Your string here"
    puts config.several.levels.deep.stringvalue  # > "Your string here"
    
    # Check whether a value exists:
    puts config.foo.nil?
    
    # Set stuff in a namespace using a block:
    config.really.deep.namespace do |c|
      c.value1 = 1
      c.value2 = 2
    end
    
    # Persist values across sessions using localStorage:
    config.persist(:cease_and_persist)
    config.cease_and_persist = "abc123"
    
    config2 = Shimmer::Config.new  # this loads up a brand new object
    config2.persist(:cease_and_persist)
    
    puts config2.cease_and_persist  # > "abc123"  Aha! it works!
    
    # An easier way to persist values by setting initial defaults
    # and not overwriting values that get set differently later:
    config.persist_defaults do |c|
      c.somevalue = "abc"
      c.othervalue = 123
    end

    # ...user triggers some action...
    config.somevalue = "xyz"
    
    # ...days later on a subsquent browser session...
    puts config.somevalue  # > "xyz"  not "abc" - Yay!
    
For more examples, look at the `config_spec.rb` and `storage_spec.rb` files in the `spec` folder.

## Contributing

1. Fork it ( http://github.com/jaredcwhite/opal-shimmer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Testing

Simply run `rackup` at your command line when you're in the project folder. It will load a webserver at port 9292. Then just go to your browser and access `http://localhost:9292`. You should get the full rspec suite runner output. (And hopefully, everything's green!)

_If you have trouble using Safari, try using Chrome instead. I'm not sure why this is sometimes an issue..._
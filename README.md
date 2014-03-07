# Bluebird

Bluebird modifies your tweets, mostly to fit 140 characters.  
It uses "strategies". Every strategy makes its own modifications to the tweets.  
It does not ensure that tweet will fit 140 characters. (More strategies will be added to ensure it.)

## Installation

Add this line to your application's Gemfile:

````ruby
gem 'bluebird'
````

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bluebird
    
## Configuration

You do not need any configuration to start using bluebird but it is intended  for a quick start. <code>characters_reserved_per_media</code>, <code>short_url_length_https</code> and <code>short_url_length</code> can change any time, **it is your duty** to fetch these values from twitter API and change bluebird configuration. For more information visit [twitter docs](https://dev.twitter.com/docs/api/1.1/get/help/configuration).


These are the default values:

````ruby
Bluebird.configure do |config|
  config.strategies                    = [:strip, :squeeze, :truncate_text]
  config.max_length                    = 140
  config.characters_reserved_per_media = 23
  config.short_url_length_https        = 23
  config.short_url_length              = 22
  
  config.truncate_text.omission        = '...'
end
````

If you want to change defaults for Rails, create a file in <code>initializers</code> folder and copy the code above.  

By default bluebird runs three strategies in these order; <code>strip</code>, <code>squeeze</code> and <code>truncate_text</code>. For detailed information about each strategy, visit [Strategies](https://github.com/emrekutlu/bluebird/wiki/Strategies).

## Usage

````ruby
Bluebird.modify('The bluebirds are a group of medium-sized, mostly insectivorous or omnivorous birds in the genus Sialia of the thrush family (Turdidae). #bluebird #animals')
# => 'The bluebirds are a group of medium-sized, mostly insectivorous or omnivorous birds in the genus Sialia of the thrush ... #bluebird #animals'
````

If uploading media:

````ruby
Bluebird.modify('The bluebirds are a group of medium-sized, mostly insectivorous or omnivorous birds in the genus Sialia of the thrush family (Turdidae). #bluebird #animals', media: true)
# => 'The bluebirds are a group of medium-sized, mostly insectivorous or omnivorous birds in the genu... #bluebird #animals'
````

## License

Bluebird is released under the [MIT License](https://github.com/emrekutlu/bluebird/blob/master/LICENSE.txt).

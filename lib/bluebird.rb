require 'twitter-text'

require 'bluebird/version'
require 'bluebird/config'
require 'bluebird/tweet'
require 'bluebird/partial'
require 'bluebird/strategies/base'
require 'bluebird/strategies/strip'
require 'bluebird/strategies/squeeze'
require 'bluebird/strategies/truncate_text'
require 'bluebird/strategies/via'

module Bluebird
  class << self

    def configure
      yield(Config)
    end

    def modify(status, opts = {})
      tweet = Bluebird::Tweet.new(status, opts)
      run_strategies(tweet)
      tweet.status
    end

    private

    def run_strategies(tweet)
      Config.strategies.each do |strategy|
        strategy_by_symbol(strategy).run(tweet, Config)
      end
    end

    def symbol_to_class(symbol)
      symbol.to_s.split('_').map do |string|
        i = 0
        string.chars.map do |char|
          i += 1
          if i.eql?(1)
            char.upcase
          else
            char
          end
        end
      end.join
    end

    def strategy_by_symbol(symbol)
      strategies_module.const_get(symbol_to_class(symbol)).const_get('Strategy')
    end

    def strategies_module
      @strategies_module ||= Object.const_get('Bluebird').const_get('Strategies')
    end

  end
end

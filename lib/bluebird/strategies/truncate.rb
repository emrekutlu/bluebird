require 'bluebird/strategies/truncate/strategy'
require 'bluebird/strategies/truncate/config'

Bluebird::Config.register(:truncate, Bluebird::Strategies::Truncate::Config)

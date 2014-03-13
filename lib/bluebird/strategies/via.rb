require 'bluebird/strategies/via/strategy'
require 'bluebird/strategies/via/config'

Bluebird::Config.register(:via, Bluebird::Strategies::Via::Config)

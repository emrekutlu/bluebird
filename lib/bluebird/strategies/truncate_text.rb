require 'bluebird/strategies/truncate_text/strategy'
require 'bluebird/strategies/truncate_text/config'

Bluebird::Config.register(:truncate_text, Bluebird::Strategies::TruncateText::Config)

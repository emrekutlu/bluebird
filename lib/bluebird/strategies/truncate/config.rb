module Bluebird
  module Strategies
    module Truncate
      class Config

        @omission = '...'

        class << self
          attr_accessor :omission
        end

      end
    end
  end
end

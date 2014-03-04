module Bluebird
  module Strategies
    module TruncateText
      class Config

        @omission = '...'

        class << self
          attr_accessor :omission
        end

      end
    end
  end
end

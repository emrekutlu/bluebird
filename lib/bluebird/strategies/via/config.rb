module Bluebird
  module Strategies
    module Via
      class Config

        @prefix = 'via'

        class << self
          attr_accessor :prefix, :username
        end

      end
    end
  end
end

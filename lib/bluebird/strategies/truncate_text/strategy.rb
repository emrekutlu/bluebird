module Bluebird
  module Strategies
    module TruncateText
      class Strategy < Bluebird::Strategies::Base
        class << self

          def run(tweet, config)
            if run?(tweet, config.max_length)
              truncate(tweet, config.max_length)
            end
          end

          private

          def run?(tweet, max)
            tweet.length > max
          end

          def truncate(tweet, max)
            count = count_to_truncate(tweet, max)

            if needs_truncation?(count)
              if (suitable = suitable_partial(tweet, count))
                truncate_partial(suitable, count)
                add_omission(suitable)
              else
                truncate_partials(tweet, count)
              end
            end
          end

          def needs_truncation?(count)
            count > 0
          end

          def truncate_partials(tweet, count)
            truncatable_partials(tweet).each do |partial|
              count -= truncate_partial(partial, count)
              unless needs_truncation?(count)
                add_omission(partial)
                break
              end
            end
          end

          def truncate_partial(partial, count)
            truncated_count = 0

            if handle_truncation?(partial, count)

              partial.content = if keep_last_space?(partial)
                partial.content[0, partial.length - count - 1] + ' '
              else
                partial.content[0, partial.length - count]
              end

              truncated_count = count
            else
              if deletable?(partial)
                truncated_count = partial.length
                partial.content = ''
              else
                truncated_count = partial.length - 1
                partial.content = partial.reply_preventer? ? '.' : ' '
              end
            end

            truncated_count
          end

          def truncatable_partials(tweet)
            tweet.text_partials.reverse
          end

          def suitable_partial(tweet, count)
            truncatable_partials(tweet).each do |partial|
              return partial if handle_truncation?(partial, count)
            end
            nil
          end

          def count_to_truncate(tweet, max)
            tweet.length > max ? tweet.length - max : 0
          end

          def deletable?(partial)
            !partial.separator? && !partial.reply_preventer?
          end

          def handle_truncation?(partial, count)
            truncatable_length(partial) > count
          end

          def add_omission(partial)
            if add_omission?
              length = omission.char_length
              if handle_truncation?(partial, length)
                truncate_partial(partial, length)
                if ends_with_space?(partial)
                  delete_last_character(partial)
                  partial.content += omission + ' '
                else
                  partial.content += omission
                end
              end
            end
          end

          def add_omission?
            omission && omission.char_length > 0
          end

          def truncatable_length(partial)
            if partial.last?
              partial.length
            elsif partial.first?
              if partial.reply_preventer?
                partial.length - 1
              else
                partial.length
              end
            else
              partial.length - 1
            end
          end

          def ends_with_space?(partial)
            partial.content.to_char_a.last.eql?(' ')
          end

          def keep_last_space?(partial)
            ends_with_space?(partial) && partial.next_partial
          end

          def delete_last_character(partial)
            partial.content = partial.content[0, partial.content.length - 1]
          end

          def omission
            Bluebird::Strategies::TruncateText::Config.omission
          end

        end
      end
    end
  end
end

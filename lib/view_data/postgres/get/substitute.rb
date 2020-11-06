module ViewData
  module Postgres
    module Get
      class Substitute
        include Get

        attr_reader :query
        attr_accessor :message_class

        def initialize(query)
          @query = query
        end

        def batch_size
          @batch_size ||= 1
        end
        attr_writer :batch_size

        def items
          @items ||= []
        end

        def self.build(query:)
          instance = new(query)
          instance
        end

        def call(position, include: nil)
          position ||= 0

          logger.trace(tag: :get) { "Getting (Table Name: #{query.name.inspect}, Position: #{position}, Batch Size: #{batch_size})" }

          logger.debug(tag: :data) { "Items: \n#{items.pretty_inspect}" }
          logger.debug(tag: :data) { "Position: #{position.inspect}" }
          logger.debug(tag: :data) { "Batch Size: #{batch_size.inspect}" }

          index = items.index { |i| i.global_position > position }

          logger.debug(tag: :data) { "Index: #{index.inspect}" }

          if index.nil?
            items = []
          else
            range = index..(index + batch_size - 1)
            logger.debug(tag: :data) { "Range: #{range.pretty_inspect}" }

            items = self.items[range]
          end

          last_position = last_position(items)

          logger.info(tag: :data) { "Got: \n#{items.pretty_inspect}" }
          logger.trace(tag: :get) { "Finished getting (Table Name: #{query.name.inspect}, Position: #{position}, Batch Size: #{batch_size})" }

          if Array(include).include?(:last_position)
            return items, last_position
          end

          items
        end

        def last_position(batch)
          return nil if batch.last.nil?

          batch.last.global_position
        end
      end
    end
  end
end

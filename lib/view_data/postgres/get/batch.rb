module ViewData
  module Postgres
    module Get
      class Batch
        include Get

        attr_reader :query
        attr_accessor :message_class

        def initialize(query)
          @query = query
        end

        def batch_size
          @batch_size ||= Defaults.batch_size
        end
        attr_writer :batch_size

        def self.build(query:, message_class: nil, batch_size: nil, session: nil)
          instance = new(query)

          instance.message_class = message_class
          instance.batch_size = batch_size

          instance.configure(session: session)

          instance
        end

        def self.configure(receiver, attr_name: nil, query:, message_class: nil, batch_size: nil, session: nil)
          attr_name ||= :get

          instance = build(query: query, message_class: message_class, batch_size: batch_size, session: session)
          receiver.public_send "#{attr_name}=", instance
        end

        def self.call(query:, message_class: nil, position: nil, batch_size: nil, session: nil)
          instance = build(query: query, message_class: message_class, batch_size: batch_size, session: session)
          instance.(position)
        end

        def call(position=nil, include: nil)
          logger.trace(tag: :get) { "Getting message data (Table Name: #{query.name.inspect}, Position: #{position.inspect}, Batch Size: #{batch_size.inspect})" }

          position ||= Defaults.position

          result = get_result(position)

          message_data, last_position = convert(result)

          logger.info(tag: :get) { "Finished getting message data (Count: #{message_data.length}, Table Name: #{query.name.inspect}, Position: #{position.inspect}, Batch Size: #{batch_size.inspect})" }
          logger.info(tags: [:data, :message_data]) { message_data.pretty_inspect }

          if Array(include).include?(:last_position)
            return message_data, last_position
          end

          message_data
        end

        def get_result(position)
          logger.trace(tag: :get) { "Getting result (Table Name: #{query.name.inspect}, Position: #{position.inspect}, Batch Size: #{batch_size.inspect})" }
          logger.trace(tag: :get) { "SQL: #{query.statement}" }
          logger.trace(tag: :get) { query.parameters.pretty_inspect }

          sql_command = query.statement

          positional_parameters = [
            position,
            batch_size
          ]

          query_parameters = query.parameters || []

          params = positional_parameters + query_parameters

          result = session.execute(sql_command, params)

          logger.debug(tag: :get) { "Finished getting result (Count: #{result.ntuples}, Table Name: #{query.name.inspect}, Position: #{position.inspect}, Batch Size: #{batch_size.inspect})" }
          logger.debug(tag: :get) { "SQL: #{query.statement}" }
          logger.debug(tag: :get) { query.parameters.pretty_inspect }

          result
        end

        def convert(result)
          logger.trace(tag: :get) { "Converting result to message data (Result Count: #{result.ntuples})" }

          result_array = result.to_a

          if message_class.nil?
            message_data = result_array
          else
            message_data = result_array.map do |record|
              tuple = message_class.new
              SetAttributes.(tuple, record)
              tuple
            end
          end

          last_position = last_position(result_array)

          logger.debug(tag: :get) { "Converted result to message data (Message Data Count: #{message_data.length})" }

          return message_data, last_position
        end

        def last_position(batch)
          return nil if batch.last.nil?

          return nil unless batch.last.key?("global_position")

          batch.last["global_position"]
        end
      end
    end
  end
end

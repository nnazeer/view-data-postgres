module ViewData
  module Postgres
    module Get
      class One
        include Get

        def self.build(session: nil)
          instance = new

          instance.configure(session: session)

          instance
        end

        def self.configure(receiver, attr_name: nil, session: nil)
          attr_name ||= :get_one

          instance = build(session: session)
          receiver.public_send "#{attr_name}=", instance
        end

        def self.call(query:, message_class: nil, session: nil)
          instance = build(session: session)
          instance.(query, message_class: message_class)
        end

        def call(query, message_class: nil)
          logger.trace(tag: :get) { "Getting message data (Table Name: #{query.name.inspect})" }

          result = get_result(query)

          message_data = convert(result, message_class: message_class)

          logger.info(tag: :get) { "Finished getting message data (Count: #{message_data.length}, Table Name: #{query.name.inspect})" }
          logger.info(tags: [:data, :message_data]) { message_data.pretty_inspect }

          message_data.first
        end

        def get_result(query)
          logger.trace(tag: :get) { "Getting result (Table Name: #{query.name.inspect})" }
          logger.trace(tag: :get) { "SQL: #{query.statement}" }
          logger.trace(tag: :get) { query.parameters.pretty_inspect }

          sql_command = query.statement

          if query.parameters.nil?
            result = session.execute(sql_command)
          else
            params = query.parameters

            result = session.execute(sql_command, params)
          end

          logger.debug(tag: :get) { "Finished getting result (Count: #{result.ntuples}, Table Name: #{query.name.inspect})" }
          logger.debug(tag: :get) { "SQL: #{query.statement}" }
          logger.debug(tag: :get) { query.parameters.pretty_inspect }

          result
        end

        def convert(result, message_class: nil)
          logger.trace(tag: :get) { "Converting result to message data (Result Count: #{result.ntuples})" }

          if message_class.nil?
            message_data = result.to_a
          else
            message_data = result.map do |record|
              tuple = message_class.new
              SetAttributes.(tuple, record)
              tuple
            end
          end

          logger.debug(tag: :get) { "Converted result to message data (Message Data Count: #{message_data.length})" }

          return message_data
        end
      end
    end
  end
end

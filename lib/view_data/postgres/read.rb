module ViewData
  module Postgres
    class Read
      Error = Class.new(RuntimeError)

      include Dependency
      include Log::Dependency

      dependency :iterator, Iterator

      attr_reader :query
      attr_reader :position
      attr_reader :batch_size

      def initialize(query, position, batch_size)
        @query = query
        @position = position
        @batch_size = batch_size
      end

      def self.build(query:, position: nil, batch_size: nil, session: nil, **arguments)
        instance = new(query, position, batch_size)
        instance.configure(session: session, **arguments)
        instance
      end

      def self.configure(receiver, attr_name: nil, query:, position: nil, batch_size: nil, session: nil, **arguments)
        attr_name ||= :read
        instance = build(query: query, position: position, batch_size: batch_size, session: session, **arguments)
        receiver.public_send "#{attr_name}=", instance
      end

      def configure(session: nil, message_class: nil)
        Iterator.configure(self, position)
        Get::Batch.configure(iterator, query: query, message_class: message_class, batch_size: batch_size, session: session)
      end

      def self.call(query:, position: nil, batch_size: nil, session: nil, **arguments, &action)
        instance = build(query: query, position: position, batch_size: batch_size, session: session, **arguments)
        instance.(&action)
      end

      def call(&action)
        logger.trace(tag: :read) { "Reading (Table Name: #{query.name.inspect})" }

        if action.nil?
          error_message = 'Reader must be actuated with a block'
          logger.error(tag: :read) { error_message }
          raise Error, error_message
        end

        enumerate_message_data(&action)

        logger.info(tag: :read) { "Reading completed (Table Name: #{query.name.inspect})" }

        return AsyncInvocation::Incorrect
      end

      def enumerate_message_data(&action)
        logger.trace(tag: :read) { "Enumerating (Table Name: #{query.name.inspect})" }

        message_data = nil

        loop do
          message_data = iterator.next

          break if message_data.nil?

          action.(message_data)
        end

        logger.debug(tag: :read) { "Enumerated (Table Name: #{query.name.inspect})" }
      end
    end
  end
end

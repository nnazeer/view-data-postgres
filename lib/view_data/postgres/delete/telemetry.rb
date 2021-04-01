module ViewData
  module Postgres
    class Delete
      module Telemetry
        class Sink
          include ::Telemetry::Sink

          record :deleted
        end

        def self.sink
          Sink.new
        end
      end

      def self.register_telemetry_sink(receiver)
        sink = Telemetry.sink
        receiver.telemetry.register(sink)
        sink
      end
    end
  end
end

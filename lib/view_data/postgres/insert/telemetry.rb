module ViewData
  module Postgres
    class Insert
      module Telemetry
        class Sink
          include ::Telemetry::Sink

          record :inserted
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

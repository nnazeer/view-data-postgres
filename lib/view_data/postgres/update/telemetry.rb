module ViewData
  module Postgres
    class Update
      module Telemetry
        class Sink
          include ::Telemetry::Sink

          record :updated
        end

        def self.sink
          Sink.new
        end

        Data = Struct.new(:name, :identifier, :data)
      end

      def self.register_telemetry_sink(receiver)
        sink = Telemetry.sink
        receiver.telemetry.register(sink)
        sink
      end
    end
  end
end

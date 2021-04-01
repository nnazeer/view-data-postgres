module ViewData
  module Postgres
    class Update
      module Substitute
        def self.build
          instance = Update.build
          sink = Update.register_telemetry_sink(instance)
          instance.sink = sink
          instance
        end

        class Update < ::ViewData::Postgres::Update
          attr_accessor :sink

          def self.build
            instance = new
            instance.configure
            instance
          end

          def configure
            ::Telemetry.configure(self)
          end

          def updated?(&blk)
            updated = sink.recorded_once? do |record|
              record.signal == :updated
            end

            if !updated
              return false
            end

            if blk.nil?
              return true
            end

            sink.recorded_once? do |record|
              blk.call(record.data.name, record.data.identifier, record.data.data)
            end
          end
        end
      end
    end
  end
end

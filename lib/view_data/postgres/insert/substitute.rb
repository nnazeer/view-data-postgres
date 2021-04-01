module ViewData
  module Postgres
    class Insert
      module Substitute
        def self.build
          instance = Insert.build
          sink = Insert.register_telemetry_sink(instance)
          instance.sink = sink
          instance
        end

        class Insert < ::ViewData::Postgres::Insert
          attr_accessor :sink

          def self.build
            instance = new
            instance.configure
            instance
          end

          def configure
            ::Telemetry.configure(self)
          end

          def inserted?(&blk)
            inserted = sink.recorded_once? do |record|
              record.signal == :inserted
            end

            if !inserted
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

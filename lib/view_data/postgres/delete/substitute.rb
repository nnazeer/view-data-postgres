module ViewData
  module Postgres
    class Delete
      module Substitute
        def self.build
          instance = Delete.build
          sink = Delete.register_telemetry_sink(instance)
          instance.sink = sink
          instance
        end

        class Delete < ::ViewData::Postgres::Delete
          attr_accessor :sink

          def self.build
            instance = new
            instance.configure
            instance
          end

          def configure
            ::Telemetry.configure(self)
          end
        end
      end
    end
  end
end

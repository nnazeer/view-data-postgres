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
        end
      end
    end
  end
end

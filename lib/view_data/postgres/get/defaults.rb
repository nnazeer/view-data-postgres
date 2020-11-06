module ViewData
  module Postgres
    module Get
      module Defaults
        def self.position
          0
        end

        def self.batch_size
          1000
        end
      end
    end
  end
end

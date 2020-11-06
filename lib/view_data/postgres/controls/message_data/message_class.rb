module ViewData
  module Postgres
    module Controls
      module MessageData
        module MessageClass
          def self.example
            SomeClass
          end

          class SomeClass
            include ::Schema::DataStructure

            attribute :id, String
            attribute :some_column, String
            attribute :global_position, Integer
          end
        end
      end
    end
  end
end

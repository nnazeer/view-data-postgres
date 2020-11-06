module ViewData
  module Postgres
    module Controls
      module MessageClass
        def self.example
          SomeClass
        end

        class SomeClass
          include ::Schema::DataStructure

          attribute :id, String
          attribute :some_column, String
        end
      end
    end
  end
end

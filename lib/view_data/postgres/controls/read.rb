module ViewData
  module Postgres
    module Controls
      module Read
        def self.example(query: nil)
          query ||= Query::Position.example

          read = ViewData::Postgres::Read.build(query: query)

          get = Get.example(query: query)
          read.iterator.get = get

          read
        end
      end
    end
  end
end

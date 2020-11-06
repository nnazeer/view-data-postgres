module ViewData
  module Postgres
    module Controls
      module Get
        def self.example(query: nil, batch_size: nil, count: nil)
          query ||= Query.example
          batch_size ||= 1
          count ||= 1

          get = ViewData::Postgres::Get::Substitute.build(query: query)
          get.batch_size = batch_size

          elements = (1..count).to_a

          elements.each do |e|
            message_data = MessageData::Read.example
            message_data.global_position = e

            get.items << message_data
          end

          get
        end
      end
    end
  end
end

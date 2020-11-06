require_relative '../../automated_init'

context "Iterator" do
  context "Query" do
    context "Next" do
      column_value = SecureRandom.hex(7)

      Controls::Row::Put.(column_value: column_value, instances: 2)

      query = Controls::Query::Position::SomeColumn.example(column_value: column_value)

      iterator = ViewData::Postgres::Read::Iterator.build
      ViewData::Postgres::Get::Batch.configure(iterator, query: query, batch_size: 1)

      batch = []

      2.times do
        message_data = iterator.next
        batch << message_data unless message_data.nil?
      end

      test "Gets each message" do
        assert(batch.length == 2)
      end
    end
  end
end

require_relative '../automated_init'

context "Read" do
  column_value = SecureRandom.hex(7)

  Controls::Row::Put.(column_value: column_value, instances: 2)

  query = Controls::Query::Position::SomeColumn.example(column_value: column_value)

  batch = []

  ViewData::Postgres::Read.(query: query, batch_size: 1) do |message_data|
    batch << message_data
  end

  test "Reads batches of messages" do
    assert(batch.length == 2)
  end
end

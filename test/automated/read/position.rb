require_relative '../automated_init'

context "Read" do
  context "Position" do
    table = Controls::Table.name

    column_value = SecureRandom.hex(7)

    position = Controls::Row::Get::MaxPosition.(table: table)

    Controls::Row::Put.(column_value: column_value, instances: 2)

    query = Controls::Query::Position::SomeColumn.example(column_value: column_value)

    batch = []

    ViewData::Postgres::Read.(query: query, position: position + 1, batch_size: 1) do |message_data|
      batch << message_data
    end

    test "Reads from the starting position" do
      assert(batch.length == 1)
    end
  end
end

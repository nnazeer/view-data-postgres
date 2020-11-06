require_relative '../../../automated_init'

context "Get" do
  context "Batch" do
    context "Position" do
      context "Parameters" do
        context "No Messages" do
          table = Controls::Table.name

          column_value = SecureRandom.hex(7)

          id = Controls::Row::Put.(table: table, column_value: column_value)

          position = Controls::Row::Get::MaxPosition.(table: table)

          query = Controls::Query::Position::Parameters.example(id: id)

          batch = ViewData::Postgres::Get::Batch.(query: query, position: position)

          test "Empty array" do
            assert(batch == [])
          end
        end
      end
    end
  end
end

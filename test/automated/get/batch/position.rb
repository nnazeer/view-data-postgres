require_relative '../../automated_init'

context "Get" do
  context "Batch" do
    context "Position" do
      table = Controls::Table.name

      position = Controls::Row::Get::MaxPosition.(table: table)

      Controls::Row::Put.(table: table, instances: 3)

      query = Controls::Query::Position.example

      batch = ViewData::Postgres::Get::Batch.(query: query, position: position)

      test "Gets from the starting position" do
        assert(batch.length == 3)
      end
    end
  end
end

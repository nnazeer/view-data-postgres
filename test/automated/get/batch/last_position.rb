require_relative '../../automated_init'

context "Get" do
  context "Batch" do
    context "Last Position" do
      table = Controls::Table.name

      position = Controls::Row::Get::MaxPosition.(table: table)

      Controls::Row::Put.(table: table)

      query = Controls::Query::Position.example

      get_batch = ViewData::Postgres::Get::Batch.build(query: query)

      *, last_position = get_batch.(position, include: :last_position)

      test "Gets last position" do
        assert(last_position == position + 1)
      end
    end
  end
end

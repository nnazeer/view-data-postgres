require_relative '../../automated_init'

context "Get" do
  context "Batch" do
    context "Batch Size" do
      table = Controls::Table.name

      Controls::Table::Truncate.()

      Controls::Row::Put.(table: table, instances: 3)

      query = Controls::Query::Position.example

      messages = ViewData::Postgres::Get::Batch.(query: query, batch_size: 2)

      number_of_messages = messages.length

      test "Number of messages retrieved is the specified batch size" do
        assert(number_of_messages == 2)
      end
    end
  end
end

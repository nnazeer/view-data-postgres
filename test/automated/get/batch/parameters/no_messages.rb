require_relative '../../../automated_init'

context "Get" do
  context "Batch" do
    context "Position" do
      context "Parameters" do
        context "No Messages" do
          table = Controls::Table.name

          id = Controls::ID::Random.example

          query = Controls::Query::Position::Parameters.example(id: id)

          batch = ViewData::Postgres::Get::Batch.(query: query)

          test "Empty array" do
            assert(batch == [])
          end
        end
      end
    end
  end
end

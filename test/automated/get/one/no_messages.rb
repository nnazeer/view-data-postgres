require_relative '../../automated_init'

context "Get" do
  context "One" do
    context "No Messages" do
      query = Controls::Query::Empty.example

      batch = ViewData::Postgres::Get::One.(query: query)

      test "Is nil" do
        assert(batch.nil?)
      end
    end
  end
end

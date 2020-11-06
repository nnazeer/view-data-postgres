require_relative '../automated_init'

context "Insert" do
  context "Ignored" do
    id = Controls::Row::Put.()

    command = Controls::Commands::Create.example(
      :primary_key => {
        :id => id
      }
    )

    insert = ViewData::Postgres::Insert.build

    test "Unique Violation is not raised" do
      refute_raises(ViewData::Postgres::Insert::UniqueViolation) do
        insert.(command)
      end
    end
  end
end

require_relative '../automated_init'

context "Insert" do
  context "Strict" do
    id = Controls::Row::Put.()

    command = Controls::Commands::Create.example(
      :primary_key => {
        :id => id
      }
    )

    insert = ViewData::Postgres::Insert.build

    test "Unique Violation is raised" do
      assert_raises(ViewData::Postgres::Insert::UniqueViolation) do
        insert.(command, strict: true)
      end
    end
  end
end

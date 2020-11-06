require_relative '../../automated_init'

context "Update" do
  context "Optimistic Lock" do
    context "Expected Version" do
      table = Controls::Table::OptimisticLock.name

      id = Controls::Row::Put.(table: table)

      prior_row = Controls::Row::Get.(id, table: table)
      version = prior_row["lock_version"]
      wrong_version = version + 1

      command = Controls::Commands::Update.example(
        :primary_key => {
          :id => id,
          :lock_version => wrong_version
        },
        :table => table
      )

      update = ViewData::Postgres::Update.build

      test "Expected Version is raised" do
        assert_raises(ViewData::Postgres::ExpectedVersion::Error) do
          update.(command)
        end
      end
    end
  end
end

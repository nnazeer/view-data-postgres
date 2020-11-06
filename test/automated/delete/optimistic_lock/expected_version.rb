require_relative '../../automated_init'

context "Delete" do
  context "Optimistic Lock" do
    context "Ignored" do
      table = Controls::Table::OptimisticLock.name

      id = Controls::Row::Put.(table: table)

      prior_row = Controls::Row::Get.(id, table: table)
      version = prior_row["lock_version"]
      wrong_version = version + 1

      command = Controls::Commands::Delete.example(
        :primary_key => {
          :id => id,
          :lock_version => wrong_version
        },
        :table => table
      )

      delete = ViewData::Postgres::Delete.build

      test "Expected Version is raised" do
        assert_raises(ViewData::Postgres::ExpectedVersion::Error) do
          delete.(command)
        end
      end
    end
  end
end

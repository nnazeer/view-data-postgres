require_relative '../../automated_init'

context "Delete" do
  context "Optimistic Lock" do
    context "Deleted" do
      table = Controls::Table::OptimisticLock.name

      id = Controls::Row::Put.(table: table)

      prior_row = Controls::Row::Get.(id, table: table)
      version = prior_row["lock_version"]

      command = Controls::Commands::Delete.example(
        :primary_key => {
          :id => id,
          :lock_version => version
        },
        :table => table
      )

      delete = ViewData::Postgres::Delete.build
      delete.(command)

      row = Controls::Row::Get.(id, table: table)

      test "Row is deleted" do
        assert(row.nil?)
      end
    end
  end
end

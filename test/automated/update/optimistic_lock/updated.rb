require_relative '../../automated_init'

context "Update" do
  context "Optimistic Lock" do
    context "Updated" do
      table = Controls::Table::OptimisticLock.name

      id = Controls::Row::Put.(table: table)

      prior_row = Controls::Row::Get.(id, table: table)
      version = prior_row["lock_version"]
      next_version = version + 1

      value = SecureRandom.hex(7)

      command = Controls::Commands::Update.example(
        :primary_key => {
          :id => id,
          :lock_version => version
        },
        :column_value => value,
        :version => next_version,
        :table => table
      )

      update = ViewData::Postgres::Update.build
      update.(command)

      row = Controls::Row::Get.(id, table: table)

      test "Row is present" do
        refute(row.nil?)
      end

      context "Columns" do
        test "id" do
          assert(row["id"] == id)
        end

        test "some_column" do
          assert(row["some_column"] == value)
        end

        test "lock_version" do
          assert(row["lock_version"] == next_version)
        end
      end
    end
  end
end

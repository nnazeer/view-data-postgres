require_relative '../automated_init'

context "Delete" do
  context "Ignored" do
    id = Controls::PrimaryKey::UUID.example

    command = Controls::Commands::Delete.example(
      :primary_key => {
        :id => id
      }
    )

    delete = ViewData::Postgres::Delete.build
    delete.(command)

    row = Controls::Row::Get.(id)

    test "Row remains absent" do
      assert(row.nil?)
    end
  end
end

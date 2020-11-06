require_relative '../automated_init'

context "Delete" do
  context "Deleted" do
    id = Controls::Row::Put.()

    command = Controls::Commands::Delete.example(
      :primary_key => {
        :id => id
      }
    )

    delete = ViewData::Postgres::Delete.build
    delete.(command)

    row = Controls::Row::Get.(id)

    test "Row is deleted" do
      assert(row.nil?)
    end
  end
end

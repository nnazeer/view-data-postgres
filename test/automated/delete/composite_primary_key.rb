require_relative '../automated_init'

context "Delete" do
  context "Composite Primary Key" do
    id_1, id_2 = Controls::Row::Put::CompositePrimaryKey.()

    command = Controls::Commands::Delete.example(
      :table => Controls::Table::CompositePrimaryKey.name,
      :primary_key => {
        :id_1 => id_1,
        :id_2 => id_2
      }
    )

    delete = ViewData::Postgres::Delete.build
    delete.(command)

    row = Controls::Row::Get::CompositePrimaryKey.([id_1, id_2])

    test "Row is deleted" do
      assert(row.nil?)
    end
  end
end

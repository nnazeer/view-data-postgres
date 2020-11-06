require_relative '../automated_init'

context "Update" do
  context "Ignored" do
    id = Controls::PrimaryKey::UUID.example

    command = Controls::Commands::Update.example(
      :primary_key => {
        :id => id
      }
    )

    update = ViewData::Postgres::Update.build
    update.(command)

    row = Controls::Row::Get.(id)

    test "Row is not updated" do
      assert(row.nil?)
    end
  end
end

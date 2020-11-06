require_relative '../automated_init'

context "Update" do
  context "Updated" do
    id = Controls::Row::Put.()

    value = SecureRandom.hex(7)

    command = Controls::Commands::Update.example(
      :primary_key => {
        :id => id
      },
      :column_value => value
    )

    update = ViewData::Postgres::Update.build
    update.(command)

    row = Controls::Row::Get.(id)

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
    end
  end
end

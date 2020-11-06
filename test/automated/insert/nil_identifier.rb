require_relative '../automated_init'

context "Insert" do
  context "Nil Identifier" do
    value = SecureRandom.hex(7)

    command = Controls::Commands::Create::NilKey.example(
      column_value: value
    )

    insert = ViewData::Postgres::Insert.build
    insert.(command)

    row = Controls::Row::Get::NilKey.(value)

    test "Row is inserted" do
      refute(row.nil?)
    end

    context "Columns" do
      test "some_column" do
        assert(row["some_column"] == value)
      end
    end
  end
end

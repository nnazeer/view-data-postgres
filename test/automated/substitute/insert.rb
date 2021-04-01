require_relative '../automated_init'

context "Substitute" do
  context "Insert" do
    id = Controls::PrimaryKey::UUID.example

    value = SecureRandom.hex(7)

    command = Controls::Commands::Create.example(
      :primary_key => {
        :id => id
      },
      :column_value => value
    )

    insert = ViewData::Postgres::Insert::Substitute.build

    insert.(command)

    test "Matches name" do
      inserted = insert.inserted? do |name|
        name == command.name
      end

      assert(inserted)
    end

    test "Matches identifier" do
      inserted = insert.inserted? do |name, identifier|
        identifier == command.identifier
      end

      assert(inserted)
    end

    test "Matches data" do
      inserted = insert.inserted? do |name, identifier, data|
        data == command.data
      end

      assert(inserted)
    end
  end
end

require_relative '../automated_init'

context "Substitute" do
  context "Update" do
    id = Controls::Row::Put.()

    value = SecureRandom.hex(7)

    command = Controls::Commands::Update.example(
      :primary_key => {
        :id => id
      },
      :column_value => value
    )

    update = ViewData::Postgres::Update::Substitute.build

    update.(command)

    test "Matches name" do
      updated = update.updated? do |name|
        name == command.name
      end

      assert(updated)
    end

    test "Matches identifier" do
      updated = update.updated? do |name, identifier|
        identifier == command.identifier
      end

      assert(updated)
    end

    test "Matches data" do
      updated = update.updated? do |name, identifier, data|
        data == command.data
      end

      assert(updated)
    end
  end
end

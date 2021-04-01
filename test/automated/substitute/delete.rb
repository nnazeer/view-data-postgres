require_relative '../automated_init'

context "Substitute" do
  context "Delete" do
    id = Controls::Row::Put.()

    command = Controls::Commands::Delete.example(
      :primary_key => {
        :id => id
      }
    )

    delete = ViewData::Postgres::Delete::Substitute.build

    delete.(command)

    test "Matches name" do
      deleted = delete.deleted? do |name|
        name == command.name
      end

      assert(deleted)
    end

    test "Matches identifier" do
      deleted = delete.deleted? do |name, identifier|
        identifier == command.identifier
      end

      assert(deleted)
    end
  end
end

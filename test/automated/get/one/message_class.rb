require_relative '../../automated_init'

context "Get" do
  context "One" do
    context "Message Class" do
      table = Controls::Table.name

      column_value = SecureRandom.hex(7)

      id = Controls::Row::Put.(table: table, column_value: column_value)

      query = Controls::Query::Parameters.example(id: id)

      message_class = Controls::MessageClass.example

      message = ViewData::Postgres::Get::One.(query: query, message_class: message_class)

      context "Got the message that was written" do
        test "ID" do
          assert(message.id == id)
        end

        test "Some Column" do
          assert(message.some_column == column_value)
        end
      end
    end
  end
end

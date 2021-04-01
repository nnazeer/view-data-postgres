require_relative '../automated_init'

context "Telemetry" do
  context "Insert" do
    id = Controls::PrimaryKey::UUID.example

    value = SecureRandom.hex(7)

    command = Controls::Commands::Create.example(
      :primary_key => {
        :id => id
      },
      :column_value => value
    )

    insert = ViewData::Postgres::Insert.build

    sink = ViewData::Postgres::Insert.register_telemetry_sink(insert)

    insert.(command)

    test 'Records inserted signal' do
      recorded = sink.recorded_once? do |record|
        record.signal == :inserted
      end

      assert(recorded)
    end
  end
end

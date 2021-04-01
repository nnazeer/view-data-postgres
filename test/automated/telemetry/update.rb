require_relative '../automated_init'

context "Telemetry" do
  context "Update" do
    id = Controls::Row::Put.()

    value = SecureRandom.hex(7)

    command = Controls::Commands::Update.example(
      :primary_key => {
        :id => id
      },
      :column_value => value
    )

    update = ViewData::Postgres::Update.build

    sink = ViewData::Postgres::Update.register_telemetry_sink(update)

    update.(command)

    test 'Records updated signal' do
      recorded = sink.recorded_once? do |record|
        record.signal == :updated
      end

      assert(recorded)
    end
  end
end

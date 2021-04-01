require_relative '../automated_init'

context "Telemetry" do
  context "Delete" do
    id = Controls::Row::Put.()

    command = Controls::Commands::Delete.example(
      :primary_key => {
        :id => id
      }
    )

    delete = ViewData::Postgres::Delete.build

    sink = ViewData::Postgres::Delete.register_telemetry_sink(delete)

    delete.(command)

    test 'Records deleted signal' do
      recorded = sink.recorded_once? do |record|
        record.signal == :deleted
      end

      assert(recorded)
    end
  end
end

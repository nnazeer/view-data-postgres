require_relative '../../automated_init'

context "Iterator" do
  context "Query" do
    context "No Further Message Data" do
      column_value = SecureRandom.hex(7)

      Controls::Row::Put.(column_value: column_value, instances: 2)

      query = Controls::Query::Position::SomeColumn.example(column_value: column_value)

      iterator = ViewData::Postgres::Read::Iterator.build
      ViewData::Postgres::Get::Batch.configure(iterator, query: query, batch_size: 1)

      2.times { iterator.next }

      last = iterator.next

      test "Results in nil" do
        assert(last.nil?)
      end
    end
  end
end

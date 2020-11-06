require_relative '../../../automated_init'

context "Iterator" do
  context "Query Depletion" do
    context "Not Depleted" do
      context "Resulting Batch Size is Equal to the Requested Batch Size" do
        get = Controls::Get.example(batch_size: 2)

        iterator = ViewData::Postgres::Read::Iterator.build
        iterator.get = get

        iterator.batch = [1, 11]

        query_depleted = iterator.query_depleted?

        test "Query is not depleted" do
          refute(query_depleted)
        end
      end
    end
  end
end

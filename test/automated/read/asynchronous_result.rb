require_relative '../automated_init'

context "Read" do
  context "Asynchronous Result" do
    reader = Controls::Read.example

    response = reader.() {}

    test "Returns a result that fails if actuated" do
      assert(response == AsyncInvocation::Incorrect)
    end
  end
end

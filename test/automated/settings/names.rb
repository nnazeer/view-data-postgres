require_relative '../automated_init'

context "Settings" do
  context "Names" do
    settings = ViewData::Postgres::Settings.build

    settings_hash = settings.get.to_h

    names = ViewData::Postgres::Settings.names

    names.each do |name|
      test "#{name}" do
        assert(settings_hash.has_key?(name.to_s))
      end
    end
  end
end

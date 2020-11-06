require_relative '../automated_init'

context "Session" do
  context "Settings" do
    session = ViewData::Postgres::Session.build

    settings = ViewData::Postgres::Settings.build
    settings_hash = settings.get.to_h

    names = ViewData::Postgres::Settings.names

    names.each do |name|
      test "#{name}" do
        session_val = session.public_send(name)
        settings_val = settings_hash[name.to_s]

        assert(session_val == settings_val)
      end
    end
  end
end

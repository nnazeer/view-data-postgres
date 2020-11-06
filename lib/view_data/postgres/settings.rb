module ViewData
  module Postgres
    class Settings < ::Settings
      def self.instance
        @instance ||= build
      end

      def self.data_source
        Defaults.data_source
      end

      def self.names
        [
          :dbname,
          :host,
          :hostaddr,
          :port,
          :user,
          :password,
          :connect_timeout,
          :options,
          :sslmode,
          :krbsrvname,
          :gsslib,
          :service
        ]
      end

      class Defaults
        def self.data_source
          ENV['VIEW_DATA_PG_SETTINGS_PATH'] || 'settings/view_data_pg.json'
        end
      end
    end
  end
end

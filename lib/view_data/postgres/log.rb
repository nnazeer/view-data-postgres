module ViewData
  module Postgres
    class Log < ::Log
      def tag!(tags)
        tags << :view_data_pg
        tags << :view_data
      end
    end
  end
end

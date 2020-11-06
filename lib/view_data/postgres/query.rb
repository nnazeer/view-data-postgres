module ViewData
  module Postgres
    class Query
      include Schema

      attribute :name, String
      attribute :statement, String
      attribute :parameters
    end
  end
end

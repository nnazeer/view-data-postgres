module ViewData
  module Postgres
    module Controls
      module ID
        Incrementing = Identifier::UUID::Controls::Incrementing
        Random = Identifier::UUID::Controls::Random
      end
    end
  end
end

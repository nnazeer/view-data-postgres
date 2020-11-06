module ViewData
  module Postgres
    module Get
      def self.included(klass)
        klass.class_exec do
          include Dependency
          include Virtual
          include Log::Dependency

          dependency :session, Session

          abstract :call

          include Configure
        end
      end

      module Configure
        def configure(session: nil)
          Session.configure(self, session: session)
        end
      end
    end
  end
end

module ViewData
  module Postgres
    module Controls
      module Data
        def self.example(column_value: nil, version: nil)
          column_value ||= self.column_value

          data = {
            :some_column => column_value
          }

          if !version.nil?
            data[:lock_version] = version
          end

          data
        end

        def self.column_value
          "some-column-value"
        end
      end
    end
  end
end

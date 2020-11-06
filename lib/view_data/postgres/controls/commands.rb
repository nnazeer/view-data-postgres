module ViewData
  module Postgres
    module Controls
      module Commands
        module Create
          def self.example(primary_key: nil, column_value: nil, table: nil)
            primary_key ||= { id: PrimaryKey::UUID.example }
            table ||= Table.name
            data = Data.example(column_value: column_value)

            ViewData::Commands::Controls::Create.example(
              :name => table,
              :identifier => primary_key,
              :data => data
            )
          end

          module Password
            def self.example(primary_key: nil)
              primary_key ||= { id: PrimaryKey::UUID.example }
              table ||= Table::Password.name
              data = {
                :password_test => "test_pass"
              }

              ViewData::Commands::Controls::Create.example(
                :name => table,
                :identifier => primary_key,
                :data => data
              )
            end
          end

          module NilKey
            def self.example(column_value: nil)
              table = Table::NilKey.name
              data = {
                :some_column => column_value
              }

              command = ViewData::Commands::Controls::Create.example(
                :name => table,
                :data => data
              )

              command.identifier = nil

              command
            end
          end
        end

        module Update
          def self.example(primary_key: nil, column_value: nil, version: nil, table: nil)
            primary_key ||= { id: PrimaryKey::UUID.example }
            table ||= Table.name
            data = Data.example(column_value: column_value, version: version)

            ViewData::Commands::Controls::Update.example(
              :name => table,
              :identifier => primary_key,
              :data => data
            )
          end

          module Password
            def self.example(primary_key: nil)
              primary_key ||= { id: PrimaryKey::UUID.example }
              table ||= Table::Password.name
              data = {
                :password_test => "test_pass"
              }

              ViewData::Commands::Controls::Create.example(
                :name => table,
                :identifier => primary_key,
                :data => data
              )
            end
          end
        end

        module Delete
          def self.example(primary_key: nil, table: nil)
            primary_key ||= { id: PrimaryKey::UUID.example }
            table ||= Table.name

            ViewData::Commands::Controls::Delete.example(
              :name => table,
              :identifier => primary_key
            )
          end

          module Password
            def self.example(primary_key: nil)
              primary_key ||= { id: PrimaryKey::UUID.example }
              table ||= Table::Password.name

              ViewData::Commands::Controls::Delete.example(
                :name => table,
                :identifier => primary_key
              )
            end
          end
        end
      end
    end
  end
end

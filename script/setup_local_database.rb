require_relative '../init'

require 'view_data/postgres/controls'

ViewData::Postgres::Controls::Table.create(drop: true)
ViewData::Postgres::Controls::Table::AllDataTypes.create(drop: true)
ViewData::Postgres::Controls::Table::CompositePrimaryKey.create(drop: true)
ViewData::Postgres::Controls::Table::OptimisticLock.create(drop: true)
ViewData::Postgres::Controls::Table::Password.create(drop: true)
ViewData::Postgres::Controls::Table::Empty.create(drop: true)
ViewData::Postgres::Controls::Table::NilKey.create(drop: true)

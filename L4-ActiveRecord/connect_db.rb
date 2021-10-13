require "active_record"

def connect_db!
  ActiveRecord::Base.establish_connection(
    host: "chunee.db.elephantsql.com",
    adapter: "postgresql",
    database: "rngbyepy",
    user: "rngbyepy",
    password: "zJV8pcU42kffMTvR3SlCiWDLdptwCtSP",
  )
end

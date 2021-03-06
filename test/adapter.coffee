_g = require './support/common'

_dbs = [ 'mysql', 'mongodb', 'postgresql', 'sqlite3' ]

_dbs.forEach (db) ->
  return if not _g.db_configs[db]
  describe 'adapter-' + db, ->
    before (done) ->
      _g.connection = new _g.Connection db, _g.db_configs[db]

      _g.connection.dropAllModels done
      return

    afterEach (done) ->
      _g.connection.dropAllModels done
      return

    after ->
      _g.connection.close()
      _g.connection = null

    require('./cases/adapter-'+db)()

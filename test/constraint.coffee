_g = require './support/common'

_dbs = [ 'mysql', 'mongodb', 'sqlite3', 'sqlite3_memory', 'postgresql' ]

_dbs.forEach (db) ->
  return if not _g.db_configs[db]
  describe 'constraint-' + db, ->
    describe '#basic', ->
      before (done) ->
        _g.connection = new _g.Connection db, _g.db_configs[db]

        if _g.use_coffeescript_class
          class User extends _g.Model
            @column 'name', { type: String, required: true }
            @column 'age', { type: Number, required: true }
            @column 'email', { type: String, unique: true, required: true }
            @column 'facebook_id', { type: String, unique: true }

          class Post extends _g.Model
            @column 'title', String
            @column 'body', String
            @belongsTo 'user', required: true
        else
          User = _g.connection.model 'User',
            name: { type: String, required: true }
            age: { type: Number, required: true }
            email: { type: String, unique: true, required: true }
            facebook_id: { type: String, unique: true }

          Post = _g.connection.model 'Post',
            title: String
            body: String
          Post.belongsTo User, required: true

        _g.connection.dropAllModels done
        return

      beforeEach (done) ->
        _g.deleteAllRecords [_g.connection.User, _g.connection.Post], done
        return

      after (done) ->
        _g.connection.dropAllModels ->
          _g.connection.close()
          _g.connection = null
          done null
        return

      require('./cases/constraint')()

    describe '#multicolumn', ->
      before (done) ->
        _g.connection = new _g.Connection db, _g.db_configs[db]

        if _g.use_coffeescript_class
          class Version extends _g.Model
            @column 'major', 'number'
            @column 'minor', 'number'
            @index { major: 1, minor: 1 }, { unique: true }
        else
          Version = _g.connection.model 'Version',
            major: Number
            minor: Number
          Version.index { major: 1, minor: 1 }, { unique: true }

        _g.connection.dropAllModels done
        return

      beforeEach (done) ->
        _g.deleteAllRecords [_g.connection.Version], done
        return

      after (done) ->
        _g.connection.dropAllModels ->
          _g.connection.close()
          _g.connection = null
          done null
        return

      require('./cases/constraint_multicolumn')()

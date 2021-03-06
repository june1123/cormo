_g = require '../support/common'
{expect} = require 'chai'

module.exports = () ->
  describe 'issues', ->
    it 'reserved words', (done) ->
      class Reference extends _g.Model
        @index group: 1
        @column 'group', 'integer'
      data = [
        { group: 1 }
        { group: 1 }
        { group: 2 }
        { group: 3 }
      ]
      _g.connection.Reference.createBulk data, (error, records) ->
        return done error if error
        _g.connection.Reference.find(records[0].id).select('group').exec (error, record) ->
          return done error if error
          expect(record.id).to.eql records[0].id
          expect(record.group).to.eql records[0].group
          _g.connection.Reference.count group: 1, (error, count) ->
            return done error if error
            expect(count).to.eql 2
            done null
      return

    it '#5 invalid json value', (done) ->
      class Test extends _g.Model
        @column 'name', String
        @column 'object', type: Object, required: true
        @column 'array', type: [String], required: true
      _g.connection.applySchemas ->
        _g.connection.adapter.run "INSERT INTO tests (name, object, array) VALUES ('croquis', '', '')", (error) ->
          return done error if error
          Test.where().lean(true).exec (error, records) ->
            return done error if error
            expect(records).to.eql [
              { id: records[0].id, name: 'croquis', object: null, array: null }
            ]
            done null
      return

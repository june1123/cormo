_g = require '../support/common'
async = require 'async'
{expect} = require 'chai'

module.exports = () ->
  it 'string length(function)', (done) ->
    try
      class TypeOptionsString1 extends _g.Model
        @column 'col', _g.cormo.types.String(5)
    catch error
      # MongoDB, Sqlite3 does not support String type with length, just skip
      expect(error.message).to.eql 'this adapter does not support String type with length'
      return done null
    _g.connection.applySchemas (error) ->
      return done error if error
      TypeOptionsString1.create col: '01234', (error, record) ->
        expect(error).to.be.null
        TypeOptionsString1.create col: '0123456789', (error, record) ->
          return done null if error
          # MySQL non-strict mode accepts long string
          TypeOptionsString1.find record.id, (error, result) ->
            return done error if error
            expect(result.col).to.eql '01234'
            done null
    return

  it 'string length(string)', (done) ->
    try
      class TypeOptionsString2 extends _g.Model
        @column 'col', 'string(5)'
    catch error
      # MongoDB, Sqlite3 does not support String type with length, just skip
      expect(error.message).to.eql 'this adapter does not support String type with length'
      return done null
    _g.connection.applySchemas (error) ->
      return done error if error
      TypeOptionsString2.create col: '01234', (error, record) ->
        expect(error).to.be.null
        TypeOptionsString2.create col: '0123456789', (error, record) ->
          return done null if error
          # MySQL non-strict mode accepts long string
          TypeOptionsString2.find record.id, (error, result) ->
            return done error if error
            expect(result.col).to.eql '01234'
            done null
    return

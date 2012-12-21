// Generated by CoffeeScript 1.4.0
(function() {
  var ConnectionManipulate, async, inflector;

  async = require('async');

  inflector = require('../inflector');

  ConnectionManipulate = (function() {

    function ConnectionManipulate() {}

    ConnectionManipulate.prototype._manipulateCreation = function(model, data, callback) {
      model = inflector.camelize(model);
      if (!this.models[model]) {
        return callback(new Error("model " + model + " does not exist"));
      }
      model = this.models[model];
      return model.create(data, function(error, record) {
        return callback(error);
      });
    };

    ConnectionManipulate.prototype._manipulateDeletion = function(model, data, callback) {
      model = inflector.camelize(model);
      if (!this.models[model]) {
        return callback(new Error("model " + model + " does not exist"));
      }
      model = this.models[model];
      return model["delete"](data, function(error, count) {
        return callback(error);
      });
    };

    ConnectionManipulate.prototype.manipulate = function(commands, callback) {
      var _this = this;
      if (!Array.isArray(commands)) {
        commands = [commands];
      }
      return async.forEachSeries(commands, function(command, callback) {
        var data, key, model;
        if (typeof command === 'object') {
          key = Object.keys(command);
          if (key.length === 1) {
            key = key[0];
            data = command[key];
          } else {
            key = void 0;
          }
        } else if (typeof command === 'string') {
          key = command;
        }
        if (!key) {
          return callback(new Error('invalid command: ' + JSON.stringify(command)));
        }
        if (key.substr(0, 7) === 'create_') {
          model = key.substr(7);
          return _this._manipulateCreation(model, data, callback);
        } else if (key.substr(0, 7) === 'delete_') {
          model = key.substr(7);
          return _this._manipulateDeletion(model, data, callback);
        } else {
          return callback(new Error('unknown command: ' + key));
        }
      }, function(error) {
        return callback(error);
      });
    };

    return ConnectionManipulate;

  })();

  module.exports = ConnectionManipulate;

}).call(this);
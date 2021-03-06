// using ES6 features supported by Node.js(io.js)

"use strict";

const cormo = require("..");
const co = require("co");

const connection = new cormo.Connection('mysql', {database: 'test'});

class User extends cormo.Model {
  static initialize() {
    this.column('name', {type:String, required:true});
    this.column('age', Number);
  }
};

co(function* () {
  const user = yield User.create({name: 'croquis', age: 3});
  console.log(user);

  const users = yield User.where();
  console.log(users);
}).then(function () {
  console.log("Done");
  process.exit(0);
});

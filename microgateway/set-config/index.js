// get an instance of mongoose and mongoose.Schema
var mongoose = require('mongoose');
var Promise = require("bluebird");
var Schema = mongoose.Schema;
var fs = Promise.promisifyAll(require("fs"));
var yaml = require('js-yaml');

mongoose.Promise = Promise;
var keyFile = '/usr/src/app/node_modules/microgateway/id_rsa.pub';
var uri = 'mongodb://apim:27017/apim';
var envFile = '/usr/src/app/node_modules/microgateway/env.yaml';
var Environment = mongoose.model('environments', new Schema({
  shortName: String,
  gatewayType: String,
  standaloneMicroGateway: { title: String, publicKey: String }
}));

var connectWithRetry = function() {
  return mongoose.connect(uri)
    .then(() => {
      var query = Environment.findOne({ shortName: 'sb' });
      return query.then(function (doc) {
        if (!doc || !doc._id) {
            throw new Error('Catalog \'sb\' has not been created');
          } else {
            return fs.readFileAsync(envFile, 'utf8')
              .then(function(data) {
                var env = yaml.safeLoad(data);
                env.APIMANAGER_CATALOG = doc._id.toString();
                var dataToWrite = yaml.safeDump(env);
                return fs.writeFileAsync(envFile, dataToWrite)
              }).then(function(){
                console.log('The config file was saved!');
              })
              .catch(function(e) {
                throw new Error(e);
              });
          }
        })
        .then(function(doc) {
          fs.readFile(keyFile, 'utf8', function(err, data) {
            if (err) {
              mongoose.disconnect();
              console.log(err);
            }
            return Environment.findOneAndUpdate( {$and:[
              { shortName: 'sb' },
              {
                "standaloneMicroGateway": {$exists: false}
              }
            ]}, {
              $set: {
                gatewayType: 'StandaloneMicroGateway',
                standaloneMicroGateway: {
                  title: 'API Connect Standalone Micro Gateway',
                  publicKey: data
                },
              }
            }, { new: true }, function(err, newdoc) {
              if (err) {
                console.log('Unable to update catalog settings', err);
                return;
              }
              console.log('Successfully updated apim catalog settings');
              mongoose.disconnect();
              return;
            });
          });
        })
        .catch(function(err){
          console.log(err.message + ', retrying in 10 seconds');
          setTimeout(connectWithRetry, 10000);
          mongoose.disconnect();
        });
    })
  .catch(function(err){
    if (err.name !== 'MongoError') {
      console.log(err.name + ': ' + err.message);
    }
    console.log('Waiting for apim to be ready, retrying in 10 seconds');
    setTimeout(connectWithRetry, 10000);
  });


};

connectWithRetry();

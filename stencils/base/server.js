var fs      = require('fs'),
    express = require("express"),
    util    = require("util"),
    mongoose= require("mongoose");

var config = {
    'MONGO_URL':'mongodb://localhost:27017/@APP@Data',
    'WWW_PATH':__dirname+'/../../public',
    'API_PATH':__dirname+'/handlers',
    'SCHEMA_PATH':__dirname+'/schema'
}

mongoose.connect(config.MONGO_URL);

var app = express.createServer();
app.use(express.bodyParser());
app.use(express.static(config.WWW_PATH));

var Schema = mongoose.Schema,
    ObjectId = Schema.ObjectId;

var context = {
    app: app,
    mongoose: mongoose,
    Schema: Schema,
    ObjectId: ObjectId
};

console.log("Gor.js: Reading schema files:");

fs.readdir(config.SCHEMA_PATH,function(err,files) {
    files.forEach(function(file) {
        if (/(.*)\.js$/.test(file)) {
            require(config.SCHEMA_PATH+'/'+file).define(context);
        }
    });
});
console.log("Gor.js: Reading handers files:");

fs.readdir(config.API_PATH,function(err,files) {
    files.forEach(function(file) {
        if (/(.*)\.js$/.test(file)) {
            require(config.API_PATH+'/'+file).define(context);
        }
    });
});

app.listen(9999);


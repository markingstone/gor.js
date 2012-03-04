// TODO: Edit the schema and register your entity attributes
function define(context) {
    var @CRESOURCE@Schema = new context.Schema({
        stringAttr : String,
        referenceAttr : String,
        integerAttr : Number,
        booleanAttr : Boolean
    });

    context.mongoose.model('@CRESOURCE@',@CRESOURCE@Schema);
}

exports.define = define;

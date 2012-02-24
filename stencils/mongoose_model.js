function define(context) {
    var @CRESOURCE@Schema = new context.Schema({
        //attr1: String,
        //attr2: String,
        //attr3: String
    });

    context.mongoose.model('@CRESOURCE@',@CRESOURCE@Schema);
}

exports.define = define;


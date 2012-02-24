function define(context) {
    context.app.get('/@RESOURCE@s/index.json', function(req,res) {
        res.contentType("application/json");
        res.send(JSON.stringify([]));
    });

    context.app.post('/@RESOURCE@s/',function(req,res){
        res.contentType("application/json");
        var robj = JSON.parse(req.body.obj);
        res.send(JSON.stringify({}));
    });

    context.app.del('/@RESOURCE@s/:id',function(req,res) {
    });

}

exports.define = define;


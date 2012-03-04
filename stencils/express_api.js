function define(context) {
    // @CRESOURCE@ is defined in app.node/schemas/@RESOURCE@.js
    var @CRESOURCE@ = context.mongoose.model('@CRESOURCE@');

    // REST interfaces
    
    // GET index
    context.app.get('/@RESOURCE@s', function(req,res,next) {
        res.contentType("application/json");
        // var re = new RegExp('.*'+req.query.query+'.*', 'i');
        var query = {};
        if (req.query.query !== undefined) {
            var re = new RegExp(req.query.query+'.*', 'i');
            query = {stringAttr : {$regex:re } };
        }
        @CRESOURCE@.find(query,function(err,docs) {
            if (err)
                next(new Error('Unable to fetch entities.'));
            else
                res.json(docs);
        });
    });

    // POST a new @RESOURCE@
    context.app.post('/@RESOURCE@s',function(req,res,next){
        res.contentType("application/json");
        var @RESOURCE@ = new @CRESOURCE@(req.body.@RESOURCE@);
        @RESOURCE@.save(function(err) {
            if (err) 
                next(new Error('Unable to save @RESOURCE@.'));
            else
                res.json(@RESOURCE@);
        });
    });

    // PUT an updated @RESOURCE@
    context.app.put('/@RESOURCE@s/:id',function(req,res,next){
        res.contentType("application/json");
        var condition = {'_id':req.params.id};
        @CRESOURCE@.update(condition,
                      req.body.@RESOURCE@,
                      {multi:true},
                      function(err,num) {
            if (err)
                next(new Error('Unable to update @RESOURCE@.'));
            else
                res.json(null);
        });
    });

    // DEL an existing @RESOURCE@
    context.app.del('/@RESOURCE@s/:id',function(req,res,next) {
        res.contentType("application/json");
        @CRESOURCE@.findOne({_id:req.params.id},function(err,doc) {
            if (err)
                res.json('unable to find @RESOURCE@',404);
            else
                doc.remove(function(err) {
                    if (err)
                        next(new Error('Unable to delete @RESOURCE@.'));
                    else
                        res.json(null);
                });
        });
    });
}

exports.define = define;

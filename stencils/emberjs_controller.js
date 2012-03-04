@APP@.set('@RESOURCE@sController', Ember.ArrayController.create({
    tagName:'tbody',
    content: [],
    dirty: 0,
    hasSelected : function() {
        this.set('dirty',false);
        return this.filterProperty('isSelected',true).length === 0;
    }.property('dirty'),
    findAll : function(q) {
        var self = this;
        if (q===undefined)
            q = {};
        return jQuery.ajax({
            url: '/@RESOURCE@s',
            data : { query : q },
            dataType: 'json',
            type: 'GET'
        }).done( function(json) {
            self.set("content", []);
            for (var i=0; i < json.length; i++) {
                self.pushObject(@APP@.@CRESOURCE@.create(json[i]));
            }
        });
    },
    removeSelected : function() {
        this.forEach(function(obj) {
            if (obj.isSelected) {
                obj.destroy()
                .done(function() {
                    @APP@.@RESOURCE@sController.removeObject(obj);
                });
            }
        });
    }
}));




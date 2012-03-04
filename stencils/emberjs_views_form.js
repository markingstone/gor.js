// This is just a sample controller to drive the select field.
// You can bind select fields to any other ArrayController.
@APP@.@RESOURCE@SelectController = Ember.ArrayController.create({
    content: [
        Ember.Object.create({id:1,label:'Value1'}),
        Ember.Object.create({id:2,label:'Value2'}),
        Ember.Object.create({id:3,label:'Value3'}),
        Ember.Object.create({id:4,label:'Value4'})
    ]
});

// @CRESOURCE@ form view
@APP@.@CRESOURCE@View = Ember.View.extend({
    templateName : '@RESOURCE@s-form',
    item : null,
    triedToSubmit : false, // used to alert for errors
    isFailed : false,
    // Sample validation for one of the fields
    isStringError : function() {
        return this.item.verifyStringAttr()===false;
    }.property('item.stringAttr'),
    close : function() {
        $("#@RESOURCE@-dialog").modal('hide');
        this.remove();
    },
    didInsertElement: function() {
        $("#@RESOURCE@-dialog").modal();
    },
    isErroneous: function() {
        return this.get('isStringError') && this.get('triedSubmit');
    }.property('isStringError','triedSubmit')
});

// Extended @RESOURCE@ form for new @CRESOURCE@s
@APP@.New@CRESOURCE@View = @APP@.@CRESOURCE@View.extend({
    submit : function() {
        this.set('triedSubmit',true);
        if (this.get('isErroneous')===false) {
            var self = this;
            this.item.save()
                .fail(function(e) {
                    self.set('isFailed',true);    
                })
                .done(function() {
                    @APP@.@RESOURCE@sController.pushObject(self.item);
                    self.close();
                });
        }
    }
});

// Extended @RESOURCE@ form for @RESOURCE@ updates
@APP@.Update@CRESOURCE@View = @APP@.@CRESOURCE@View.extend({
    // this.actualItem will hold the living managed object,
    // while this.item holds a replicated, dummy copy.
    actualItem : null, 
    submit : function() {
        var item = this.item;
        var self = this;
        this.item.save()
            .fail( function(e) {
                self.set('isFailed',true);    
            })
            .done( function() {
                self.actualItem.clone(item);
                self.close();
            });
    }
});


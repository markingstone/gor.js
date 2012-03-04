// Your @RESOURCE@ with some dummy attributes..
@APP@.@CRESOURCE@ = Ember.Object.extend({
    stringAttr : '',
    referenceAttr : null,
    integerAttr: 0,
    booleanAttr: false,
    clone : function(target) {
        this.set('stringAttr',target.stringAttr);
        this.set('referenceAttr',target.referenceAttr);
        this.set('integerAttr',target.integerAttr); 
        this.set('booleanAttr',target.booleanAttr); 
    },
    verifyStringAttr : function() {
        return (/test/).test(this.stringAttr)===false;
    },
    save : function() {
        var self = this;
        return jQuery.ajax({
            url: '/@RESOURCE@s' + (this._id !== undefined ? '/'+this._id : ''),
            data: {@RESOURCE@ : { 
                stringAttr : this.stringAttr,
                referenceAttr : this.referenceAttr === null ? null : this.referenceAttr.id,
                booleanAttr : this.booleanAttr,
                integerAttr : this.integerAttr
            }},
            dataType: 'json',
            type: (this._id === undefined ? 'POST' : 'PUT')
        }).done( function(obj) {
            if (obj) {
                if (self._id === undefined)
                    self._id = obj._id;
            }
        });
    },
    destroy : function() {
        return jQuery.ajax({
            url: '/@RESOURCE@s/' + this._id,
            dataType: 'json',
            type: 'DELETE'
        });
    }
});

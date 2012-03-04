@APP@.@CRESOURCE@Toolbar = Ember.View.extend({
    templateName: '@RESOURCE@s-toolbar',
    searchQuery: '',
    new@CRESOURCE@ : function() {
        var v = @APP@.New@CRESOURCE@View.create({item:@APP@.@CRESOURCE@.create()});
        v.appendTo('#content');
    },
    del@CRESOURCE@ : function() {
        @APP@.@RESOURCE@sController.removeSelected();
    },
    filterBySearchQuery : function() {
        @APP@.@RESOURCE@sController.findAll(this.searchQuery);
    }.observes('searchQuery')
});


// @CRESOURCE@ table line
@APP@.@CRESOURCE@Item = Ember.View.extend({
    templateName: '@RESOURCE@s-item',
    edit: function() {
        @APP@.Update@CRESOURCE@View
            .create({      item : @APP@.@CRESOURCE@.create(this.item),
                     actualItem : this.item})
            .appendTo('#content');
    },
    selectionChanged : function() {
        @APP@.@RESOURCE@sController.set('dirty',true);
    }.observes('item.isSelected')
});


// @CRESOURCE@s table view
@APP@.@CRESOURCE@sView = Ember.View.extend({
    templateName: '@RESOURCE@s-list',
    selectAll: false,
    updateSelected : function() {
        @APP@.@RESOURCE@sController.setEach('isSelected',this.selectAll);
    }.observes('selectAll'),
    didInsertElement : function() {
        @APP@.@RESOURCE@sController.findAll();
    }
});

// Append the @CRESOURCE@ state to the global state manager
@APP@.StateManager.reopen({
    @RESOURCE@s: Ember.ViewState.create({
        view: @APP@.@CRESOURCE@sView
    })
});


@APP@.@CRESOURCE@Item = Ember.View.extend({
    templateName: '@RESOURCE@s-item',
    itemBinding:'content'
});

@APP@.@CRESOURCE@sView = Ember.View.extend({
    templateName: '@RESOURCE@s-list'
});

@APP@.StateManager.reopen({
    initialState: '@RESOURCE@s',

    @RESOURCE@s: Ember.ViewState.create({
        view: @APP@.@CRESOURCE@sView
    })
});


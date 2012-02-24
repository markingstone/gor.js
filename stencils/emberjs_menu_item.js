@APP@.@CRESOURCE@sMenuItem = Ember.View.extend({
    classNameBindings: ["active"],
    active: function() {
        return @APP@.stateManager.currentState.name=="@RESOURCE@s";
    }.property("@APP@.stateManager.currentState"),
    select: function() {
        @APP@.stateManager.goToState("@RESOURCE@s");
    }
});



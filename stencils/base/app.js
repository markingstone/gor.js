@APP@.HomeView = Ember.View.extend({
    templateName : "welcome-home"
});

$(document).ready(function() {
    @APP@.stateManager = @APP@.StateManager.create({
        initialState : 'welcome',
        home : function() {
            this.goToState(this.initialState);
        },
        welcome: Ember.ViewState.create({
            view: @APP@.HomeView
        })
    });
});

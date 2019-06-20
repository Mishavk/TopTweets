/**
 * Created by mkachan on 07.06.2019.
 */
({
    getAuthorsList: function (component, event, helper) {

        var action = component.get("c.getAuthors");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var contactList = response.getReturnValue();
                component.set("v.authors", contactList);
            }
        });
        $A.enqueueAction(action);
    },

})
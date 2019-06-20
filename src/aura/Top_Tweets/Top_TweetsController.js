/**
 * Created by mkachan on 07.06.2019.
 */
({
    doInit: function(component, event, helper){

        helper.getAuthorsList(component,event,helper);

    },
    deleteAuthor: function (component, event, helper) {
        var postId = event.getSource().get('v.value');

        var action = component.get("c.deleteAuthors");
        action.setParams({ id : postId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log("Start -> deleteContact state" + state);

            if (state === "SUCCESS") {
                var showSuccessToast = component.get('c.showSuccessToast');
                $A.enqueueAction(showSuccessToast);
                $A.get('e.force:refreshView').fire();
            }else if (state === "ERROR") {
                var errors = response.getError();

                if (errors) {
                    console.log('errors --->'+errors[0].toString())

                    if (errors[0] && errors[0].message) {
                        component.set("v.errors", errors[0].message)
                        var showErrorToast = component.get('c.showErrorToast');
                        $A.enqueueAction(showErrorToast);
                    }else {
                        component.set("v.errors", 'Unknown error')
                        var showErrorToast = component.get('c.showErrorToast');
                        $A.enqueueAction(showErrorToast);
                    }
                }
            }
        });

        $A.enqueueAction(action);
    },

    showSuccessToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: 'Successfully deleted',
            duration:' 4000',
            type: 'success',
        });
        toastEvent.fire();
    },
    showErrorToast : function( component, event, helper) {
        var message = component.get("v.errors")
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message:'Error message: ' + message,
            duration:' 4000',
            type: 'error',
        });
        toastEvent.fire();
    },

    onclick: function (component, event, helper) {
        var text  = event.currentTarget.title;
        var id  = event.currentTarget.id;
        var setPost = $A.get("e.c:SetTextPost");
        setPost.setParams({
            "id": id,
            "textPost" : text
        });
        setPost.fire();
    }
})
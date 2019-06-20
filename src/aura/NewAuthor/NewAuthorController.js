/**
 * Created by mkachan on 07.06.2019.
 */
({

    handleClick : function(component, event) {

        var inputName = component.find("inputName").get("v.value");
        if (inputName == ''){
            component.set("v.errors", 'Enter profile name!')
            var showErrorToast = component.get('c.showErrorToast');
            $A.enqueueAction(showErrorToast);
            return
        }

        var action = component.get("c.newRecordAuthor");
        action.setParams({ name : inputName });
        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var showSuccessToast = component.get('c.showSuccessToast');
                $A.enqueueAction(showSuccessToast);
                $A.get('e.force:refreshView').fire();
            }else if (state === "ERROR") {
                var errors = response.getError();
                var message = '';
                var STATUS_CODE = 'CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY';
                var errorMesage = 'You having max count accounts';
                if (errors) {
                    console.log(JSON.stringify(errors, null, 2));

                    for(var i=0; i < errors.length; i++) {
                        for(var j=0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                            if (STATUS_CODE == errors[i].pageErrors[j].statusCode ){

                                component.set("v.errors", errorMesage);
                                var showErrorToast = component.get('c.showErrorToast');
                                $A.enqueueAction(showErrorToast);
                            }else {

                                component.set("v.errors", errors[i].pageErrors[j].message);
                                var showErrorToast = component.get('c.showErrorToast');
                                $A.enqueueAction(showErrorToast);
                            }
                            message += (message.length > 0 ? '\n' : '') + errors[i].pageErrors[j].message;
                        }

                        if(errors[i].message) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].message;
                        }
                    }
                    console.error(message);
                }else {
                        component.set("v.errors", 'Unknown error')
                        var showErrorToast = component.get('c.showErrorToast');
                        $A.enqueueAction(showErrorToast);
                }
            }
        });
        $A.enqueueAction(action);
    },
    showSuccessToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: 'Successfully added',
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


})
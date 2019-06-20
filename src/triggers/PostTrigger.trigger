/**
 * Created by mkachan on 20.06.2019.
 */

trigger PostTrigger on Post__c (before insert, before update, before delete,
                                after insert, after update, after delete) {

    if (Trigger.isBefore) {
    if (Trigger.isInsert) {

        PostClass.countPost(Trigger.new);

        }else if (Trigger.isUpdate) {
        } else if (Trigger.isDelete) {
        }
    }else if (Trigger.isAfter) {
        if (Trigger.isInsert) {
        }else if (Trigger.isUpdate) {
            }else if (Trigger.isDelete) {
            }
    }

}
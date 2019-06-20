/**
 * Created by mkachan on 11.06.2019.
 */

global with sharing class SchedulableStart implements Schedulable {


    global void execute(SchedulableContext ctx) {
        final Request_API_Twitter__c request_API = Request_API_Twitter__c.getOrgDefaults();

        Database.executeBatch( new QueueableRunTopTwitter(),
                                request_API.NUMBER_OF_ACCOUNT_REQUESTS_FOR_ONE_ITERA__c.intValue() );
    }

}
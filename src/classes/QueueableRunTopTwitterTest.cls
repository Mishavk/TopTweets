/**
 * Created by mkachan on 13.06.2019.
 */

@isTest (SeeAllData=false)
public with sharing class QueueableRunTopTwitterTest {
    public static String ANSWER_JSON;
    public final static String TEXT = 'The atmosphere on Mars is mostly carbon dioxide w no breathable oxygen.';
    public final static Integer FAVORITE_COUNT = 5000;
    public final static String ID_STR = '1139344707853672453';
    public final static Long ID = 1139344707853672453L;

    public final static String ID_PARAM = 'id';
    public final static String ID_STR_PARAM = 'id_str';
    public final static String TEXT_PARAM = 'text';
    public final static String FAVORITE_COUNT_PARAM = 'favorite_count';

    public final static Integer QUONTITY_ACCOUNT  = 6;
    public final static String SET_HEADER_PAR_CONTENT = 'Content-Type';
    public final static String SET_HEADER_PAR_TEXT = 'text/json';
    public final static String NAME_ID = 'Test_';




    @testSetup
    static void setup() {
        Request_API_Twitter__c request_API = Request_API_Twitter__c.getOrgDefaults();

        request_API.REQUEST_URL__c = 'https://api.twitter.com/1.1/statuses/user_timeline.json?trim_user=true';
        request_API.COUNT_POST_PARAM__c	= '&count=';
        request_API.INCLUDE_RTS__c	= '&include_rts=false';
        request_API.EXCLUDE_REPLIES__c	= '&exclude_replies=true';
        request_API.SCREEN_NAME_PARAM__c	= '&screen_name=';
        request_API.COUNT_POST_VALUE__c	= '200';
        request_API.MAX_ID_PARAM__c = '&max_id=';
        request_API.REQUEST_URL_OAUTH2__c	= 'https://api.twitter.com/oauth2/token';
        request_API.GRANT_TYPE__c	= 'grant_type=client_credentials';
        request_API.QUANTITY_OF_REQUESTS_IN_HISTORY__c	= 14;
        request_API.NUMBER_OF_ACCOUNT_REQUESTS_FOR_ONE_ITERA__c = 6;

        insert request_API ;

        List <Post__c> newPosts = new List <Post__c> ();
        for (Integer i = 0; i < QUONTITY_ACCOUNT; i++){
            newPosts.add( new Post__c ( ));
        }
        insert newPosts;

        List <Author__c> newAuthor = new List <Author__c> ();
        Integer i = 1;
        for (Post__c newPost : newPosts ){
            newAuthor.add( new Author__c ( Name = NAME_ID + i, Post__c = newPost.Id)  );
            i++;
        }
        insert newAuthor;
    }


    @isTest
     static void testCallout() {
        Test.setMock(HttpCalloutMock.class, new RestMockPositive());
        Test.startTest();

            Database.executeBatch( new QueueableRunTopTwitter(), 6 );

        Test.StopTest();

        Author__c  authorSel = [SELECT Id, Name, Post__c, Post__r.Likes__c, Post__r.Text__c,
                                Post__r.Number_of_post__c
                                FROM Author__c
                                LIMIT 1];

        System.assertEquals(TEXT, authorSel.Post__r.Text__c);
        System.assertEquals(FAVORITE_COUNT, authorSel.Post__r.Likes__c.intValue());
        System.assertEquals(ID_STR, authorSel.Post__r.Number_of_post__c);

        Integer countId = [SELECT COUNT () FROM Post__c WHERE Likes__c = :FAVORITE_COUNT];
        System.assertEquals(QUONTITY_ACCOUNT, countId);


    }


    private class RestMockPositive implements HttpCalloutMock {

        public HTTPResponse respond(HTTPRequest req) {
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeNumberField(ID_PARAM, ID );
            gen.writeStringField(ID_STR_PARAM, ID_STR);
            gen.writeStringField(TEXT_PARAM, TEXT);
            gen.writeNumberField(FAVORITE_COUNT_PARAM, FAVORITE_COUNT);
            gen.writeEndObject();

            ANSWER_JSON = '['+ gen.getAsString() +']';


            HTTPResponse res = new HTTPResponse();
            res.setHeader(SET_HEADER_PAR_CONTENT, SET_HEADER_PAR_TEXT);
            res.setBody(ANSWER_JSON);
            res.setStatusCode(200);
            return res;
        }
    }


}
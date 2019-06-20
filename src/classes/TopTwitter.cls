/**
 * Created by mkachan on 13.06.2019.
 */

public with sharing class TopTwitter {
    Request_API_Twitter_MD__mdt request_API = new Request_API_Twitter_MD__mdt();

    final String REQEST_SET_GET_METHOD = 'GET';
    final String REQEST_SET_POST_METHOD = 'POST';
    final String BEARER_PARAM = 'Bearer ';
    final String BASIC_PARAM = 'Basic ';
    final String AUTHORIZATION_PARAM = 'Authorization';
    final String ACCESS_TOKEN = 'access_token';


    public TwitterResults requestToTwitter (Author__c author) {
        request_API = [SELECT KEY__c, SECRET_KEY__c,
                        REQUEST_URL__c, SCREEN_NAME_PARAM__c, COUNT_POST_PARAM__c,
                        COUNT_POST_VALUE__c, INCLUDE_RTS__c, EXCLUDE_REPLIES__c,
                        GRANT_TYPE__c, REQUEST_URL_OAUTH2__c, QUANTITY_OF_REQUESTS_IN_HISTORY__c,
                        MAX_ID_PARAM__c
                        from Request_API_Twitter_MD__mdt ];
        HttpRequest request = new HttpRequest();
        request.setEndpoint( request_API.REQUEST_URL__c +
                request_API.SCREEN_NAME_PARAM__c + author.Name +
                request_API.COUNT_POST_PARAM__c + request_API.COUNT_POST_VALUE__c +
                request_API.INCLUDE_RTS__c +
                request_API.EXCLUDE_REPLIES__c );

        request.setMethod( REQEST_SET_GET_METHOD );
        String authorizationHeader = BEARER_PARAM + getBearerToken();
        request.setHeader(AUTHORIZATION_PARAM, authorizationHeader);

        Http http = new Http();
        HTTPResponse res = http.send(request);

        String sBody =  res.getBody();
        List <TwitterResults> tResults = TwitterResults.parse(sBody);

        String requestNewPost;
        Long minId;
        List <TwitterResults> tResultsTemp = tResults.clone();

        for (Integer i=0; i< request_API.QUANTITY_OF_REQUESTS_IN_HISTORY__c; i++ ){
            minId = getMinIdForRequest(tResultsTemp);
            tResultsTemp = new List<TwitterResults>();

            // request next posts
            requestNewPost = getTwittsRequest(author.Name, minId);
            request.setEndpoint(requestNewPost);

            res = http.send(request);
            sBody =  res.getBody();
            tResultsTemp = TwitterResults.parse(sBody) ;
            tResults.addAll(TwitterResults.parse(sBody));
        }

        // get mostLikeId
        Integer mostLike;
        Long mostLikeId = null;
        TwitterResults newResults = new TwitterResults();

        For (TwitterResults tRes : tResults) {
            if (mostLike == null ||  tRes.favorite_count > mostLike) {
                mostLike = tRes.favorite_count;
                mostLikeId = tRes.id;
                newResults = tRes;
            }
        }

        return newResults;

    }
    public String getTwittsRequest(String author, Long maxId ) {

        String requestNextPost = request_API.REQUEST_URL__c +
                request_API.SCREEN_NAME_PARAM__c + author+
                request_API.COUNT_POST_PARAM__c + request_API.COUNT_POST_VALUE__c +
                request_API.MAX_ID_PARAM__c + maxId +
                request_API.INCLUDE_RTS__c +
                request_API.EXCLUDE_REPLIES__c;
        return requestNextPost;
    }

    public static Long getMinIdForRequest ( List <TwitterResults> twitterResults){

        Long  minIdForRequest;
        for (TwitterResults minId : twitterResults) {
            if (minIdForRequest == null || minId.id < minIdForRequest ) {
                minIdForRequest = minId.id;
            }
        }
        return minIdForRequest;
    }


    private String getBearerToken() {

        String sFinal = request_API.KEY__c + ':' + request_API.SECRET_KEY__c;
        Blob headerValue = Blob.valueOf(sFinal);

        HttpRequest req = new HttpRequest();
        req.setEndpoint(request_API.REQUEST_URL_OAUTH2__c);
        req.setMethod(REQEST_SET_POST_METHOD);

        String authorizationHeader = BASIC_PARAM + EncodingUtil.base64Encode(headerValue);
        req.setHeader(AUTHORIZATION_PARAM, authorizationHeader);

        req.setBody(request_API.GRANT_TYPE__c);

        //Make request
        Http http = new Http();
        HTTPResponse res = http.send(req);
        String stoken;
        //Parse JSON for Bearer Token
        JSONParser parser = JSON.createParser(res.getBody());
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == ACCESS_TOKEN){
                parser.nextToken();
                stoken = parser.getText();
            }
        }
        //Return Token so it can be used in next call
        return stoken;
    }
}
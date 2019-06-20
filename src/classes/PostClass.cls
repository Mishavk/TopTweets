/**
 * Created by mkachan on 20.06.2019.
 */

public with sharing class PostClass {
    static final Integer MAX_COUNT_POST = 15;
    static final String TEXT_OF_MESEGE = 'You having max count accounts';

    public static void countPost(List<Post__c> getPosts){
        Integer countNewPost = getPosts.size();
        Integer posts = [SELECT Count() FROM Post__c ];
        if ((countNewPost + posts )> MAX_COUNT_POST ){
           throw new AuraHandledException(TEXT_OF_MESEGE);
        }

    }

}
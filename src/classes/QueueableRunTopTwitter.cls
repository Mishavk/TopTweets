/**
 * Created by mkachan on 11.06.2019.
 */

global with sharing class QueueableRunTopTwitter implements Database.Batchable<sobject>, Database.AllowsCallouts {

    global Database.QueryLocator start(Database.BatchableContext bc) {

        return Database.getQueryLocator(  [SELECT Id, Name, Post__c, Post__r.Likes__c, Post__r.Text__c,
                                            Post__r.Number_of_post__c
                                            FROM Author__c] );
    }

    global void execute(Database.BatchableContext bc, List <Author__c> listAuthor ) {

        TwitterResults twitterResults = new TwitterResults();
        List <Post__c> updatePosts = new List<Post__c>();
        TopTwitter topTwitter = new TopTwitter();

        for (Author__c author : listAuthor) {
            twitterResults = topTwitter.requestToTwitter(author);

            updatePosts.add( new Post__c (
                    Id = author.Post__c,
                    Likes__c = twitterResults.favorite_count,
                    Text__c = twitterResults.text,
                    Number_of_post__c = twitterResults.id_str   ));
        }
        update updatePosts;
    }

    global void finish(Database.BatchableContext bc){

    }
}
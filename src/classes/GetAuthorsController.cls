/**
 * Created by mkachan on 07.06.2019.
 */

public with sharing class GetAuthorsController {
    @AuraEnabled
    public static List<Author__c> getAuthors() {
        return [SELECT Id, Name, Post__r.Name, Post__r.Likes__c, Post__r.Text__c,
                        Post__r.Number_of_post__c
                FROM Author__c   LIMIT 100];
    }

    @AuraEnabled
    public static void deleteAuthors(Id id) {
        Post__c idPost = new Post__c(Id = id);
        try {
            delete idPost;
        } catch(DmlException e) {
            System.debug('Error apex GetAuthorsController: ' + e.getMessage());
        }
    }
}
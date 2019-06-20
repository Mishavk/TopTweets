/**
 * Created by mkachan on 13.06.2019.
 */

public with sharing class NewRecordAuthorController {
    public String name {get; set;}

    @AuraEnabled
    public static Boolean  newRecordAuthor(String name){
        Post__c newPost =new Post__c ();
        insert newPost;
        Author__c newAuthor = new Author__c(Name = name, Post__c = newPost.Id );

        insert newAuthor;
        return newAuthor.Id != null;

    }
}
public with sharing class AccountDetailsController {
            @AuraEnabled(cacheable=true)
            public static List<Account> getAccountList() {
                return [
                    SELECT Id, Name, Title__c from Account];                       
            }
            
}
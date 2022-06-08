public with sharing class contactController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList() {
                return [
                    SELECT Id, Name, Email, Title from Contact];                       
            }

}
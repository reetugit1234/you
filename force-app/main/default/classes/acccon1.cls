public class acccon1 {
    @AuraEnabled
    public static List <Partner> fetchAccounts() {
        //Qyery 10 accounts
        List<Partner> accList = [SELECT Id, OpportunityId, AccountFromId, AccountToId, Role,
                                 IsPrimary, ReversePartnerId, LastModifiedById, CreatedById FROM Partner LIMIT 10];
        //return list of accounts
        return accList;
    }

}
trigger AccountAddressTrigger on Account(before insert, before update) {
 list < Account > aclist = new list < Account > ();
 list < String > listId = new list < String > ();
 if (Trigger.isInsert || Trigger.isUpdate) {
  for (Account ac: Trigger.New) {
   if (ac.Match_Billing_Address__c == true && ac.BillingPostalCode != null) {
    ac.ShippingPostalCode = ac.BillingPostalCode;
   }
  }
 }
}
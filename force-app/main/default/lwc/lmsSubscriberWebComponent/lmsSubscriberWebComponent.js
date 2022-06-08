import { LightningElement,wire,track} from 'lwc';
    import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
    //Import message service features required for subscribing and the message channel
    import { subscribe, MessageContext } from 'lightning/messageService';
    import recordSelected from '@salesforce/messageChannel/Record_Selected__c';
    import NAME_FIELD from '@salesforce/schema/Account.Name';
    import ID_FIELD from '@salesforce/schema/Account.Id';
    import TITLE_FIELD from '@salesforce/schema/Account.Title__c';
   
   
     const fields = [
       NAME_FIELD,
       ID_FIELD,
       TITLE_FIELD,
      
   ];
   
      export default class LmsSubscriberWebComponent extends LightningElement
    {
          subscription = null;
          @track accId;
          @track selectedAccount;
   
          
          @wire(MessageContext)
          messageContext;
                       
           connectedCallback() {
             this.subscribeToMessageChannel();
               }
              
   
           subscribeToMessageChannel() {
            
             if (this.subscription) {
               return;
           }
           this.subscription = subscribe(this.messageContext, recordSelected, (message) => {
               console.log(message.AccountId);
               console.log('Subscribed');
               this.accId = message.AccountId;
               console.log('accIdkkk-->'+this.accId);              
       
           });   
       }
        
           @wire(getRecord,{recordId:'$accId', fields })
           account;
           
       get id() {
         return getFieldValue(this.account.data, ID_FIELD);
     }
   
     get name() {
         return getFieldValue(this.account.data, NAME_FIELD);
     }
   
     get title() {
         return getFieldValue(this.account.data, TITLE_FIELD);
     }
         
}
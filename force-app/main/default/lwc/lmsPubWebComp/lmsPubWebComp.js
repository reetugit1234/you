import { LightningElement,wire,track } from 'lwc';
import getAccountList from '@salesforce/apex/AccountDetailsController.getAccountList';
// Import message service features required for publishing and the message channel
import recordSelected from '@salesforce/messageChannel/Record_Selected__c';
import {publish, MessageContext} from 'lightning/messageService';
export default class LmsPubWebComp extends LightningElement {
  
     //@api account;
    @track accId;
    @track selectedAccount;
    @wire(MessageContext)
    messageContext;
    @wire(getAccountList) accounts;

    handleClick(event) {
       
        this.accId = event.currentTarget.dataset.id;
         console.log('account-->'+this.accId);
         let acc= this.accounts.data;
         console.log(JSON.stringify(acc));
        this.selectedAccount = acc.find(account => account.Id === this.accId);
        console.log('selectedAccount-->'+this.selectedAccount);
        console.log('publish account Id:'+this.accId);
      
        const payload= {AccountId:this.selectedAccount};
              
       
        publish(this.messageContext, recordSelected, payload);
    }

    

     
}
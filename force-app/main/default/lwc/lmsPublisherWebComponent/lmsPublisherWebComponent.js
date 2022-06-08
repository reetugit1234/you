import { LightningElement,wire,track } from 'lwc';
import getAccountList from '@salesforce/apex/AccountDetailsController.getAccountList';
// Import message service features required for publishing and the message channel
import recordSelected from '@salesforce/messageChannel/Record_Selected__c';
import {publish, MessageContext} from 'lightning/messageService';
export default class PublishAccount extends LightningElement {
  
     //@api account;
    @track accId;
    @wire(MessageContext)
    messageContext;
    @wire(getAccountList) accounts;

    handleClick(event) {
       
        this.accId = event.currentTarget.dataset.id;
        console.log('publish account Id:'+this.accId);
      //  let ss= event.target.value;
    //    console.log('sss-->'+ss);
       // console.log('accId-->'+accId);
        const payload= {AccountId:this.accId};
              
       
        publish(this.messageContext, recordSelected, payload);
    }

    

     
}
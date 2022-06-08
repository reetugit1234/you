import { LightningElement,wire,track} from 'lwc';
//Import message service features required for subscribing and the message channel
import { subscribe, MessageContext } from 'lightning/messageService';
import recordSelected from '@salesforce/messageChannel/Record_Selected__c';
import getAccountList from '@salesforce/apex/AccountDetailsController.getAccountList';

export default class LmsSubWebComp extends LightningElement
{
      subscription = null;
      @track accData;

    
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
          
           this.accData = message.AccountId;
                         console.log('sub accdata-->'+JSON.stringify( this.accData));
   
       });   
   }
    
}
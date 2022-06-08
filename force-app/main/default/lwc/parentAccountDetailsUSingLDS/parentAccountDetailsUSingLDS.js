import { LightningElement,track } from 'lwc';

export default class ParentAccountDetailsUSingLDS extends LightningElement {

   @track accountId;

    
     accountClick(event){
        this.accountId=event.detail;
        //  console.log('this.accountId-->'+this.accountId);
     }
      

}
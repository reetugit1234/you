import { LightningElement,wire,track } from 'lwc';
import getAccountList from '@salesforce/apex/AccountDetailsController.getAccountList';
export default class accountDetailsUsingLDS extends LightningElement {

    @wire(getAccountList) accountRecords;

     
        
    selectHandler(event){
        
        // console.log('accId-->'+accId);
        // perevent navigation of url
        event.preventDefault();
    
        const accId= event.currentTarget.dataset.id;
        const selectedEvent = new CustomEvent('selected', { detail: accId});

        this.dispatchEvent(selectedEvent);

    }
}
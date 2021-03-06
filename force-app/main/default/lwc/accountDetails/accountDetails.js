import { LightningElement ,api,wire,track} from 'lwc';

export default class AccountChild extends LightningElement {

   
    @api account;

    selectHandler(event) {
// Prevents the anchor element from navigating to a URL
        event.preventDefault();

// Creates the event with the account ID data.
        const selectedEvent = new CustomEvent('selected', { detail: this.account.Id });

        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
  
 
    }

}
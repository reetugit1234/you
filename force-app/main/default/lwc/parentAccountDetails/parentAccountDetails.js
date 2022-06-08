import { LightningElement,wire} from 'lwc';
import getAccountList from '@salesforce/apex/AccountDetailsController.getAccountList';
export default class ParentAccountDetails extends LightningElement {

    selectedAccount;
    @wire(getAccountList) accounts;

      
    

    accountSelected(event) {
        const accId = event.detail;
        let acc= this.accounts.data;
        console.log('acc-->'+acc);
        this.selectedAccount = acc.find(account => account.Id === accId);
    }

    get listIsNotEmpty() {
      
        return this.accounts && Array.isArray(this.accounts.data) && this.accounts.data.length > 0;
    }
}
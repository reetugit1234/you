import { LightningElement, api, track } from 'lwc';

export default class ContactRoles extends LightningElement {
    @track openNewModal = false;
    @track editContactRole = false;
    @api preList= this.wrapperList; 
    @track conLength= false;
    @track bodycom = false;
    gotoList(){
        let str= this.recordID;
        var bodycom=this.template.querySelector('[data id = "userform"]')

    }
    openModal() {
        this.openNewModal = true;
        this.editContactRole= true
    }
    closeModal() {
        this.openNewModal = false;
    } 
    saveMethod() {
        alert('save method invoked');
        this.closeModal();
    }
    doSearch(event)
    {
        
    }
}
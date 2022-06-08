/* eslint-disable no-console */
import { LightningElement,track,api,wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getTaskList from '@salesforce/apex/lightningComp1.getTaskList';
import updateTaskstatus from '@salesforce/apex/lightningComp1.updateTaskstatus';
// import LeadOnHover from 'c-lead-on-hover';
export default class CustomTaskComp extends LightningElement {

@api heading ="Today";
@track wiredContactsResult;
@track task=[];
@api textval='';
@track leadid;
@api optionsList = [{value : 'menuItemone' , label :'Today',checked : 'true' } , 
    {value : 'menuItemtwo' , label :'My Tasks' ,checked : 'false'} , 
        {value : 'menuItemthree' , label :'All Overdue' ,checked : 'false'} , 
            {value : 'menuItemfour' , label :'Completed Tasks' ,checked : 'false'} 
];

@wire(getTaskList, { filter: '$heading' })
wiredContacts(result) {
    // Hold on to the provisioned value so we can refresh it later.
    this.wiredContactsResult = result;
    
    if (result) 
    {  
        this.task=[];
        this.task = result.data;
        console.log('data---',result.data)
        if(result.data==='' || result.data== null || result.data==='undefined' || result.data=== null || result.data=== [])
        {
            console.log('first wire load');
        }
        else{
            if(result.data.length>0)
            {
                this.textval='';
                //alert('textval in if--->'+this.textval);
            }
            else
            {
                this.task=[];
                this.task='';
                if(this.heading ==='Today')
                {
                    this.textval='Nothing due today. Be a go-getter, and check back soon.';
                }
                else
                {
                    this.textval='  You don’t have any tasks in this list. Look in a different list, or create a task.';
                }
                //alert('textval in else--->'+this.textval);
            }
        }
    }
}   


handleSelect(event)
{
    console.log('value-->'+event.detail.value);
    this.optionsList.forEach(element => {
        element.checked='false';
    });
        let selectedValue = event.detail.value;
        let selectedObject  = this.optionsList.find(function(element){
        return element.value === selectedValue;
    });
        selectedObject.checked='true';
        console.log('selected Label ->' + selectedObject.label);
        this.heading=selectedObject.label;
        this.textval='';
        this.task=[];
        return refreshApex(this.wiredContactsResult);
    }
        
        getSelectedTask(event)
        {
        console.log('value in checkbox-->'+event.target.value);
        console.log('value in dataset id checkbox-->'+event.target.dataset.id);
        console.log('value in checkbox-->'+event.target.checked);
        const tskid=event.target.dataset.id;
        const status=event.target.value;
        console.log(this.tskid);
        updateTaskstatus({tskid,status})
        let targetId=event.target.dataset.id +'atag';
        if(event.target.checked)
        {
        this.template.querySelector(`[data-id="${targetId}"]`).classList.add('a-comp');}
        else
        {
        this.template.querySelector(`[data-id="${targetId}"]`).classList.remove('a-comp');
    }
        this.textval='';
        return refreshApex(this.wiredContactsResult);
    }
        
        showData(event){
        this.leadid=event.currentTarget.dataset.id;
        console.log(event.currentTarget.dataset.id);
        
    }
        hideData(event){
        this.leadid="";
        console.log(event.currentTarget.dataset.id);
        
    }
        
    }
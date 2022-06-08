({
    doInit : function(component, event, helper) {
        var action = component.get("c.GetCRRecords");
        action.setParams({ 
            accId: component.get("v.recordId")
            
        });
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();          
            if (state === "SUCCESS") {
                var rtdata=JSON.stringify(response.getReturnValue());              
                component.set('v.accConRoleList', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);        
    },
    deleteRole : function(component, event, helper) {
        
        var accRoleId = event.target.getAttribute('name'); 
        
        var action = component.get("c.EditDeleteContactRole");
        action.setParams({ 
            accRoleId: accRoleId,
            stat: 'del'
        });
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();          
            if (state === "SUCCESS") {
                console.log('returndata-->',response.getReturnValue());
                document.location.reload(true);
            }
        });
        $A.enqueueAction(action);    
    },
    viewAll : function(component, event, helper) {
        component.set('v.showAll',true);
    },
    viewLess : function(component, event, helper) {
        component.set('v.showAll',false);
    }    ,
    editRole : function(component, event, helper) {
        component.set('v.showModal',true);
        var action = component.get("c.GetPickVal");
        var inputsel = component.find("InputSelectRole");
        var opts=[];
        action.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            inputsel.set("v.options", opts);
            
        });
        var accRoleId = event.target.getAttribute('name');
        var action2 = component.get("c.EditDeleteContactRole");       
        
        action2.setParams({ 
            accRoleId:accRoleId,
            stat: 'Edit'
            
        });
        action2.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();          
            if (state === "SUCCESS") {
                console.log('returndata-->',response.getReturnValue());
                var resval=response.getReturnValue();
                component.set('v.selectedAccConRoleList',resval);
                component.set('v.editedPrimary',resval['IsPrimary']);
                component.set('v.editedRoleVal',resval['Role']);
            }
        });
        $A.enqueueAction(action); 
        $A.enqueueAction(action2); 
    },
    hideModal  : function(component, event, helper) {
        component.set('v.showModal',false);
    },
    openNewModal  : function(component, event, helper) {
        
        var calledFlow = component.get("v.calledFromFlow");
        console.log('calledFromFlow+++++'+ calledFlow);
        $A.createComponent(
            "c:NewcontactRoleModal",
            {"isOpenModal": true,
             "recordId": component.get("v.recordId"),
             "selectedContactOption": component.get("v.selectedContactOption"),
             "calledFromFlow":calledFlow, 
             "contactNameFilterCreteria": component.get("v.contactNameFilterCreteria")
            },
            function(newCmp){
                console.log('buk',newCmp);
                //Add the new compoennt
                if (component.isValid()) {
                    //  alert('in new');
                    component.set("v.body", newCmp);
                }
            }
        );
        
    },
    
    onRoleChange :function(component, event, helper) {
        var selectCmp = component.find("InputSelectRole");
        component.set("v.editedRoleVal", selectCmp.get("v.value"));
    }
    ,
    onPrimaryChange :function(component, event, helper) {
        var isChecked = component.find("checkboxprimaryss");
        component.set("v.editedPrimary", isChecked.get("v.value"));
    },
    saveEditedContactRole :function(component, event, helper) {
        var accRoleId = event.target.getAttribute('id');
        var action = component.get("c.UpdateContactRole");
        
        action.setParams({ 
            accId: component.get("v.recordId"),
            accRoleId: accRoleId,
            role: component.get("v.editedRoleVal"),
            isPrimary: component.get("v.editedPrimary")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();  
            
            if (state === "SUCCESS") {
                // console.log('returndata-->',response.getReturnValue());
                document.location.reload(true);
            }
        });
        $A.enqueueAction(action);
    }
    
})
({
    fetchAcc : function(component, event, helper) {
        helper.fetchAccHelper(component, event, helper);
    },
    openModel: function(component, event, helper) {
        component.set("v.isOpen", true);
    },
    
    closeModel: function(component, event, helper) { 
        component.set("v.isOpen", false);
    },
    handleRowAction: function (cmp, event, helper) 
    {
        var action = event.getParam('action');
        var row = event.getParam('row');
        cmp.set("v.paymentId", row.Id);
        cmp.set("v.ContactId", row.Contact__c );
        // console.log("paymentId: " + cmp.get("v.paymentId"));
        // console.log('action: ' + action.name + ' | ' + 'row: ' + JSON.stringify(row));
        switch (action.name) {
            case 'delete_payment':
                cmp.set("v.projectName", row.ProjectName);
                cmp.set("v.deleteActive", true);
                break;
            case 'edit_payment': 
                cmp.set("v.editActive", true);
                break;
        };
    },
    
})
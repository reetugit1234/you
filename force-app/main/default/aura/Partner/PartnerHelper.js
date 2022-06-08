({
    fetchAccHelper : function(component, event, helper) {
        component.set('v.mycolumns', [
            {label: 'IsPrimary', fieldName: 'IsPrimary', type: 'Boolean',editable: true},
            {label: 'Role', fieldName: 'Role', type: 'picklist',editable: true},
            {label: '', type: 'button', initialWidth: 50, typeAttributes:
                { label: { fieldName: 'actionLabel'},variant:"base", title: 'Edit', name: 'edit_payment', iconName: 'action:edit'}},
            {label: '', type: 'button', initialWidth: 50, typeAttributes:
                { label: { fieldName: 'actionLabel'},variant:"base", title: 'Delete', name: 'delete_payment', iconName: 'action:delete'}}

            
        ]);
        var action = component.get("c.fetchAccounts");
        action.setParams({
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.acctList", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})
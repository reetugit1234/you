({
    handlerInit: function(component, event, helper) {
        var ActivityDate = 'TODAY';
        var IsClosed = '';
        var Status = '';
        var OwnerId = '';
        var action = component.get("c.MyTaskList");
        console.log("action", action);
        action.setParams({
            "Owner": OwnerId,
            "Activity": ActivityDate,
            "Closed": IsClosed,
            "Stat": Status

        });
        action.setCallback(this, function(response) {

            var state = response.getState();
            console.log("hey", state);
            if (state === "SUCCESS") {
                console.log("HEY", response.getReturnValue());
                component.set("v.taskList", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);

    },

    myAction: function(component, event, helper) {
        var menuValue = event.detail.menuItem.get("v.value")
        var ActivityDate = '';
        var IsClosed = '';
        var Status = '';
        var OwnerId = '';
        console.log("VALUE", menuValue);
        component.set("v.list", menuValue);

        if (menuValue == "My Tasks") {
            console.log("MEY");
            OwnerId = '';
              
            IsClosed = '';
            Status = '';
            ActivityDate = '';
        } else if (menuValue == "Completed") {
            IsClosed = "true";
            ActivityDate = "LAST_N_DAYS:7 ";
            Status = '';
            OwnerId = '';
        } else if (menuValue == "Today") {
              ActivityDate =  "TODAY";
            IsClosed = '';
            Status = '';
            OwnerId = '';
          
        } else if (menuValue == "AllOverdue") {

            ActivityDate = '';
            OwnerId = '';
            IsClosed = '';
            Status = "Completed";
        }

        var action = component.get("c.MyTaskList");
        console.log("action", action);
        action.setParams({
            "Owner": OwnerId,
            "Activity": ActivityDate,
            "Closed": IsClosed,
            "Stat": Status

        });
        action.setCallback(this, function(response) {

            var state = response.getState();
            console.log("hayeee", state);
            if (state === "SUCCESS") {
                console.log("HEY", response.getReturnValue());
                component.set("v.taskList", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);

    }
})
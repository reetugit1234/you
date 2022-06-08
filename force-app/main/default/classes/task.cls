public with sharing class task {
@AuraEnabled(cacheable=true)
public static List< Task > MyTaskList(string Owner, string Activity, string Closed, string Stat) {
    string query = 'Select Id, Subject, ActivityDate From Task';
    system.debug('Owner' + Owner);
    if (string.isNotBlank(Owner)) {
        system.debug('OwnerId' + Owner);
        query += ' where  OwnerId  =: Owner';userinfo.getUserId();
        system.debug('QUERY' + query);
    } else if (string.isNotBlank(Activity) && string.isNotBlank(Closed)) {
        system.debug('Closed ' + Closed);
        
        query += ' where ActivityDate =' + Activity+ ' And IsClosed = '+ true ;
        system.debug('QUERY' + query);
    }
    else if (string.isNotBlank(Activity)) {
        system.debug('Activity overdue' + Activity);
        
        query += ' where ActivityDate =' + Activity;
        system.debug('QUERY' + query);

    } 
    

    else if (string.isNotBlank(Stat)) {
        system.debug('Stat ' + Stat);
        query += ' where Status !=: Stat';
        system.debug('QUERY' + query);
    
    }
    return MyTaskList(Owner, Activity, Closed, Stat);
    /*List < Task > taskList = Database.query(query);
        system.debug('TAskList' + taskList);
       return taskList;*/
 
}
}
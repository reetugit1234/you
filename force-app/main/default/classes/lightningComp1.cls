public with sharing class lightningComp1 {
    @AuraEnabled(cacheable=true)
    public static List<wrapperClass> getTaskList(String filter) {
        system.debug('filter-' +filter);
        List<Task> tsklist=new List<Task>();
        if(filter == 'Todays Tasks' || filter== 'Today') {
            tsklist= [SELECT Id,Subject,ActivityDate,Who.Name,lastmodifieddate,status,WhoId
                      FROM Task 
                      WHERE who.type='Lead' and ActivityDate=:system.today() AND IsClosed= false LIMIT 5];
            
        } 
        else if (filter == 'My Tasks') {
            tsklist= [SELECT Id,Subject,ActivityDate,Who.Name,OwnerId,lastmodifieddate,status,WhoId
                      FROM Task 
                      WHERE who.type='Lead' and OwnerId=:userinfo.getUserId() AND IsClosed = false LIMIT 5];
            
        } 
        else if(filter == 'Completed Tasks') {
            tsklist= [SELECT Id,Subject,ActivityDate,Who.Name,OwnerId,lastmodifieddate,status,WhoId
                      FROM Task 
                      WHERE who.type='Lead' and IsClosed= true LIMIT 5];
            
            
        } else if(filter == 'All Overdue') {
            Date todaydate = System.today();
            tsklist= [SELECT Id,Subject,ActivityDate,Who.Name,OwnerId,lastmodifieddate,status,WhoId
                      FROM Task 
                      WHERE who.type='Lead' and ActivityDate <: todaydate AND IsClosed= false LIMIT 5];
            
        }
        
        List<wrapperClass> wrapList=new List<wrapperClass>();
        for(Task t:tsklist)
        {
            wrapperClass obj=new wrapperClass();
            obj.tasklist=t;
            system.debug(System.today() +'  Status ' +t.Status);
            if((System.today() > t.ActivityDate) && t.Status!='Completed')
            {
                obj.flag=true;
                
            }
            else
            {
                obj.flag=false;
            }
            
            if(t.Status=='Completed')
            {
                obj.flagstatus=true;
            }
            else {
                obj.flagstatus=false;
            }
            
            obj.tagid=t.Id +'atag';
            obj.redirectlink='/lightning/r/Task/' + t.Id + '/view';
            obj.redirectLeadlink='/lightning/r/Lead/' + t.WhoId + '/view';
            Date d=t.ActivityDate;
            string AcD=DateTime.newInstance(d.year(),d.month(),d.day()).format('MMM dd');
            
            Date dt=System.today();
            string todaydate=DateTime.newInstance(dt.year(),dt.month(),dt.day()).format('MMM dd');
            Date dtyest=System.today().addDays(-1);
            string yesterdaydate=DateTime.newInstance(dtyest.year(),dtyest.month(),dtyest.day()).format('MMM dd');
            system.debug('AcD---'+AcD+'  yesterdaydate---'+yesterdaydate);
            Date dttMW=System.today().addDays(1);
            string tomorrowdate=DateTime.newInstance(dttMW.year(),dttMW.month(),dttMW.day()).format('MMM dd');
            system.debug('AcD---'+AcD+'  tomorrowdate---'+tomorrowdate);
            
            if( AcD==todaydate)
            {
                obj.datesetting='Today';
            }
            else if(AcD==yesterdaydate)
            {
                obj.datesetting='Yesterday';
            }
            else if(AcD==tomorrowdate)
            {
                obj.datesetting='Tomorrow';
            }
            else {
                obj.datesetting=  AcD;
            }
            system.debug('logLevel'+ obj.datesetting);
            wrapList.add(obj);
        }
        system.debug(wrapList);
        return wrapList;
        
    }
    @AuraEnabled
    public static String updateTaskstatus(String tskid,String status)
    {
        system.debug(tskid + status);
        string returnStr;
        try
        {
            Task task=[select  id,Status from Task   WHERE id =: tskid];
            
            if(status=='Completed')
            {
                task.Status='In Progress';
            }
            else
            {
                task.Status='Completed';
            }
            update task;
            returnStr='Status updated to '+ task.Status;
            
        }
        catch(Exception e) {
            
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            returnStr='An unexpected error has occurred: ' + e.getMessage();
        }
        return returnStr;
    }
    public class wrapperClass{
        @AuraEnabled public  Task tasklist{get;set;}
        @AuraEnabled public boolean flag{get;set;}
        @AuraEnabled public boolean flagstatus{get;set;}
        @AuraEnabled public String tagid{get;set;}
        @AuraEnabled public String redirectlink {get;set;}
        @AuraEnabled public String redirectLeadlink {get;set;}
        @AuraEnabled public String datesetting {get;set;}
        @AuraEnabled public Boolean noDatasetting {get;set;}
    }
}
/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This is the controller of the ContactRoleRelatedList Lightning component.
* Used to fetch data for AccountContactRole on Account's detail page
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
*/
public class ContactRoleRelatedListController {
    static transient Schema.DescribeSObjectResult contObjectDescribe; 
    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * This method retrieves data for the AccountContactRole related list
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    AccountId
    * @return   List<wrapperClass>   Account Contact Roles       
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    @AuraEnabled
    public static List<wrapperClass> GetCRRecords(String accId) {
        List<wrapperClass> wrapList=new List<wrapperClass>();
        
        for (AccountContactRole accContactRole : [SELECT Id, IsDeleted,Contact.AccountId,Contact.Account.Name, ContactId, Role, 
                                                  IsPrimary,Contact.Name,Contact.Email,Contact.Phone 
                                                  FROM AccountContactRole 
                                                  WHERE AccountId=:accId AND IsDeleted=false order by Contact.Name]) {

            wrapperClass obj = new wrapperClass();
            obj.acrList = accContactRole;
            
            if (accContactRole.IsPrimary) {                
                obj.Primaryflag = true;
            } else {                
                obj.Primaryflag=false;
            }            
            wrapList.add(obj);
        }      
        return wrapList;
    } 
    
    public class wrapperClass {
        @AuraEnabled public AccountContactRole acrList{get;set;}
        @AuraEnabled public boolean Primaryflag{get;set;}        
    }
    
    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * This method Edit or delete data on the AccountContactRole related list
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    AccountRoleId  Status--Delete/Edit
    * @return   sObject AccountContactRole   Account Contact Roles       
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    @AuraEnabled
    public static  AccountContactRole EditDeleteContactRole(String accRoleId,String stat) {
        AccountContactRole accConRole = new  AccountContactRole();
        accConRole = [SELECT Id, IsDeleted,Contact.AccountId,Contact.Account.Name, ContactId, Role, IsPrimary,Contact.Name,Contact.Email,Contact.Phone 
                      FROM AccountContactRole 
                      WHERE Id=:accRoleId AND IsDeleted=false  limit 1];        
        
        if (stat=='del') {            
            delete accConRole;            
        }        
        return accConRole;
    }
    
    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * This method Update Role/Primary feild data on the AccountContactRole related list
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    AccountRoleId  AccountId  Role  IsPrimary
    * @return   None       
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    @AuraEnabled
    public static  String UpdateContactRole(Id accId,Id accRoleId,String role,String isPrimary) {
        AccountContactRole accConRole = new  AccountContactRole();
        accConRole = [SELECT Id, IsDeleted,AccountId,Contact.Account.Name, ContactId, Role, IsPrimary,Contact.Name,Contact.Email,Contact.Phone 
                      FROM AccountContactRole 
                      WHERE  Id=:accRoleId and IsDeleted=false  limit 1];
        
        if (isPrimary=='true') {            
            List<AccountContactRole> accountContRole = [SELECT Id, IsDeleted,AccountId,Contact.Account.Name, ContactId, Role, IsPrimary,Contact.Name,Contact.Email,Contact.Phone 
                                                        FROM AccountContactRole 
                                                        WHERE AccountId=:accId and IsPrimary=true and IsDeleted=false LIMIT 1];

            if (!accountContRole.isEmpty()) {                
                accountContRole[0].IsPrimary=false;
            }
            accConRole.IsPrimary=true;
            } else {
                accConRole.IsPrimary=false;
            }
        
            accConRole.Role=role;
            try{
                update accConRole;    
            } catch(Exception e) {
                return e.getMessage();
            }
        return 'Success';
    }
    
    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * This method retrieved PickListValues of Role on AccountContactRole
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    NONE
    * @return   PickListValues       
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */    
    
    @AuraEnabled
    public static List<String> GetPickVal() {
        List<String> options = new List<String>();        
        Schema.DescribeFieldResult fieldResult = AccountContactRole.Role.getDescribe();  
        List<Schema.PicklistEntry> pickLstEntry = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry pickLstEnt: pickLstEntry) {
            options.add(pickLstEnt.getLabel());
        }        
        return options;
    }      
    
 
    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * This method the picklist values of the Roles field on the Account Contact Role object
    * ──────────────────────────────────────────────────────────────────────────────────────────────

    *  List<SelectOption>      ie Business user, Decision Maker, etc
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public static List<String> getRoles() {
        List<String> options = new List<String>();        
        Schema.DescribeFieldResult fieldResult =    AccountContactRole.Role.getDescribe();
        List<Schema.PicklistEntry> pickLstEntry = fieldResult.getPicklistValues();        
        for ( Schema.PicklistEntry picklstEnt  : pickLstEntry) {
            options.add(picklstEnt .getLabel());
        }       
        return options;
    }
    
    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * Returns object describe for related list object. This is used in many places so we are using 
    * a dedicated method that only invokes Schema describe calls once as these count against Apex 
    * limits. Because this method returns a DescribeSObjectResult all the get 
    * methods for this object can be used directly in Visualforce: {!objectDescribe.label}
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    String objectName               API Name of the Object where the Field Set is set
    * @return   List<Schema.FieldSetMember>     Fields included on the RelatedListFields set 
    *                                           for the related object
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public static DescribeSObjectResult getcontObjectDescribe() {
        if (contObjectDescribe == null) {
            contObjectDescribe = Schema.getGlobalDescribe().get('Contact').getDescribe();   
        }     
        return contObjectDescribe;    
    }
    /**
* ─────────────────────────────────────────────────────────────────────────────────────────────┐
* This method retrieves data for the AccountContactRole related list
* ──────────────────────────────────────────────────────────────────────────────────────────────
* @param    NONE
* @return   LIST<sObject>   Account Contact Roles       
* ─────────────────────────────────────────────────────────────────────────────────────────────┘
*/
    @AuraEnabled
    public static List<pageHelper> getOcrRecords( String parentFieldId,String objectName, 
                                                 String orderByFieldName, String contactId) { 
                                                     Map<String, Set<String>> filterMap = new Map<String, Set<String>>();
                                                     List<pageHelper> pageHelperToShow;
                                                     List<SObject> RecordsToShow;
                                                     string parentObjectName = 'Account';
                                                     Integer pageSize = 5;
                                                     Integer limitSize = 5;
                                                     Integer pageNumber = 1;
                                                     String sortDirection;
                                                     List<String> fieldNames;
                                                     String relatedListName = 'AccountContactRoles';
                                                     String sortByField = null;
                                                     Map<String,String> fieldSortDirectionMap = null;
                                                     List<SObject> AllRecords = new List<SObject>();
                                                     List<pageHelper> pageHelperList = new List<pageHelper> ();
                                                     Map<Id, List<roleHelper>> roleHelperMap;
                                                     Integer totalSize;
                                                     Integer counter = 0;
                                                     Map<String,String> fieldAlignMap;
                                                     Map<String,String> nameLabelMap;
                                                     Schema.DescribeSObjectResult contObjectDescribe;
                                                     
    // Proceed ONLY if pageHelperToShow is null or empty
    if (pageHelperToShow == null || pageHelperToShow.size() == 0) {                                                         
        RecordsToShow = new List<SObject>();
        pageHelperToShow = new List<pageHelper>();
        Boolean validationPass = true;
        Set<String> filterStrings = new Set<String>();
        // this variable will hold the query results
        sObject acc = new Account();
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SobjectType oType = gd.get(parentObjectName);
        acc = oType.newSObject();   
        //Ensure sortDirection attribute has value of 'asc' or 'desc'
        if (sortDirection != null && sortDirection != 'asc' && sortDirection != 'desc') {
            validationPass = false;
        }    
        //Ensure parentFieldId is not null
        if (parentFieldId == null) {
            validationPass = false;             
        }    
        //Proceed with returning the related list if validation passed
        if (validationPass == false) {
            return null;
        } else {
            fieldNames = new List<String>();        
            String queryString = 'SELECT Id, Name, (SELECT ContactId, Contact.Name, Contact.AccountId, Role, IsPrimary, Id FROM ' + relatedListName + ' '; 
                
            if (orderByFieldName != null) {
                queryString += ' order by ' + orderByFieldName;
            } else {
                queryString += ' order by IsPrimary';
            }
            //Add limit clause to end of the query
            queryString += ' limit ' + (Limits.getLimitQueryRows() - Limits.getQueryRows());            
            queryString += ') FROM '+ parentObjectName + ' WHERE Id = \'' + parentFieldId + '\' limit 1';        
            
            //Query records and setup standard set controller for pagination
            acc = Database.query(queryString);        
            AllRecords = acc.getSObjects(relatedListName); 

            if (AllRecords != null && AllRecords.size() > 0) {
                Map<Id, Set<String>> contactRolesMap = new Map<Id, Set<String>>();
                Map<Id, AccountContactRole> ocrMap = new Map<Id, AccountContactRole>();
                List<AccountContactRole> ocrRecords = new List<AccountContactRole>();
                pageHelperToShow = new List<pageHelper>();
                if (pageHelperList == null || pageHelperList.size() == 0) {
                    pageHelperList = new List<pageHelper>();
                    
                for (SObject record : AllRecords) {
                    ocrRecords.add((AccountContactRole) record);
                }
                for (AccountContactRole ocr : ocrRecords) {
                    if (contactRolesMap.containsKey(ocr.ContactId)) {
                        Set<String> temp = contactRolesMap.get(ocr.ContactId);
                        temp.add(ocr.Role);
                        contactRolesMap.put(ocr.ContactId, temp);
                    } else {
                        contactRolesMap.put(ocr.ContactId, new Set<String>{ocr.Role});
                    }
                    ocrMap.put(ocr.ContactId, ocr);
                }
                roleHelperMap = new Map<Id, List<roleHelper>>();

                for (Id i : ocrMap.keySet()) {
                    String tempString = '';
                    Set<String> contactRoles = contactRolesMap.get(i);
                    for (String s : contactRoles) {
                        tempString += s + ', ';
                    }
                    tempString = tempString.substring(0,tempString.length() - 2);
                    List<roleHelper> roles = new List<roleHelper>();
                    for (String s : getRoles()) {
                        if (contactRoles.contains(s)) {
                            roles.add(new roleHelper(s, true));    
                        } else {
                            roles.add(new roleHelper(s, false));    
                        }
                    }
                    roleHelperMap.put(i, roles);
                    pageHelperList.add(new pageHelper(i, ocrMap.get(i), tempString, contactRoles, contactRoles.size(), roles, ocrMap.get(i).isPrimary));
                }
                    totalSize = pageHelperList.size();
                }
                if (sortByField == null) {
                    pageHelperList.sort();    
                }
                //Intial adding of contacts to pageHelperToShow
                //check the total records are more than limitSize and assign the records
                if ((counter+limitSize) <= totalSize) {
                    for (Integer i=0;i<limitSize;i++) {
                        pageHelperToShow.add(pageHelperList.get(i));
                        RecordsToShow.add(pageHelperList.get(i).ocr);
                    }   
                } else {
                    for (Integer i=0;i<totalSize;i++) {
                        pageHelperToShow.add(pageHelperList.get(i));
                        RecordsToShow.add(pageHelperList.get(i).ocr);
                    }
                }
            }

            /*For the fields that will be displayed identify the field type and set styleClass for
            cell alignment. Numbers, Currency, %, etc should align right in table. put in map FieldName -> class name*/
            //Get the meta data info for the fields is the related object
            Map<String, Schema.SObjectField> fieldMap = getcontObjectDescribe().fields.getMap();                                                              
            //For the fields in the related list populate fieldAlignMap map with the name of the correct style class. Also populate name->label map for header display
            fieldAlignMap = new Map<String,String>();
            nameLabelMap = new Map<String,STring>();
                for (String fld : fieldNames) {
                    if (fld != 'Contact.RecordType.Name') {
                        String fieldType = fieldMap.get(fld.remove('Contact.')).getDescribe().getType().name();
                        
                        if (fieldType == 'CURRENCY' || fieldType == 'DOUBLE' || fieldType == 'PERCENT' || fieldType == 'INTEGER') {
                            fieldAlignMap.put(fld,'alignRight');
                        } else {
                            fieldAlignMap.put(fld,'alignLeft');
                        }                           
                        //Add to name->label map
                        String label = fieldMap.get(fld.remove('Contact.')).getDescribe().getLabel().remove(' ID');
                        if (label == 'Name') {
                            label = 'Contact Name';
                        }
                        if (label == 'Business Title') {
                            label = 'Job Description';
                        }
                        nameLabelMap.put(fld,label);
                    }  else{
                        fieldAlignMap.put(fld,'alignLeft');
                        nameLabelMap.put(fld,'Type');
                    }                
                }
            }
        }                                                     
        return pageHelperList;
    }
    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * This method updates the Primary Contact Role and refreshes the page
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    conroleid , isPrimary
    * 
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    @AuraEnabled
    public static String updatePrimaryContactRole(String conroleid, Boolean isPrimary) {
        AccountContactRole ocr = new AccountContactRole();
        ocr.Id = conroleid;
        ocr.IsPrimary = isPrimary;        
        try{            
            update ocr;       
        } catch(Exception e) {
            return e.getMessage();
        }        
        return 'SUCCESS';
    } 
    
    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * Wrapper class shown on the Contact Roles related list
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    Id                          contactId       Contact ID
    *           AccountContactRole      ocr             Account Contact Role
    *           String                      contactRoles    Roles of the Contact separated by comma
    *           Set<String>                 roleSet         Roles of the Contact in a Set
    *           Integer                     roleCount       Number of Roles of the Contact
    *           List<roleHelper>            roleHelpers     Used on the VF Page to display 
    *                                                       checkboxes of roles                                 
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public class pageHelper implements Comparable{
        @AuraEnabled public Id contactId {get;set;}
        @AuraEnabled public AccountContactRole ocr {get;set;}
        @AuraEnabled public String contactRoles {get;set;}
        @AuraEnabled public Set<String> roleSet {get;set;}
        @AuraEnabled public Integer roleCount {get;set;}
        @AuraEnabled public List<roleHelper> roleHelpers {get;set;}
        @AuraEnabled public Boolean isPrimary {get;set;}
        public pageHelper(Id contactId, AccountContactRole ocr, String contactRoles, Set<String> roleSet, 
                          Integer roleCount, List<roleHelper> roleHelpers, Boolean isPrimary) {
                              this.contactId = contactId;
                              this.ocr = ocr;
                              this.contactRoles = contactRoles;
                              this.roleSet = roleSet;
                              this.roleCount = roleCount;
                              this.roleHelpers = roleHelpers;
                              this.isPrimary = isPrimary;
                          }
        // This method enables the sorting of the List
        public Integer compareTo(Object objToCompare) {
            Boolean ascending = false;
            pageHelper compagePageHelper = (pageHelper)objToCompare;
            if (ocr.IsPrimary != compagePageHelper.ocr.IsPrimary) {
                return 1;
            } else {
                if (roleCount > compagePageHelper.roleCount) {
                    return ascending ? 1 : -1;
                } else if (roleCount < compagePageHelper.roleCount) {
                    return ascending ? -1 : 1;
                } else {
                    return 0;
                }        
            } 
        }
    }
    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * Wrapper class shown on the Contact Search table
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    Id                          contactId       Contact ID
    *           Contact                     contact         Contact Record
    *           List<roleHelper>            roleHelpers     Used on the VF Page to display 
    *                                                       checkboxes of roles                                 
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public class contactRoleHelper {
        @AuraEnabled public Id contactId {get;set;}
        @AuraEnabled public Contact contact {get;set;}
        @AuraEnabled public List<roleHelper> roleHelpers {get;set;}
        @AuraEnabled public Boolean isPrimary {get;set;}
        @Auraenabled public String rolesInString {get;set;}
        @Auraenabled public Boolean readyToCreate{get;set;}
        @Auraenabled public Integer totalRows{get;set;}
        public contactRoleHelper(Id contactId, Contact contact, List<roleHelper> roleHelpers, Boolean isPrimary, Integer totalRows) {
            this.contactId = contactId;
            this.contact = contact;
            this.roleHelpers = roleHelpers;
            this.isPrimary = isPrimary;
            this.readyToCreate = false;
            this.totalRows = totalRows;
        }
    }
    
    public class ContactRoleHelperMap{
        @AuraEnabled public String conId  ;
        @AuraEnabled public ContactRoleHelper conList;
        public ContactRoleHelperMap() {
            this.conId ='';
            this.conList = null;
        }
    }
    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * Wrapper class used to display Role checkboxes
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    String                      role            Role string
    *           Boolean                     checked         If Role is existing/selected                                
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public class roleHelper {
        @AuraEnabled public String role {get;set;}
        @AuraEnabled public boolean checked {get;set;}
        public roleHelper(String role, Boolean checked) {
            this.role = role;
            this.checked = checked;
        }
    }
    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * This method is called to display the Contact Search table
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    NONE                        
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */      
    
    @AuraEnabled
    public static List<ContactRoleHelper> runQueryRole(string selectedFilterContactRole, string parentFieldId, 
                                                       string selectedContactOption, string contactNameFilterCreteria, 
                                                       string offsetcon, string limitcon,String selectedContacts) {

        Map<String, Set<String>> filterMap = new Map<String, Set<String>>();
        List<String> searchfieldNames = new List<String>();
        Map<String,STring> searchNameLabelMap = new Map<String,STring>();
        String name = contactNameFilterCreteria;        
        Boolean selectedContactRolePrimary = false;
        Set<String> existingContacts = new Set<String>();
        Id accId = parentFieldId;
        List<ContactRoleHelper> contactRoleList = new List<ContactRoleHelper>();
        Map<String, ContactRoleHelper> contactRoleMap = new Map<String, ContactRoleHelper>();
        String offcon  = offsetcon;
        Integer offsetContacts =  Integer.valueof(offsetcon.trim()); 

        if (selectedContacts != null && selectedContacts != '' && selectedContacts != '{}') {
            Map<String, Object>  hopes2 = (Map<String, Object>)System.JSON.deserializeUntyped(selectedContacts);            
            for (String s: hopes2.keySet()) {                
                ContactRoleRelatedListController.ContactRoleHelper rhrrr = (ContactRoleRelatedListController.ContactRoleHelper)System.JSON.deserialize(System.JSON.serialize(hopes2.get(s)), ContactRoleRelatedListController.ContactRoleHelper.class);
                contactRoleMap.put(s, rhrrr);
            }            
        }               
        // Build soql query
        String soql = 'select Id, Contact.Account.Name,Name, ';
        String soqlCount = 'select count(Id)';        
        //Remove the very last comma that was added to the end of the field selection part of the query string
        soql = soql.substring(0,soql.length() - 2);        
        soql += ' from contact where account.name != null';
        soqlCount += ' from contact where account.name != null';
        // If name is not blank, add filter to the query
        if (name != null && !name.equals('')) {
            soql += ' and (Name LIKE \''+String.escapeSingleQuotes(name)+'%\' or LastName LIKE \''+String.escapeSingleQuotes(name)+'%\')';
            soqlCount += ' and (Name LIKE \''+String.escapeSingleQuotes(name)+'%\' or LastName LIKE \''+String.escapeSingleQuotes(name)+'%\')';
            
        }               
        if (selectedContactOption == 'This Account') {
            soql += ' and AccountId =: accId';
            soqlCount += ' and AccountId =: accId';
        }        
        List<pageHelper> pageHelperList = ContactRoleRelatedListController.getOcrRecords(parentFieldId, 'AccountContactRoles',  'IsPrimary', null);
        
        for (PageHelper ph : pageHelperList) {
            existingContacts.add(ph.ContactId);
        }        
        try {
            
            List<Contact> contacts = Database.query(soql + '  order by Name limit 5 OFFSET '+ offsetContacts);
            AggregateResult totalContacts = Database.query(soqlCount );
            Integer totalRows = Integer.valueOf(totalContacts.get('expr0'));
            
            for (Contact c : contacts) {
                List<roleHelper> rhList = new List<roleHelper>();
                
                for (String s : getRoles()) {
                    rhList.add(new roleHelper(s, false));
                }    
                if (totalRows == null) {
                    totalrows = contacts.size();
                }      
                
                ContactRoleHelper rhr = new contactRoleHelper(c.Id, c, rhList, false, totalrows);
                rhr.rolesInString = '';
                if (contactRoleMap != null && !contactRoleMap.isEmpty() && contactRoleMap.containsKey(c.Id)) {
                    rhr = contactRoleMap.get(c.Id);
                }
                contactRoleList.add(rhr);        
                contactRoleMap.put(c.Id, new ContactRoleHelper(c.Id, c, rhList, false, totalrows));                    
            }
        } catch (Exception e) {            
            //return e.getMessage();
        }        
        return contactRoleList;
    }
    
    @auraEnabled
    public static string createNewContactRoleLex(String parentId, String contactRoleListString) {
        List<AccountContactRole> newContactRoles = new List<AccountContactRole>();        
        Map<String, Object> contactRoleList = ( Map<String, Object> )JSON.deserializeUnTyped(contactRoleListString);        
        Map<Id, Set<String>> deleteMap = new Map<Id,Set<String>>();
        for (String s: contactRoleList.keySet()) {            
            ContactRoleRelatedListController.ContactRoleHelper cr = 
                (ContactRoleRelatedListController.ContactRoleHelper)System.JSON.deserialize(System.JSON.serialize(contactRoleList.get(s)), ContactRoleRelatedListController.ContactRoleHelper.class);
            if (cr.readyToCreate == true) {
                for (roleHelper rh : cr.roleHelpers) {
                    if (rh.checked) {
                        AccountContactRole ocr = new AccountContactRole();
                        ocr.ContactId = cr.contactId;
                        ocr.AccountId = parentId;
                        ocr.IsPrimary = cr.isPrimary;
                        ocr.Role = rh.role;
                        newContactRoles.add(ocr);                         
                    } else {
                        if (deleteMap != null) {
                            
                            Set<String> temp = deleteMap.get(cr.contactId);
                            if (temp == null) {
                                temp = new Set<String>();
                            }
                            temp.add(rh.role);
                            deleteMap.put(cr.contactId, temp);
                        }
                    }
                }           
            }
        }
        if (newContactRoles.size() > 0) {
            try{                
                Insert newContactRoles;                  
            } catch(Exception e) {                
                return e.getMessage();
            }
        }        
        return 'SUCCESS';        
    }     
}
public class ChangeSet {
    
    //get all apex classes
    @AuraEnabled(cacheable=true)
    public static List<Sobject> getData(String objectName){
        String query = 'SELECT Id,Name FROM '+ objectName + ' Order By lastmodifieddate';
        return Database.query(query);
    }
    
    //get all flows
    @AuraEnabled(cacheable=true)
    public static List<Sobject> getFlow(String objectName){
        String query = 'SELECT Id,Label, ProcessType FROM '+ objectName + ' Order By lastmodifieddate';
        return Database.query(query);
    }
    
    @AuraEnabled(cacheable=true)
    public static List<ChangesetWrapper> getMetaDataDetails(String objectName, List<String> alselid){
        List<ChangesetWrapper> warpperList = new List<ChangesetWrapper>();
        List<DependencyClassWrapper> dependencyWrapperList = new List<DependencyClassWrapper>();
        
        if(objectName == 'ApexClass'){
            for(ApexClass s:[SELECT Id,Name FROM ApexClass WHERE Id NOT IN: alselid Order By lastmodifieddate desc]){
                warpperList.add(new ChangesetWrapper(s.Id,s.Name,objectName,dependencyWrapperList));
            }       
        }else if(objectName == 'FlowDefinitionView'){
            for(FlowDefinitionView s:[SELECT Id,Label, ProcessType FROM FlowDefinitionView  Order By lastmodifieddate desc]){
                warpperList.add(new ChangesetWrapper(s.Id,s.Label,objectName,dependencyWrapperList));
            }
        }        
        return warpperList;
    }
    
    
    public class ChangesetWrapper{
        @AuraEnabled
        public Id Id{get;set;}
        @AuraEnabled
        public String Name{get;set;}
        @AuraEnabled
        public String MetadataType{get;set;}
        @AuraEnabled
        public List<DependencyClassWrapper> dependency{get;set;}   
        
        public ChangesetWrapper(Id Id,String Name,String MetadataType,List<DependencyClassWrapper> dependency){
            this.Id = Id;
            this.Name=Name;
            this.MetadataType=MetadataType;
            this.dependency=dependency;
        }
    }
    public class DependencyClassWrapper{
        @AuraEnabled
        public String Id{get;set;}
        @AuraEnabled
        public String Name{get;set;}
        @AuraEnabled
        public String MetadataType{get;set;}
        
        public DependencyClassWrapper(String Id,String Name,String MetadataType){
            this.Id = Id;
            this.Name=Name;
            this.MetadataType=MetadataType;
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<allObjectWrapper> getObjectDetails(){
        List < allObjectWrapper > options = new List < allObjectWrapper > ();
        for (Schema.SObjectType item1: Schema.getGlobalDescribe().values()) {
            String name = item1.getDescribe().getName();
            // Exclude all the unwanted Sobjects e.g. CustomSettings, History, Share, Feed, ApexClass, Pages etc..
            if (!item1.getDescribe().isCustomSetting() && item1.getDescribe().getRecordTypeInfos().size() > 0 && item1.getDescribe().isCreateable() &&
                !name.containsignorecase('history') && !name.containsignorecase('tag') && !name.containsignorecase('share') && !name.containsignorecase('feed')) {
                    options.add(new allObjectWrapper(item1.getDescribe().getName(), item1.getDescribe().getLabel()));
                }
        }
        options.add(new allObjectWrapper('Asset', 'Asset')); // Asset doesn't come-up, so explicitly add same.
        options.add(new allObjectWrapper('ApexClass', 'ApexClass'));
        options.add(new allObjectWrapper('FlowDefinitionView', 'FlowDefinitionView'));
        //options.sort();
        system.debug('options'+options);
        return options;
    }
    
    public class allObjectWrapper{
        
        @AuraEnabled
        public String value{get;set;}
        @AuraEnabled
        public String label{get;set;}
        
        public allObjectWrapper(String Name,String Label){
            
            this.value=Name;
            this.label=Label;
        }
    }
   
   /* @AuraEnabled
    public static List<ChangesetWrapper> getDependencies(String id){
        List<ChangesetWrapper> warpperDependencyList = new List<ChangesetWrapper>();
        string query='Select MetadataComponentId, MetadataComponentName, RefMetadataComponentName, RefMetadataComponentId,MetadataComponentType from MetadataComponentDependency where RefMetadataComponentId=\'id\'';
        query=query.replace('id', id);
        String result=callToolingApi(query);
        if(string.isNotBlank(result))
        {
          	DependentInfo data=DependentInfo.parse(result);
            system.debug('data.records'+data.records);
            for(DependentInfo.Record s:data.records){
               warpperDependencyList.add(new ChangesetWrapper(s.MetadataComponentId,s.MetadataComponentName,s.MetadataComponentType)); 
            }
          	return warpperDependencyList;
        }
        return null;
    }*/
     @AuraEnabled    
    public static  List<DependencyClassWrapper> getDependencies1(String id){
        List<DependencyClassWrapper> warpperDependencyList = new List<DependencyClassWrapper>();
        string query='Select MetadataComponentId, MetadataComponentName, RefMetadataComponentName, RefMetadataComponentId,MetadataComponentType from MetadataComponentDependency where RefMetadataComponentId=\'id\'';
        query=query.replace('id', id);
        String result=callToolingApi(query);
        if(string.isNotBlank(result))
        {
          	DependentInfo data=DependentInfo.parse(result);
            system.debug('data.records'+data.records);
            for(DependentInfo.Record s:data.records){
               warpperDependencyList.add(new DependencyClassWrapper(s.MetadataComponentId,s.MetadataComponentName,s.MetadataComponentType)); 
            }
        }
        return warpperDependencyList;
    }
 
    
    @AuraEnabled
    public static String callToolingApi(String query){
        query = query.replace(' ', '+');
        System.debug('callout:ToolingRest?q='+query);
        Http http=new Http();
        HttpRequest request=new HttpRequest();
        request.setEndpoint('callout:ToolingRest?q='+query);
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        request.setTimeout(60000);
		HttpResponse response=http.send(request);
        system.debug('response--->'+response.getBody());
        return response.getBody();      
    } 
   /* 
    public class ChangesetDependencyWrapper{
        @AuraEnabled
        public Id Id{get;set;}
        @AuraEnabled
        public String Name{get;set;}
        @AuraEnabled
        public String MetadataComponentType{get;set;}
        
        public ChangesetDependencyWrapper(Id Id,String Name,String MetadataType){
            this.Id = MetadataComponentId;
            this.Name=MetadataComponentName;
            //this.MetadataType=MetadataType;
        }
    }*/
    @AuraEnabled
    public static String ChangesetApi(){
        HttpRequest req = new HttpRequest();
        String query='select+Id,Name+from+Account';
        req.setEndpoint('callout:ChangesetREST?q='+query);
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        req.setTimeout(60000);
        Http http = new Http();
        HTTPResponse resp = http.send(req);
        system.debug('Body---> Chnageset REST-->:'+resp.getBody());
        return resp.getBody();
        
    }
}

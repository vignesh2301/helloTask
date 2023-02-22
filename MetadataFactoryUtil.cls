public with sharing class MetadataFactoryUtil {
    public string zipFile{set;get;}
    
    //@future
    @RemoteAction
    public static String checkRetrieveStatus(String asyncProcessId,Boolean includeZip) {
        MetadataFactory.MetadataOutlet port = getPort();
        
        MetadataFactory.RetrieveResult result = port.checkRetrieveStatus(asyncProcessId, includeZip);
        
        System.debug('checkRetrieveStatus------>'+result.zipFile);
        
        // GitHubIntegration
        //GitHubIntegration.createGitHubIssue(result.zipFile);
        MyApexClass.postToGitHub(result.zipFile);
        
        return result.zipFile;
    }
    
    public class RetriveMetadataWrapper{
        @AuraEnabled
        public String MetadataType{get;set;}
        @AuraEnabled
        public List<String> Name{get;set;}
    }
 
    @AuraEnabled
    public static String retrieve_x(String jsonString) {
        system.debug('jsonString 1--->'+jsonString);
        
        List<RetriveMetadataWrapper> values = (List<RetriveMetadataWrapper>)JSON.deserialize(jsonString,List<RetriveMetadataWrapper>.class);
        system.debug('jsonString 2--->'+values);
        
        // GitHubIntegration
        //GitHubIntegration.createGitHubIssue(jsonString);
        
        MetadataFactory.MetadataOutlet port = getPort();        
       
        MetadataFactory.PackageTypeMembers[] types = new MetadataFactory.PackageTypeMembers[]{};   
            for(RetriveMetadataWrapper data:values){
                MetadataFactory.PackageTypeMembers member = new MetadataFactory.PackageTypeMembers();   
                member.name=data.MetadataType;
                member.members=new List<String>(data.Name);
                types.add(member);
            }
        System.debug('types'+types.size());
        
        
        MetadataFactory.Package_x pkg = new MetadataFactory.Package_x();
        pkg.types = types;
        
        MetadataFactory.RetrieveRequest r = new MetadataFactory.RetrieveRequest();
        r.apiVersion = 54.0;
        r.unpackaged = pkg;
        r.packageNames = new String[]{};
        r.singlePackage = true;
        r.specificFiles = new String[]{};
       
        System.debug('session ID'+port.SessionHeader.sessionid);
        MetadataFactory.AsyncResult result = port.retrieve_x(r);
        
        System.debug(result.id);
        System.debug(result.state);
        
        MetadataFactoryUtil.checkRetrieveStatus(result.id, true);
        
        return result.id;
    }
    
    public static void deploy(){
        String zipFile =MetadataFactoryUtil.checkRetrieveStatus('09S5j000006OvMkEAK',true);
        MetadataFactory.MetadataOutlet port = getPort();
        MetadataFactory.DeployOptions deployOptions = new MetadataFactory.DeployOptions();
        deployOptions.performRetrieve = false;
        deployOptions.rollbackOnError=true;
        MetadataFactory.AsyncResult deployResult = port.deploy(zipFile, DeployOptions);		
    }
    @AuraEnabled
    public static MetadataFactory.MetadataOutlet getPort() {
        MetadataFactory.SessionHeader_element sheader = new MetadataFactory.SessionHeader_element();
        sheader.sessionid = UserInfo.getSessionId();
        MetadataFactory.AllOrNoneHeader_element aonHeader= new MetadataFactory.AllOrNoneHeader_element();
        aonHeader.allOrNone = true;
        
        MetadataFactory.MetadataOutlet port = new MetadataFactory.MetadataOutlet();
        port.SessionHeader = sheader;
        port.AllOrNoneHeader = aonHeader;
        return port;
    }  
    
     public static String retrieve() {
      
         MetadataFactory.MetadataOutlet port = getPort();        
         MetadataFactory.PackageTypeMembers member = new MetadataFactory.PackageTypeMembers();   
         
         member.name='ApexClass';
         member.members=new String[]{'ChangeSet'};        
         
             MetadataFactory.PackageTypeMembers[] types = new MetadataFactory.PackageTypeMembers[]{member};   
          MetadataFactory.Package_x pkg = new MetadataFactory.Package_x();
         pkg.types = types;
         
        MetadataFactory.RetrieveRequest r = new MetadataFactory.RetrieveRequest();
        r.apiVersion = 54.0;
        r.unpackaged = pkg;
        r.packageNames = new String[]{};
        r.singlePackage = true;
        r.specificFiles = new String[]{};
            
        MetadataFactory.AsyncResult result = port.retrieve_x(r);
        
        System.debug(result.id);
        System.debug(result.state);
        
        //MetadataFactoryUtil.checkRetrieveStatus(result.id, true);
        
        return result.id;
    }
}

public with sharing class GitHubIntegration {
    
    public String body{set;get;}
    
    public void getCommits(String zipfile){
        Http http=new http();
        
        HttpRequest request=new HttpRequest();
        request.setEndpoint('callout:Github_Changeset_Commit');
        request.setMethod('GET');
        
        HttpResponse response=http.send(request);
        String body=response.getBody();        
        system.debug('body'+(body));               
    }
    
}
    /*public static final String GITHUB_API_URL = 'https://api.github.com';
    public static final String GITHUB_USERNAME = 'vigneshdsalesforce@gmail.com';
    public static final String GITHUB_REPO_NAME = 'changeset';
    public static final String GITHUB_AUTH_TOKEN = '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';
    
    public class RetriveMetadataWrapper{
        @AuraEnabled
        public String MetadataType{get;set;}
        @AuraEnabled
        public List<String> Name{get;set;}
    }
    
    @future(callout=true)
    public static void createGitHubIssue(String body) {
        String endpoint = GITHUB_API_URL + '/repos/' + GITHUB_USERNAME + '/' + GITHUB_REPO_NAME + '/issues';
        System.debug(endpoint);
        //List<RetriveMetadataWrapper> values = (List<RetriveMetadataWrapper>)JSON.deserialize(body,List<RetriveMetadataWrapper>.class);
        //system.debug('jsonString 2--->'+values);
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Authorization', 'token ' + GITHUB_AUTH_TOKEN);
        request.setHeader('Content-Type', 'application/json');
        
        //Map<String, Object> issue = new Map<String, Object>();
        //issue.put('title', title);
        //issue.put('body', values);
        
        system.debug('endpoint'+endpoint);
        system.debug('body'+body);
        //system.debug('title'+title);
        //system.debug('issue'+issue);
        
        //String requestBody = JSON.serialize(values);
        request.setBody(body);
        
        Http http = new Http();
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() >= 400) {
            throw new GitHubIntegrationException('Failed to create GitHub issue: ' + response.getBody());
        }
    }
    
    public class GitHubIntegrationException extends Exception {}
}*/

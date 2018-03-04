@isTest
global class AAZ_GenericCallOutMock_mck implements HttpCalloutMock { 

    protected Integer code;
    protected String status;
    protected String body;
    protected Map<String, String> responseHeaders;

    global AAZ_GenericCallOutMock_mck(Integer code, String status, String body, Map<String, String> responseHeaders) {
        this.code = code;
        this.status = status; 
        this.body = body;
        this.responseHeaders = responseHeaders;
    }
    
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        for (String key : this.responseHeaders.keySet()) {
            res.setHeader(key, this.responseHeaders.get(key));
        }
        
        res.setBody(this.body);
        res.setStatusCode(this.code);
        res.setStatus(this.status);
        System.debug('valor' + res);
        return res;
        
    }

}
//
//  ViewController.m
//  HttpClientTest
//
//  Created by Vanja Komadinovic on 10/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "MAPSDK.h"
#import <Foundation/NSDictionary.h>

@implementation ViewController

//SERVER TO USE GOES HERE - MAKE SURE THE SERVER CERTIFICATE IS TRUSTED!
//NSString *url = @"https://giving.mapdemo.mocana.com/_trust/#";

NSString *url = @"https://www.mocana.com/";

//Global Variables
@synthesize mBrowser;
@synthesize progLabel;
NSMutableData *webdata;
NSNumber *recievedBytes;
NSNumber *payloadExpectedSize;
float progress;
NSMutableString *labelText;
NSInteger authChallengeCount = 0;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //a little fit and finish for hiding the status bar
    shouldHideStatusBar = YES;
    //set the browser delegate as itself
    mBrowser.delegate = self;
    //clear the old URL cache - not sure this is necesssary but just in case
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    //more cache killing - just in case there are leftovers from previous authentications to the site
    /**
    NSURLCredentialStorage *store = [NSURLCredentialStorage sharedCredentialStorage];
    if(store !=nil){
        for(NSURLProtectionSpace *protectionSpace in [store allCredentials]){
            NSDictionary *map = [[NSURLCredentialStorage sharedCredentialStorage]
                                 credentialsForProtectionSpace:protectionSpace];
            if(map!=nil){
                for(NSString *user in map){
                    NSURLCredential *cred = [map objectForKey:user];
                    [store removeCredential:cred forProtectionSpace:protectionSpace];
                }
            }
        }
    }
    **/
    //Log that we are attempting to make our first connection.
    NSLog(@"#################################");
    NSLog(@"Sending a request async");
    NSLog(@"\n");
    
    labelText = [NSMutableString stringWithFormat:@"INIT REQUEST"];
    
    progLabel.text = labelText;
    
    //create a request with the URL we defined at the top of the app
    //and execute the request
    NSURL *requestUrl = [[NSURL alloc] initWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    NSLog(@"#################################");
    NSLog(@"Connection Start Was Called");
    NSLog(@"\n");
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self.mBrowser stopLoading];
  
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}


- (void)connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"#################################");
    NSLog(@"Response recieved - now look for the\nnext log message to see if we received\na challenge!");
    NSLog(@"");

    //since we got a response, lets create an object to save data to
    webdata = [[NSMutableData alloc] init];
    
    //get expected size of the page & loaded data for a progress indicator
    payloadExpectedSize = [NSNumber numberWithFloat:response.expectedContentLength];
    
    labelText = [NSMutableString stringWithFormat:@"RESP RECEIVED!"];
    
    progLabel.text = labelText;
    
    
}

- (void)connection:(NSURLConnection*) connection didReceiveData:(NSData *)data
{
    
    //if the connection is also receiving data, then start saving that to the previous object "webdata"
    if(data){
    NSLog(@"#################################");
    NSLog(@"Data was recieved!");
    NSLog(@"");
        //start storing the response data into webdata
        [webdata appendData:data];
        
        NSLog(@"Response retrieved async!");
        
        //track download progress
        //get the count of bytes already recieved
        recievedBytes = [NSNumber numberWithFloat:webdata.length ];
        //divide the recieved bytes into the expected size from didRecieveResponse method
        //and multiply by 10 to get a percentage
        
        progress = ([recievedBytes floatValue] / [payloadExpectedSize floatValue] * 10.0f);
        
        labelText = [NSMutableString stringWithFormat:@"%f", progress];
        
        progLabel.text = labelText;
        
        
    };

    //if there is no data, display a message
    if(!data){
        NSLog(@"#################################");
        NSLog(@"No Data In The Response!");
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                        initWithTitle:@"Web Response"
                                        message:@"No Response from Server"
                                        delegate:nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
        // Display the Hello World Message
        [errorAlert show];
        
    };

    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    

    NSLog(@"#################################");
    NSLog(@"Authentication challenge");
    NSLog(@"\n");
    authChallengeCount = authChallengeCount + 1;
    NSLog(@"Auth Challenges = %i", authChallengeCount);
    
    /**previous load cert
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"p12"];
    NSData *p12data = [NSData dataWithContentsOfFile:path];
    CFDataRef inP12data = (__bridge CFDataRef)p12data;
    **/
    
    //KCHAMP
    SecIdentityRef myIdentity = MAP_getUserIdentityCertificate();
    BOOL hasCertificate = MAP_hasUserIdentityCertificate();
    NSLog(@"HAS_CERTIFICATE = %i", hasCertificate);
    NSLog(@"CERTIFICATE PTR = %p", myIdentity);
    
    
    NSLog(@"#################################");
    
    NSLog(@"Creating SecCertificateRef Object");
    
    if (hasCertificate){
        
        SecCertificateRef myCertificate;
        SecIdentityCopyCertificate(myIdentity, &myCertificate);
        const void *certs[] = { myCertificate };
        CFArrayRef certsArray = CFArrayCreate(NULL, certs, 1, NULL);
        
        NSLog(@"#################################");

        NSLog(@"Creating Credential Object");
        
        NSURLCredential *credential = [NSURLCredential credentialWithIdentity:myIdentity certificates:(__bridge NSArray*)certsArray persistence:NSURLCredentialPersistencePermanent];
        
        CFStringRef summary = SecCertificateCopySubjectSummary(myCertificate);
       
        NSString *certInfo = [NSString stringWithFormat:@"Performing Cert Auth For \n%@", summary];
        
        progLabel.text = certInfo;
        
        
        [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
      
        NSLog(@"SENT CERTIFICATE TO CHALLENGE");
        
        labelText = [NSMutableString stringWithFormat:@"CERT CHALLENGE SENT"];
        
        progLabel.text = labelText;
     
    }
    
    else {
        labelText = [NSMutableString stringWithFormat:@"NO MAP CERT!"];
        
        progLabel.text = labelText;

    }
    
}

- (void)connection:(NSURLConnection*) connection didFailWithError:(NSError *)error
{
    NSLog([NSString stringWithFormat:@"Did recieve error: %@", [error localizedDescription]]);
    NSLog([NSString stringWithFormat:@"%@", [error userInfo]]);
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return YES;
}
//KCHAMP - loading data into Webview
-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Finished Recieving Data");
    //remove label
    [progLabel setHidden:YES];
    //try to load view
    NSURL *requestUrl = [[NSURL alloc] initWithString:url];
    //loading the base URL again - NEEDED so relative response isnt broken
    [mBrowser loadData:webdata MIMEType: @"text/html" textEncodingName: @"UTF-8" baseURL: requestUrl];

    
}




OSStatus extractIdentityAndTrust(CFDataRef inP12data, SecIdentityRef *identity, SecTrustRef *trust)
{
    OSStatus securityError = errSecSuccess;
    
    CFStringRef password = CFSTR("userA");
    const void *keys[] = { kSecImportExportPassphrase };
    const void *values[] = { password };
    
    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import(inP12data, options, &items);
    
    if (securityError == 0) {
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex(items, 0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemIdentity);
        *identity = (SecIdentityRef)tempIdentity;
        const void *tempTrust = NULL;
        tempTrust = CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemTrust);
        *trust = (SecTrustRef)tempTrust;
    }
    
    if (options) {
        CFRelease(options);
    }
    
    return securityError;
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    
    NSLog(@"**Going into custom cache response**");
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)[cachedResponse response];
    
    // Look up the cache policy used in our request
    if([connection currentRequest].cachePolicy == NSURLRequestUseProtocolCachePolicy) {
        NSDictionary *headers = [httpResponse allHeaderFields];
        NSString *cacheControl = [headers valueForKey:@"Cache-Control"];
        NSString *expires = [headers valueForKey:@"Expires"];
        if((cacheControl == nil) && (expires == nil)) {
            NSLog(@"server does not provide expiration information and we are using NSURLRequestUseProtocolCachePolicy");
            return nil; // don't cache this
        }
    }
    //return cachedResponse;
    return nil;
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end

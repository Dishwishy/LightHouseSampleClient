//
//  ViewController.h
//  HttpClientTest
//
//  Created by Vanja Komadinovic on 10/19/11.
//  Updated by Kyle Champlin on 12/01/14
//

#import <UIKit/UIKit.h>
#import <Security/Security.h>
#import <CoreFoundation/CoreFoundation.h>

@interface ViewController : UIViewController <UIWebViewDelegate, UITextViewDelegate, UIGestureRecognizerDelegate, NSURLConnectionDelegate>{
    BOOL shouldHideStatusBar;
    BOOL isDone;
    NSURLConnection *connection;
    NSURLRequest *req;
}

//@property(nonatomic, retain) IBOutlet UILabel *status;
//@property(nonatomic, retain) IBOutlet UITextView *response;
//@property(nonatomic, retain) IBOutlet UITextField *url;
@property (strong, nonatomic) IBOutlet UIWebView *mBrowser;
@property (strong, nonatomic) IBOutlet UILabel *progLabel;
@property (strong, nonatomic) IBOutlet UITextField *urlBar;



- (void)sendUrlRequest;

- (void)handleTapGesture:(UITapGestureRecognizer *)sender;




@end

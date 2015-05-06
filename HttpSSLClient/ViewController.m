//
//  ViewController.m
//  HttpClientTest
//
//  Created by Vanja Komadinovic on 10/19/11.
//  Updated by Kyle Champlin on 12/01/14
//

#import "ViewController.h"

#import <Foundation/NSDictionary.h>

@implementation ViewController

//SERVER TO USE GOES HERE - MAKE SURE THE SERVER CERTIFICATE IS TRUSTED!
NSString *url = @"https://gilbert.mocana.local";

NSString *url;
NSInteger urlShow = 0;
//Global Variables
@synthesize mBrowser;
NSMutableData *webdata;
NSNumber *recievedBytes;
NSNumber *payloadExpectedSize;
float progress;
NSMutableString *labelText;
NSInteger authChallengeCount = 0;
@synthesize urlBar;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
 
    
    //set the browser delegate as itself
    mBrowser.delegate = self;
    //get our credential
    
    
    
    //tap gesture recognizer
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired = 3;
    [self.view addGestureRecognizer:tapGesture];

    
    //PLIST LOADING
    NSString *plistContents = [[NSBundle mainBundle] pathForResource:@"urls" ofType:@"plist"];
    NSDictionary *urlDict = [[NSDictionary alloc]initWithContentsOfFile:plistContents];
    url = [urlDict objectForKey:@"webpage"];

    if ( [urlDict objectForKey:@"webpage"] != @"" ){
       self.urlBar.hidden = YES;
            [mBrowser loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        
    }
    
    else{
        NSLog(@"No Valid URL, waiting for input");
        [self animateUrlBarIn];

        
    }

    
	// Do any additional setup after loading the view, typically from a nib.
    //a little fit and finish for hiding the status bar
    shouldHideStatusBar = YES;

    [mBrowser loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];

 
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
  
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


- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    url = self.urlBar.text;
    [self.urlBar resignFirstResponder];

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [self animateUrlBarOut];
    self.urlBar.hidden = YES;

}


- (IBAction)urlBar:(id)sender {
    
    NSLog(@"Will implement later");
    [mBrowser loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: urlBar.text]]];
    
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    
       if (sender.state == UIGestureRecognizerStateRecognized) {
           
        self.urlBar.hidden = NO;
        [self animateUrlBarIn];
                
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{

    return YES;
}

- (void)animateUrlBarIn
{
    self.urlBar.hidden = NO;
    [UIView beginAnimations:@"Animation" context:NULL];
    // Assumes the your view is just off the bottom of the screen.
    self.urlBar.frame = CGRectOffset(self.urlBar.frame, 0, +self.urlBar.frame.size.height);
    [UIView commitAnimations];
}

- (void)animateUrlBarOut
{
    [UIView beginAnimations:@"Animation" context:NULL];
    // Assumes the your view is just off the bottom of the screen.
    self.urlBar.frame = CGRectOffset(self.urlBar.frame, 0, -self.urlBar.frame.size.height);
    [UIView commitAnimations];
}



@end

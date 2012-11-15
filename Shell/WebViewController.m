//
//  WebViewController.m
//  Shell
//
//  Created by Gautham on 09/11/12.
//  Copyright (c) 2012 Gautham. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController
@synthesize mWebView;
@synthesize myAppDelegate;
@synthesize SingletonInstance;
@synthesize myWebViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    if(!mWebView)
        mWebView = [[UIWebView alloc] init];
    
    myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    SingletonInstance = [myAppDelegate getSingletonInstance];
    NSString *_URL,*_Form;
    NSURL *myURL;
    
    _URL = [SingletonInstance getCurrentURL];
    _Form = [SingletonInstance getCurrentForm];
    myURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",_URL,_Form]];
    // myURL = [NSURL URLWithString:@"http://en.wikipedia.org/w/index.php?title=Main_page&action=raw"];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:myURL];
    mWebView.delegate = self;
    [mWebView loadRequest:requestObj];
    [self.view setUserInteractionEnabled:TRUE];
    
    // [mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"testhtml" ofType:@"html"]isDirectory:NO]]];
    
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"page is loading");
    NSString *_URL,*_Form;
    
    _URL = [SingletonInstance getCurrentURL];
    _Form = [SingletonInstance getCurrentForm];
    _URL = [NSString stringWithFormat:@"Loading Page... \n%@?%@",_URL,_Form];

    [[[iToast makeText:_URL interface:TRUE] setDuration:2] show];

}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"finished loading");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"page failed to load with error:%@",error);
    [[[iToast makeText:@"Page Failed to Load, taking back to Main Screen" interface:TRUE] setDuration:3] show];
    [self.view setUserInteractionEnabled:FALSE];
    [self performSelector:@selector(dismisstheView) withObject:nil afterDelay:2];
}
-(void)dismisstheView
{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"page shouldStartLoadWithRequest:%@ and navigationType:%d absoluteURL:%@ ",request,navigationType,[[request URL] absoluteString]);
    
    NSLog(@"scheme: %@", [[request URL] scheme]);
    NSLog(@"host: %@", [[request URL] host]);
    NSLog(@"port: %@", [[request URL] port]);
    NSLog(@"path: %@", [[request URL] path]);
    NSLog(@"path components: %@", [[request URL] pathComponents]);
    NSLog(@"parameterString: %@", [[request URL] parameterString]);
    NSLog(@"query: %@", [[request URL] query]);
    NSLog(@"fragment: %@", [[request URL] fragment]);
    [[[iToast makeText:@"Navigating Pages" interface:TRUE] setDuration:2] show];
    //Parse and find action "exit"
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *param in [[[request URL] query] componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
    }
    NSLog(@"Params for action:%@",[params objectForKey:@"action"]);
    NSString *actionString =  [params objectForKey:@"action"];
    NSRange textRange;
    textRange =[actionString rangeOfString:@"exit"];
    if(textRange.location != NSNotFound && actionString )
    {
        [[[iToast makeText:@"Exit action found, taking back to Main Screen" interface:TRUE] setDuration:3] show];
        [self.view setUserInteractionEnabled:FALSE];
        [self performSelector:@selector(dismisstheView) withObject:nil afterDelay:2];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

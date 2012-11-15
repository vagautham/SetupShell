//
//  ViewController.m
//  Shell
//
//  Created by Gautham on 09/11/12.
//  Copyright (c) 2012 Gautham. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize url,form,load;
@synthesize txt_form,txt_url;
@synthesize btn_load;
@synthesize urlValue,formValue;
@synthesize myAppDelegate;
@synthesize SingletonInstance;
@synthesize myWebViewController;
@synthesize currentIPAddress;

- (void)viewDidLoad
{
    [super viewDidLoad];
    myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    SingletonInstance = [myAppDelegate getSingletonInstance];
    currentIPAddress = [self getIPAddress];
    txt_url.text = @"http://silver-lining.dynamite.myharmony.com/mobile";
    if([currentIPAddress isEqualToString:@"error"])
        txt_form.text = [NSString stringWithFormat:@"lang=%@-%@",[SingletonInstance getCurrentlang],[SingletonInstance getCurrentCCode]];
    else
        txt_form.text = [NSString stringWithFormat:@"lang=%@-%@&hub=%@",[SingletonInstance getCurrentlang],[SingletonInstance getCurrentCCode],currentIPAddress];
	// Do any additional setup after loading the view, typically from a nib.
}

- (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

-(IBAction)btn_loadTap:(id)sender
{
    if(!myAppDelegate)
        myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *_URL,*_Form;
    
    if([txt_url.text length]>0)
        _URL = [NSString stringWithString:txt_url.text];
    else
        _URL = [NSString stringWithString:txt_url.placeholder];
    
    if([txt_form.text length]>0)
        _Form = [NSString stringWithString:txt_form.text];
    else
        _Form = @"";
    
    
    NSArray *components = [_URL componentsSeparatedByString:@"?"];
    if([components count] >1)
    {
        _URL = [components objectAtIndex:0];
        _Form = [NSString stringWithFormat:@"%@&%@",[components objectAtIndex:1],_Form];
    }
    BOOL status = [SingletonInstance appendCurrentURL:_URL andForm:_Form];
    
    if(!status)
        [SingletonInstance appendCurrentURL:@"https://www.google.co.in" andForm:@" "];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        if(!myWebViewController)
            myWebViewController = [[WebViewController alloc] initWithNibName:@"WebViewController-iPhone" bundle:nil];
    } else {
        if(!myWebViewController)
            myWebViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    }
    
    [self presentViewController:myWebViewController animated:TRUE completion:nil];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
   if(txt_url == textField)
       txt_url.placeholder = @"https://www.google.co.in";
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(txt_url == textField && [txt_url.text length] == 0)
        txt_url.placeholder = @"https://www.google.co.in";
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

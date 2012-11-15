//
//  ViewController.h
//  Shell
//
//  Created by Gautham on 09/11/12.
//  Copyright (c) 2012 Gautham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "WebViewController.h"
#import "Singleton.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

@interface ViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UILabel *url;
    IBOutlet UILabel *form;
    IBOutlet UILabel *load;
    
    IBOutlet UITextField *txt_url;
    IBOutlet UITextField *txt_form;
    
    IBOutlet UIButton *btn_load;

    NSString *urlValue;
    NSString *formValue;
    NSString *currentIPAddress;

    AppDelegate *myAppDelegate;
    Singleton *SingletonInstance;
    
    WebViewController *myWebViewController;

}

@property(nonatomic, strong) UILabel *url;
@property(nonatomic, strong) UILabel *form;
@property(nonatomic, strong) UILabel *load;

@property(nonatomic, strong) UITextField *txt_url;
@property(nonatomic, strong) UITextField *txt_form;

@property(nonatomic, strong) UIButton *btn_load;

@property(nonatomic, strong) NSString *urlValue;
@property(nonatomic, strong) NSString *formValue;
@property(nonatomic, strong) AppDelegate *myAppDelegate;
@property(nonatomic, strong) Singleton *SingletonInstance;
@property(nonatomic, strong) WebViewController *myWebViewController;

@property(nonatomic, strong) NSString *currentIPAddress;

-(IBAction)btn_loadTap:(id)sender;
- (NSString *)getIPAddress;

@end

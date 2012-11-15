//
//  WebViewController.h
//  Shell
//
//  Created by Gautham on 09/11/12.
//  Copyright (c) 2012 Gautham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "WebViewController.h"
#import "Singleton.h"
#import "iToast.h"

@interface WebViewController : UIViewController<UIWebViewDelegate>
{
   IBOutlet UIWebView *mWebView;
    
    AppDelegate *myAppDelegate;
    Singleton *SingletonInstance;
    
    WebViewController *myWebViewController;
}

@property(nonatomic,strong) UIWebView *mWebView;

@property(nonatomic, strong) AppDelegate *myAppDelegate;
@property(nonatomic, strong) Singleton *SingletonInstance;
@property(nonatomic, strong) WebViewController *myWebViewController;


@end

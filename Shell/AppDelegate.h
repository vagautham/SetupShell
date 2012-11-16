//
//  AppDelegate.h
//  Shell
//
//  Created by Gautham on 09/11/12.
//  Copyright (c) 2012 Gautham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "Log.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    Singleton *SingletonInstance;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) Singleton *SingletonInstance;


-(Singleton *)getSingletonInstance;

@end

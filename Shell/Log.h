//
//  Log.h
//  Seurat
//
//  Created by Arun on 1/6/12.
//  Copyright (c) 2012 Logitech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Log : NSObject

+ (void)error:(NSString *)type class:(NSString *)className selector:(NSString *)methodName message:(NSString *)messageString;
+ (void)info:(NSString *)type class:(NSString *)className selector:(NSString *)methodName message:(NSString *)messageString;
+ (void)debug:(NSString *)type class:(NSString *)className selector:(NSString *)methodName message:(NSString *)messageString;
+ (void)createNewLogFile;
+ (void)deleteExistingLogFile;
+ (void)Heading;
+ (NSString *)formatMessage:(NSString *)message;
+ (NSString *)getCurrentTime;
+ (void)destroy;
@end

//
//  Log.m
//  Shell
//
//  Created by Gautham on 09/11/12.
//  Copyright (c) 2012 Gautham. All rights reserved.
//

#import "Log.h"
#import "UIDevice+Machine.h"

static int level;
static NSString *logFile;
NSFileHandle *myHandle;

@implementation Log


+ (void)initialize
{
    level = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"LogLevel"] intValue];
}


+ (void)Heading
{
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* version = [infoDict objectForKey:@"CFBundleShortVersionString"];
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
    NSLocale *usLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];
    NSString *countryName = [usLocale displayNameForKey: NSLocaleCountryCode value: countryCode];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSString *devName = [NSString stringWithFormat:@"%@", [[UIDevice currentDevice] machine]];
    
    /*NSString *message = [NSString stringWithFormat:@"Date, Type, ClassName, MethodName, Message\n%@, Debug, DeviceInfo, DeviceInfo, App Version: %@; Device: %@; DeviceName: %@; OS Version: %@; model: %@; Locale: %@; TimeZone: %@;\n", [Log getCurrentTime], version, [devName stringByReplacingOccurrencesOfString:@"," withString:@"."], [[UIDevice currentDevice] name], [[UIDevice currentDevice] systemVersion], [[UIDevice currentDevice] model], countryName, [destinationTimeZone name]];*/
    NSString *message = [NSString stringWithFormat:@"Date, Type, Category, ClassName, MethodName, Message\n"];
    
    NSLog(@"%@", message);
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [documentPaths objectAtIndex:0];
    NSString *documentTXTPath = [documentsDirectory stringByAppendingPathComponent:logFile];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:documentTXTPath])
    {
        myHandle = [[NSFileHandle fileHandleForUpdatingAtPath:documentTXTPath] retain];
        [myHandle seekToEndOfFile];
        [myHandle writeData:  [message dataUsingEncoding:NSUTF8StringEncoding]];
        [myHandle seekToEndOfFile];
    }
    [fileManager release];
    
    [Log debug:@"Device-Info" class:NSStringFromClass([self class]) selector:NSStringFromSelector(_cmd)  message:[NSString stringWithFormat:@"%@ App Version: %@; Device: %@; DeviceName: %@; OS Version: %@; model: %@; Locale: %@; TimeZone: %@;\n", [Log getCurrentTime], version, [devName stringByReplacingOccurrencesOfString:@"," withString:@"."], [[UIDevice currentDevice] name], [[UIDevice currentDevice] systemVersion], [[UIDevice currentDevice] model], countryName, [destinationTimeZone name]]];
}


+ (void)createNewLogFile
{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease ];
    [dateFormatter setDateFormat:@"yyyyMMdd_hhmmss"];
    logFile = [[NSString alloc] initWithString:@"SetupShell_"];
    logFile = [logFile stringByAppendingString:[dateFormatter stringFromDate:today]];
    //logFile = [[NSString alloc] initWithString:[dateFormatter stringFromDate:today]];
    logFile = [logFile stringByAppendingString:@".log"];
    [logFile retain];
    NSLog(@"date:%@",logFile);
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [documentPaths objectAtIndex:0];
    NSString *documentTXTPath = [documentsDirectory stringByAppendingPathComponent:logFile];
    NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
    
    if (![fileManager fileExistsAtPath:documentTXTPath]){
    
        NSString *str = @"";
        [str writeToFile:documentTXTPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    [Log Heading];
}


+ (void)info:(NSString *)type class:(NSString *)className selector:(NSString *)methodName message:(NSString *)messageString
{
    if (level < 2)
    {
        NSString *message = [NSString stringWithFormat:@"%@, Info, %@, %@, %@, %@\n", [Log getCurrentTime], type, className, methodName, [Log formatMessage:messageString]];
        NSLog(@"%@", message);
        [myHandle writeData:  [message dataUsingEncoding:NSUTF8StringEncoding]];
        [myHandle seekToEndOfFile];
    }
}


+ (void)debug:(NSString *)type class:(NSString *)className selector:(NSString *)methodName message:(NSString *)messageString
{
    if (level < 3)
    {
        NSString *message = [NSString stringWithFormat:@"%@, Debug, %@, %@, %@, %@\n", [Log getCurrentTime], type, className, methodName, [Log formatMessage:messageString]];
        NSLog(@"%@", message);
        [myHandle writeData: [message dataUsingEncoding:NSUTF8StringEncoding]];
        [myHandle seekToEndOfFile];
    }
}


+ (void)error:(NSString *)type class:(NSString *)className selector:(NSString *)methodName message:(NSString *)messageString
{
    NSString *message = [NSString stringWithFormat:@"%@, Error, %@, %@, %@, %@\n", [Log getCurrentTime], type, className, methodName, [Log formatMessage:messageString]];
    NSLog(@"%@", message);
    [myHandle writeData: [message dataUsingEncoding:NSUTF8StringEncoding]];
    [myHandle seekToEndOfFile];
}

+ (void)deleteExistingLogFile
{
    int logFileCount = 0;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:documentsDirectoryPath error:nil];
    for (NSString *fileName in fileList){
        NSLog(@"File:%@",fileName);
        if ([fileName length] > 0 && [[fileName substringFromIndex:[fileName length] - 4] isEqualToString:@".log"])
            logFileCount++;
    }
    NSLog(@"LogFile Count:%d",logFileCount);
    if(logFileCount > 3)
    {
        for (NSString *fileName in fileList )
        {
                NSLog(@"Reverse File:%@",fileName);
                if ([fileName length] > 0 && [[fileName substringFromIndex:[fileName length] - 4] isEqualToString:@".log"])                {
                    NSString *documentTXTPath = [documentsDirectoryPath stringByAppendingPathComponent:fileName];
                    
                    if ([fileManager fileExistsAtPath:documentTXTPath] )
                    {
                        [fileManager removeItemAtPath:documentTXTPath error:nil];
                        logFileCount--;
                    }
                }
                if(logFileCount <=3 )
                    return;
        }
    }
}

+ (NSString *)formatMessage:(NSString *)message
{
    if ([message rangeOfString:@"{"].location != NSNotFound)
    {
        message = [message stringByReplacingOccurrencesOfString:@"{" withString:@""];
    }
    if ([message rangeOfString:@"}"].location != NSNotFound)
    {
        message = [message stringByReplacingOccurrencesOfString:@"}" withString:@""];
    }

    if ([message rangeOfString:@"\n"].location != NSNotFound)
    {
        message = [message stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    if ([message rangeOfString:@"\r"].location != NSNotFound)
    {
        message = [message stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    }
    return message;
}

+ (NSString *)getCurrentTime
{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setTimeStyle:kCFDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy  hh:mm:ss.SSS"];
    NSString *currentTime = [dateFormatter stringFromDate:today];
    return currentTime;
}

+ (void)destroy
{
    [myHandle release];
}

@end

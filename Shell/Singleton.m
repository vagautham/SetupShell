//
//  Singleton.m
//  Shell
//
//  Created by Gautham on 09/11/12.
//  Copyright (c) 2012 Gautham. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton
@synthesize currentURL,currentForm;
@synthesize URLHistory,FormHistory;
@synthesize FormForURL;
@synthesize langauge,countryCode;

-(id)init
{
    self = [super init];
    
    if(!currentURL)
        currentURL = [[NSString alloc] init];
    if(!currentForm)
        currentForm = [[NSString alloc] init];
    if(!URLHistory)
        URLHistory = [[NSMutableArray alloc] init];
    if(!FormHistory)
        FormHistory = [[NSMutableArray alloc] init];
    if(!FormForURL)
        FormForURL = [[NSDictionary alloc] init];
    if(!langauge)
        langauge = [[NSString alloc] init];
    if(!countryCode)
        countryCode = [[NSString alloc] init];
    return self;
}
-(BOOL)appendCurrentURL:(NSString *)URL andForm:(NSString *)Form
{
    currentURL = [NSString stringWithString:URL];
    currentForm = [NSString stringWithString:Form];
    
    if(![URLHistory containsObject:URL])
        [URLHistory addObject:URL];
    
    if(![FormHistory containsObject:Form])
        [FormHistory addObject:Form];
    
   // [FormForURL setValue:currentURL forKey:currentForm];
    
    if(currentURL  && [currentURL length]>0)
        return TRUE;
    
    return FALSE;
}
-(void)setLangauge:(NSString *)lang andCountryCode:(NSString *)CountryCode
{
    langauge = [NSString stringWithString:lang];
    countryCode = [NSString stringWithString:CountryCode];

}
-(NSString *)getCurrentURL
{
    return currentURL;
}

-(NSString *)getCurrentForm
{
    return currentForm;
}
-(NSString *)getCurrentlang
{
    return langauge;
}
-(NSString *)getCurrentCCode
{
    return countryCode;
 
}
@end

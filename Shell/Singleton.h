//
//  Singleton.h
//  Shell
//
//  Created by Gautham on 09/11/12.
//  Copyright (c) 2012 Gautham. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject
{
    NSString *currentURL;
    NSString *currentForm;
    
    NSMutableArray *URLHistory;
    NSMutableArray *FormHistory;
    
    NSDictionary *FormForURL;
    
    NSString *langauge;
    NSString *countryCode;

}


@property(nonatomic,strong) NSString *currentURL;
@property(nonatomic,strong) NSString *currentForm;

@property(nonatomic,strong) NSMutableArray *URLHistory;
@property(nonatomic,strong) NSMutableArray *FormHistory;

@property(nonatomic,strong) NSString *langauge;
@property(nonatomic,strong) NSString *countryCode;

@property(nonatomic,strong) NSDictionary *FormForURL;


-(BOOL)appendCurrentURL:(NSString *)URL andForm:(NSString *)Form;
-(NSString *)getCurrentURL;
-(NSString *)getCurrentForm;
-(void)setLangauge:(NSString *)lang andCountryCode:(NSString *)CountryCode;
-(NSString *)getCurrentlang;
-(NSString *)getCurrentCCode;

@end

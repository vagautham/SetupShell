//
//  iToast.m
//  iToast
//
//  Created by Diallo Mamadou Bobo on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "iToast.h"
#import <QuartzCore/QuartzCore.h>


static iToastSettings *sharedSettings = nil;
UIButton *v;
@interface iToast(private)

- (iToast *) settings;


@end


@implementation iToast


- (id) initWithText:(NSString *) tex interface:(BOOL)isiPAd{
    if (self = [super init]) {
        text = [tex copy];
        isiPad = isiPAd;
    }
    
    return self;
}


- (void) show{
    
    [[[UIApplication sharedApplication] keyWindow] setUserInteractionEnabled:NO];
    iToastSettings *theSettings = _settings;
    
    if (!theSettings) {
        theSettings = [iToastSettings getSharedSettings];
        
    }
    UIFont *font;
    if(isiPad)
    {
        font = [UIFont systemFontOfSize:16];
    }
    else{
        font = [UIFont systemFontOfSize:13];    
    }
    
    CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(280, 60)];
    
    UILabel *label = [[UILabel alloc]init];
    
    if(isiPad){
        [label setFrame: CGRectMake(0, 0, textSize.width + 20, textSize.height + 20)];
    }else{
        [label setFrame: CGRectMake(0, 0, textSize.width + 17, textSize.height + 17)];
    }
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = font;
    label.text = text;
    label.numberOfLines = 0;
    //label.shadowColor = [UIColor darkGrayColor];
    //label.shadowOffset = CGSizeMake(1, 1);
    
    
    v = [UIButton buttonWithType:UIButtonTypeCustom];
    if(isiPad){
        v.frame = CGRectMake(0, 0, textSize.width + 40, textSize.height + 40);
    }     
    else{
        v.frame = CGRectMake(0, 0, textSize.width + 30, textSize.height + 30);   
    }
    
    label.textAlignment = UITextAlignmentCenter;
    label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    label.center = CGPointMake(v.frame.size.width / 2, v.frame.size.height / 2);
    [v addSubview:label];
    [label release];
    
    
    v.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    v.layer.cornerRadius = 10;
    [[v layer] setMasksToBounds:YES];
    [[v layer] setBorderWidth:2.0f];
    [v.layer setBorderColor:[[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8] CGColor]];
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    
    CGPoint point;
    
    if (theSettings.gravity == iToastGravityTop) {
        point = CGPointMake(window.frame.size.width / 2, 45);
    }else if (theSettings.gravity == iToastGravityBottom) {
        point = CGPointMake(window.frame.size.width / 2, window.frame.size.height - 45);
    }else if (theSettings.gravity == iToastGravityCenter) {
        point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
    }else{
        point = theSettings.postition;
    }
    
    point = CGPointMake(point.x + offsetLeft, point.y + offsetTop);
    v.center = point;
    
    NSTimer *timer1 = [NSTimer timerWithTimeInterval:((float)theSettings.duration) 
                                              target:self selector:@selector(hideToast:) 
                                            userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer1 forMode:NSDefaultRunLoopMode];
    
    [window addSubview:v];
    
    view = [v retain];
    
    [v addTarget:self action:@selector(hideToast:) forControlEvents:UIControlEventTouchDown];
    
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGFloat angle = 0.0;
    switch (orientation) { 
        case UIInterfaceOrientationPortraitUpsideDown:
            angle = M_PI; 
            break;
        case UIInterfaceOrientationLandscapeLeft:
            angle = - M_PI / 2.0f;
            break;
        case UIInterfaceOrientationLandscapeRight:
            angle = M_PI / 2.0f;
            break;
        default:
            angle = 0.0;
            break;
    } 
    
    v.transform=CGAffineTransformMakeRotation(angle);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setRotate:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}



//set to rotate view
- (void)setRotate:(id)sender
{
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    CGFloat angle = 0.0;
    switch (orientation) { 
        case UIInterfaceOrientationPortraitUpsideDown:
            angle = M_PI; 
            break;
        case UIInterfaceOrientationLandscapeLeft:
            angle = - M_PI / 2.0f;
            break;
        case UIInterfaceOrientationLandscapeRight:
            angle =  M_PI / 2.0f;
            break;
        default: 
            angle = 0.0;
            break;
    } 
	
	v.transform=CGAffineTransformMakeRotation(angle);
}



- (void) hideToast:(NSTimer*)theTimer{
    
    [UIView beginAnimations:nil context:NULL];
    view.alpha = 0;
    [UIView commitAnimations];
    
    NSTimer *timer2 = [NSTimer timerWithTimeInterval:500 
                                              target:self selector:@selector(hideToast:) 
                                            userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer2 forMode:NSDefaultRunLoopMode];
    [[[UIApplication sharedApplication] keyWindow] setUserInteractionEnabled:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void) removeToast:(NSTimer*)theTimer{
    
    [view removeFromSuperview];
}


+ (iToast *) makeText:(NSString *) _text interface:(BOOL)isiPAd{
    iToast *toast = [[[iToast alloc] initWithText:_text interface:isiPAd] autorelease];
    
    return toast;
}


- (iToast *) setDuration:(NSInteger ) duration{
    [self theSettings].duration = duration;
    return self;
}

- (iToast *) setGravity:(iToastGravity) gravity 
             offsetLeft:(NSInteger) left
              offsetTop:(NSInteger) top{
    [self theSettings].gravity = gravity;
    offsetLeft = left;
    offsetTop = top;
    return self;
}

- (iToast *) setGravity:(iToastGravity) gravity{
    [self theSettings].gravity = gravity;
    return self;
}

- (iToast *) setPostion:(CGPoint) _position{
    [self theSettings].postition = CGPointMake(_position.x, _position.y);
    
    return self;
}

-(iToastSettings *) theSettings{
    if (!_settings) {
        _settings = [[iToastSettings getSharedSettings] copy];
    }
    
    return _settings;
}

@end


@implementation iToastSettings
@synthesize duration;
@synthesize gravity;
@synthesize postition;
@synthesize images;

- (void) setImage:(UIImage *) img forType:(iToastType) type{
    if (!images) {
        images = [[NSMutableDictionary alloc] initWithCapacity:4];
    }
    
    if (img) {
        NSString *key = [NSString stringWithFormat:@"%i", type];
        [images setValue:img forKey:key];
    }
}


+ (iToastSettings *) getSharedSettings{
    if (!sharedSettings) {
        sharedSettings = [iToastSettings new];
        sharedSettings.gravity = iToastGravityCenter;
        sharedSettings.duration = iToastDurationShort;
        
        
    }
    
    return sharedSettings;
    
}


- (id) copyWithZone:(NSZone *)zone{
    iToastSettings *copy = [iToastSettings new];
    copy.gravity = self.gravity;
    copy.duration = self.duration;
    copy.postition = self.postition;
    
    NSArray *keys = [self.images allKeys];
    
    for (NSString *key in keys){
        [copy setImage:[images valueForKey:key] forType:[key intValue]];
    }
    
    return copy;
}

@end



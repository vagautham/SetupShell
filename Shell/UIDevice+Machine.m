//
//  UIDevice+Machine.m
//  Seurat
//
//  Created by Arun on 5/7/12.
//  Copyright (c) 2012 Logitech. All rights reserved.
//

#import "UIDevice+Machine.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation UIDevice (Machine)

- (NSString *)machine
{
    size_t size;
    
    // Set 'oldp' parameter to NULL to get the size of the data
    // returned so we can allocate appropriate amount of space
    sysctlbyname("hw.machine", NULL, &size, NULL, 0); 
    
    // Allocate the space to store name
    char *name = malloc(size);
    
    // Get the platform name
    sysctlbyname("hw.machine", name, &size, NULL, 0);
    
    // Place name into a string
    //NSString *machine = [NSString stringWithCString:name];
    NSString *machine = [NSString stringWithCString:name encoding:NSASCIIStringEncoding];

    // Done with this
    free(name);
    
    return machine;
}

@end

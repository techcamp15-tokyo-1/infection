//
//  SingletonNetworkEngine.m
//  Infection
//
//  Created by techcamp on 13/08/29.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import "SingletonNetworkEngine.h"

static SingletonNetworkEngine* singleton = nil;

@implementation SingletonNetworkEngine

+ (SingletonNetworkEngine*) sharedInstance {
    if (singleton == nil) {
        singleton = [[super alloc] initWithHostName:nil];
        [singleton retain];
    }
    return singleton;
}
@end

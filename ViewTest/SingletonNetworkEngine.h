//
//  SingletonNetworkEngine.h
//  Infection
//
//  Created by techcamp on 13/08/29.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import "MKNetworkEngine.h"

@interface SingletonNetworkEngine : MKNetworkEngine

+ (SingletonNetworkEngine*) sharedInstance;
@end

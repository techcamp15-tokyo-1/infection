//
//  GKSessionDelegate.h
//  Infection
//
//  Created by techcamp on 13/08/23.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "Virus.h"

@interface MyGKSessionDelegate : NSObject <GKSessionDelegate> {
}
+ (MyGKSessionDelegate*) sharedInstance;
- (void) addVirus: (Virus*) virus;
- (void) deleteVirus: (NSNumber*) virus_id;
@end

static const NSTimeInterval TIMEOUT = 10.0f;
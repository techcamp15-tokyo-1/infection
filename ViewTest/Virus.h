//
//  Virus.h
//  Infection
//
//  Created by techcamp on 13/08/22.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Virus : NSObject {

@private
    NSNumber *virus_id;
    NSString *name;
    NSNumber *infection_rate;
    NSNumber *durability;
}
@end

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

- (id) initWithValue: (NSInteger*)_id : (NSString*)_name : (NSNumber*)_infection_rate : (NSNumber*)_durability;
- (void)setName :(NSString *)_name;
- (void)setInfectionRate :(NSNumber * )_infection_rate;
- (void)setDurability :(NSNumber *)_durability;
- (NSString *)getName;
- (NSNumber *)getInfectionRate;
- (NSNumber *)getDurability;
- (NSNumber *)getVirusId;
- (NSDictionary*) toNSDictionary;
@end

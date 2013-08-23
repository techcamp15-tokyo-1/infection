//
//  Virus.m
//  Infection
//
//  Created by techcamp on 13/08/22.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import "Virus.h"

@implementation Virus

//初期化処理
- (id)init
{
    if (self = [super init]) {
        // ここで初期処理
    }
    return self;
}

- (id)initWithValue:(NSString *)_name :(NSNumber *)_infection_rate :(NSNumber *)_durability
{
    if (self = [super init]) {
        name = _name;
        infection_rate = _infection_rate;
        durability = _durability;
    }
    return self;
}


//
- (void)setName :(NSString *)_name
{
    name = _name;
}

-(void)setInfectionRate :(NSNumber * )_infection_rate
{
    infection_rate = _infection_rate;
}

-(void)setDurability :(NSNumber *)_durability
{
    durability = _durability;
}


//
- (NSString *)getName
{
    return name;
}

- (NSNumber *)getInfectionRate
{
    return infection_rate;
}

-(NSNumber *)getDurability
{
    return durability;
}

@end

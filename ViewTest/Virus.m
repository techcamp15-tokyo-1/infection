//
//  Virus.m
//  Infection
//
//  Created by techcamp on 13/08/22.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import "Virus.h"
#import "JSONConverter.h"

@implementation Virus

//初期化処理
- (id)init
{
    if (self = [super init]) {
        // ここで初期処理
    }
    return self;
}

- (id)initWithValue:(NSNumber*)_id :(NSString *)_name :(NSNumber *)_infection_rate :(NSNumber *)_durability
{
    if (self = [super init]) {
        virus_id = _id;
        name = _name;
        infection_rate = _infection_rate;
        durability = _durability;
        [virus_id retain];
        [name retain];
        [infection_rate retain];
        [durability retain];
    }
    return self;
}

- (id) initWithDictionary:(NSDictionary *)virus_dictionary {
    [super init];
    virus_id       = [virus_dictionary objectForKey:@"virus_id"];
    name           = [virus_dictionary objectForKey:@"name"];
    infection_rate = [virus_dictionary objectForKey:@"infection_rate"];
    durability     = [virus_dictionary objectForKey:@"durability"];
    [virus_id retain];
    [name retain];
    [infection_rate retain];
    [durability retain];
    return self;
}

- (void) setVirusId: (NSNumber*)_virus_id {
    virus_id = _virus_id;
}

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

-(NSNumber*) getVirusId {
    return virus_id;
}

/**
 ウィルスのステータスをJSON形式のNSDictionaryに変換する
 */
- (NSDictionary*) toNSDictionary {
    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjects:
                                    @[virus_id,name,infection_rate,durability]
                                    forKeys:@[@"virus_id", @"name", @"infection_rate", @"durability"]];
    return jsonDictionary;
}

@end

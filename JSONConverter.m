//
//  JSONUtil.m
//  Infection
//
//  Created by techcamp on 13/08/22.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import "JSONConverter.h"

@implementation JSONConverter {
    
}

/**
 * NSDictionaryをJSON形式のNSDataに変換する。
 * NSDictionaryが有効なJSON形式でない場合、および変換中にエラーが発生した場合はnilを返す。
 */
+ (NSData*) toJsonData: (NSDictionary*) dictionary {
    if ([NSJSONSerialization isValidJSONObject:dictionary]) {
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
        if (data == nil) { // エラー発生
            NSLog(@"***** Error in toJsonData: *****");
            NSLog(@"%@", error);
        }
        return data;
    }
    
    NSLog(@"***** Error in toJsonData: *****");
    NSLog(@"dictionary is not valid JSON object.");
    return nil;
}

/**
 * JSON形式のNSDataをNSDictionaryに変換する。
 * 変換中にエラーが発生した場合はnilを返す。
 */
+ (NSDictionary*) toNSDictionary: (NSData*) jsonData {
    NSError* error;
    NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (dictionary == nil) { // エラー発生
        NSLog(@"***** Error in toDictionary: *****");
        NSLog(@"%@", error);
    }
    return dictionary;
}

@end

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
 * 任意のオブジェクトをJSON形式のNSDataに変換する。
 * オブジェクトが有効なJSON形式でない場合、および変換中にエラーが発生した場合はnilを返す。
 */
+ (NSData*) toJsonData: (id) jsonObject {
    if ([NSJSONSerialization isValidJSONObject:jsonObject]) {
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:&error];
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
+ (id) objectFrom: (NSData*) jsonData {
    NSError* error;
    id object = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (object == nil) { // エラー発生
        NSLog(@"***** Error in objectFrom: *****");
        NSLog(@"%@", error);
    }
    return object;
}

@end

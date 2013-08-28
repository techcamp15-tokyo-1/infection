//
//  HTTPRequester.h
//  Infection
//
//  Created by techcamp on 13/08/22.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPRequester : NSObject

+ (NSData*) sendPostWithData: (NSString*)urlstr :(NSData*)data;
+ (NSData*) sendPostWithDictionary: (NSString*)urlstr : (NSDictionary*)dictionary;

@end

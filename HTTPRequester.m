//
//  HTTPRequester.m
//  Infection
//
//  Created by techcamp on 13/08/22.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import "HTTPRequester.h"

@implementation HTTPRequester {
    
}

+ (NSData*) sendPostWithData: (NSString*)urlstr : (NSData*)data {
    NSURL* url = [NSURL URLWithString:urlstr];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    NSHTTPURLResponse *response;
    NSError *error;
    NSData* received = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (received == nil) { // 接続、またはレスポンスのダウンロードに失敗
        NSLog(@"***** Error in sendHTTPPostRequest:: *****");
        NSLog(@"%@", error);
    }
    return received;
}

// TODO: Dictionary, key-value Arrayからpost strを生成するメソッド実装
// TODO: Dictionaryをpost strに変換し、それをNSDataに変換するメソッド実装
@end

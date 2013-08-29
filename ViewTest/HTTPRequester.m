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

/**
 文字列で指定されたURLにNSDataを送信し、レスポンスを返す。
 URLへの接続やレスポンスの受信に失敗した場合はnilが返る。
*/
+ (NSData*) sendPostWithData: (NSString*)urlstr : (NSData*)data {
    NSURL* url = [NSURL URLWithString:urlstr];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    NSHTTPURLResponse *response;
    NSError *error;
    NSData* received;
    const int TRIAL = 5; // タイムアウト・エラー等発生した際の試行回数
    for (int i = 0; i < TRIAL; i++) {
        received = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (received == nil) { // 接続、またはレスポンスのダウンロードに失敗
            NSLog(@"***** Error in sendHTTPPostRequest:: *****");
            NSLog(@"%@", error);
        } else {
            break;
        }
    }
    return received;
}

/**
文字列で指定されたURLにNSDataを非同期送信する。
*/
+ (void) sendAsynchPostWithData: (NSString*)urlstr : (NSData*)data {
    NSURL* url = [NSURL URLWithString:urlstr];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    NSLog(@"Send Request to %@", urlstr);
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSLog(@"Response from %@", urlstr);
         if ([data length] >0 && error == nil)
         {
             NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Nothing was downloaded.");
         }
         else if (error != nil){
             NSLog(@"Error = %@", error);
             [HTTPRequester sendAsynchPostWithData:urlstr :data];
         }
     }];
}

/**
 NSDictionaryをPOST通信で使用できる形式の文字列に変換する。
*/
+ (NSString*) postString: (NSDictionary*) dictionary {
    NSArray* keys = [dictionary allKeys];
    NSMutableString* postString = [NSMutableString stringWithString:@""];
    for (int i = 0; i < [keys count]; i++) {
        id key   = [keys objectAtIndex:i];
        id value = [dictionary objectForKey:key];
        [postString appendFormat:@"%@=%@", key, value];
        if (i != [keys count] - 1) {
            [postString appendString:@"&"];
        }
    }
    return postString;
}

/**
 文字列で指定されたURLにNSDictionaryの内容を送信し、レスポンスを返す。
 URLへの接続やレスポンスの受信に失敗した場合はnilが返る。
 */
+ (NSData*) sendPostWithDictionary: (NSString*)urlstr : (NSDictionary*)dictionary {
    NSString* postString = [HTTPRequester postString:dictionary];
    NSData* postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSData* response = [HTTPRequester sendPostWithData:urlstr :postData];
    if (response == nil) {
        NSLog(@"***** Error in sendPostWithDictionary: *****");
    }
    return response;
}

/**
 文字列で指定されたURLにNSDictionaryの内容を非同期送信する。
 */
+ (void) sendAsynchPostWithDictionary: (NSString*)urlstr : (NSDictionary*)dictionary {
    NSString* postString = [HTTPRequester postString:dictionary];
    NSData* postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [HTTPRequester sendAsynchPostWithData:urlstr :postData];
}

@end

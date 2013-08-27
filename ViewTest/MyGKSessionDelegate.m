//
//  GKSessionDelegate.m
//  Infection
//
//  Created by techcamp on 13/08/23.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import "MyGKSessionDelegate.h"
#import "Virus.h"
#import "JSONConverter.h"
#import "HTTPRequester.h"

// シングルトン
static MyGKSessionDelegate* singleton = nil;

@implementation MyGKSessionDelegate {
    /**
     ユーザーが拡散中のウィルスの配列。
     自分が拡散開始できるのは1つのみだが、他のユーザーのウィルスに感染した場合、それらを媒介しなければならないので、
     一度に複数のウィルスに感染している状況がありうるため、配列を採用。
     */
    NSMutableArray* viruses;
}

/**
 シングルトン取得
 */
+ (MyGKSessionDelegate*) sharedInstance {
    @synchronized(self) {
        if (singleton == nil) {
            singleton = [[MyGKSessionDelegate alloc] init];
        }
        return singleton;
    }
}

- (id) init {
    viruses = [NSMutableArray array];
    [viruses retain];
    return self;
}

/***** シングルトンを維持するためのオーバーライドここから *****/
+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (singleton == nil) {
			singleton = [super allocWithZone:zone];
			return singleton;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone*)zone {
	return self;  // シングルトン状態を保持するため何もせず self を返す
}

- (id)retain {
	return self;  // シングルトン状態を保持するため何もせず self を返す
}

- (unsigned)retainCount {
	return UINT_MAX;  // 解放できないインスタンスを表すため unsigned int 値の最大値 UINT_MAX を返す
}

- (void)release {
	// シングルトン状態を保持するため何もしない
}

- (id)autorelease {
	return self;  // シングルトン状態を保持するため何もせず self を返す
}

/***** シングルトン状態維持のためのオーバーライドここまで *****/

/**
 virusが感染中のウィルスリストにあるかどうかを返す。
 */
- (BOOL) inViruses: (Virus*) virus {
    for (Virus* v in viruses) {
        if ([[virus getVirusId] isEqualToString:[v getVirusId]]) {
            return YES;
        }
    }
    return NO;
}

/**
 感染中のウィルスリストに追加する。
 ウィルスのdurabilityに応じた時間の後死ぬようにタイマーをセット
 */
- (void) addVirus: (Virus*) virus {
    NSLog(@"addVirus");
    if ([self inViruses:virus]) {
        NSLog(@"already Has");
        return;
    }
    
    [viruses addObject:virus];
    NSLog(@"current viruses");
    for (Virus* virus in viruses) {
        NSLog(@"%@", [virus toNSDictionary]);
    }
    
    NSDictionary* virus_dictionary = [virus toNSDictionary];
    NSData* response = [HTTPRequester sendPostWithDictionary:@"http://www53.atpages.jp/infectionapp/infected.php" :virus_dictionary];
    if (response != nil) {
        NSLog(@"%@", [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
    }
    
    NSTimeInterval durability = [[virus getDurability] intValue];
    [NSTimer scheduledTimerWithTimeInterval:durability
                                     target:self
                                   selector:@selector(doTimer:)
                                   userInfo:virus
                                    repeats:NO];
}

/**
 * ウィルスが死んだときに呼び出される。
 */
- (void)doTimer:(NSTimer *)timer
{
    Virus* virus = (Virus*) timer.userInfo;
    NSLog(@"VirusID: %@ is dead.", [virus getVirusId]);
    [self deleteVirus:[virus getVirusId]];
}

- (void) deleteVirus: (NSString*) virus_id {
    for (Virus* virus in viruses) {
        if ([virus.getVirusId isEqualToString:virus_id]) {
            [viruses removeObject:virus];
            NSDictionary* virus_dictionary = [virus toNSDictionary];
            NSData* response = [HTTPRequester sendPostWithDictionary:@"http://www53.atpages.jp/infectionapp/recovered.php" :virus_dictionary];
            NSLog(@"%@", [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            break;
        }
    }
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error {
    NSLog(@"Connection failed with PeerID:%@", peerID);
    NSLog(@"Error description: %@", error);
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
    NSLog(@"Critical Error has occured");
    NSLog(@"Error description: %@", error);
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
    NSLog(@"Receive connection request from peerID:%@", peerID);
	NSError *error;
	if([session acceptConnectionFromPeer:peerID error:&error]) {
		NSLog(@"Connection established with peerID:%@", peerID);
	} else {
		NSLog(@"Connection failed with peerID:%@", peerID);
        NSLog(@"Error description: %@", error);
	}
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
	switch (state) {
		case GKPeerStateAvailable:
            NSLog(@"PeerID:%@ found", peerID);
            NSLog(@"Establishing connection with peerID:%@", peerID);
            [session connectToPeer:peerID withTimeout:TIMEOUT];
			break;
		case GKPeerStateUnavailable:
            NSLog(@"PeerID:%@ disappeared", peerID);
			break;
		case GKPeerStateConnected:
            NSLog(@"Connected with peerID:%@", peerID);
            NSMutableArray* virus_json_array = [NSMutableArray arrayWithCapacity:[viruses count]];
            for (Virus* virus in viruses) {
                [virus_json_array addObject:[virus toNSDictionary]];
            }
            NSData* jsonData = [JSONConverter toJsonData: virus_json_array];
            NSError* error;
			BOOL succeeded = [session sendData:jsonData
                                      toPeers:[NSArray arrayWithObject:peerID]
                                      withDataMode:GKSendDataReliable
                                      error:&error];
            if (!succeeded) {
                NSLog(@"***** Error while sending data *****");
                NSLog(@"Error description: %@", error);
            }
			break;
		case GKPeerStateDisconnected:
            NSLog(@"Disconnected with peerID:%@", peerID);
			break;
		case GKPeerStateConnecting:
            NSLog(@"Connecting with peerID:%@ ...", peerID);
			break;
		default:
            NSLog(@"No applicable state: %u", state);
			break;
	}
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peerID inSession:(GKSession *)session context:(void *)context {
    NSLog(@"Received data from peerID:%@", peerID);
    NSArray* virus_json_array = [JSONConverter objectFrom:data];
    for (NSDictionary* virus_dictionary in virus_json_array) {
        NSLog(@"%@", virus_dictionary);
        [self addVirus:[[Virus alloc] initWithDictionary: virus_dictionary]];
    }
}
@end

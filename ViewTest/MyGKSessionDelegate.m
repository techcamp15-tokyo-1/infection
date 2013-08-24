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

// シングルトン
static MyGKSessionDelegate* singleton = nil;

@implementation MyGKSessionDelegate {
    @private
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
            return [[MyGKSessionDelegate alloc] init];
        } else {
            return singleton;
        }
    }
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

- (void) addVirus: (Virus*) virus {
    [viruses addObject:virus];
    // TODO タイマーセット
}

- (void) deleteVirus: (NSNumber*) virus_id {
    for (Virus* virus in viruses) {
        if ([virus.getVirusId isEqualToNumber:virus_id]) {
            [viruses delete:virus];
            break;
        }
        // TODO サーバーへ送信
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
    NSLog(@"Receiving data from peerID:%@", peerID);
    NSArray* virus_json_array = [JSONConverter objectFrom:data];
    for (Virus* virus in virus_json_array) {
        // TODO サーバーへデータ送信
        [self addVirus:virus];
    }
}
@end

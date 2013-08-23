//
//  GKSessionDelegate.m
//  Infection
//
//  Created by techcamp on 13/08/23.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import "GKSessionDelegate.h"

@implementation GKSessionDelegate {
    
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error {
    NSLog(@"Connection failed with PeerID:%@", peerID);
    NSLOg(@"Error description: %@", error);
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
    NSLog(@"Critical Error has occured");
    NSLOg(@"Error description: %@", error);
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
            // TODO: ウィルス拡散の処理を実装
            /*NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                            @"my virus", @"name",
                                            @0.5f,       @"infection_rate",
                                            @10,         @"until_death_second", nil];
            
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:nil];
			[mySession sendData:jsonData toPeers:[NSArray arrayWithObject:peerID] withDataMode:GKSendDataReliable error:nil];
			[self addLog:[NSString stringWithFormat:@"%@ にメッセージを送った！「%@」",peerID,jsonData]];*/
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
    // TODO: ウィルス受信処理の実装
}
@end

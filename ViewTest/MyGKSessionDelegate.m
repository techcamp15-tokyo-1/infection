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
    [self addVirus:virus: YES];
}

- (void) addVirus: (Virus*) virus : (BOOL) add {
    NSLog(@"addVirus");
    if ([self inViruses:virus]) {
        NSLog(@"already Has");
        return;
    }
    
    [viruses addObject:virus];
    [self showAlert:@"ウイルスに感染！" :[[virus getName] stringByAppendingFormat:@"に感染しました！"]];
    NSTimeInterval durability = [[virus getDurability] intValue];
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:durability
                                     target:self
                                   selector:@selector(doTimer:)
                                   userInfo:virus
                                    repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    if (!add) {
        return;
    }
    
    NSLog(@"current viruses");
    for (Virus* virus in viruses) {
        NSLog(@"%@", [virus toNSDictionary]);
    }
    
    NSDictionary* virus_dictionary = [virus toNSDictionary];
    [HTTPRequester sendAsynchPostWithDictionary:@"http://nokok.dip.jp/infectionapp/infected.php" :virus_dictionary];
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
            [HTTPRequester sendAsynchPostWithDictionary:@"http://nokok.dip.jp/infectionapp/recovered.php" :virus_dictionary];
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
            if ([viruses count] == 0) {
                NSLog(@"no count");
                return;
            }
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
        [self addVirus:[[Virus alloc] initWithDictionary: virus_dictionary]];
        
        NSMutableDictionary* visualize_dictionary = [NSMutableDictionary dictionary];
        NSString* virus_id  = [virus_dictionary objectForKey:@"virus_id"];
        NSString* from_user = [session displayNameForPeer:peerID];
        NSString* to_user   = session.displayName;
        [visualize_dictionary setValue:virus_id forKey:@"virus_id"];
        [visualize_dictionary setValue:from_user forKey:@"from_name"];
        [visualize_dictionary setValue:to_user forKey:@"to_name"];
        [HTTPRequester sendAsynchPostWithDictionary:@"http://nokok.dip.jp/infectionapp/report.php" :visualize_dictionary];
    }
}


//alertを表示
- (void) showAlert:(NSString *)title :(NSString*)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(220, 10, 40, 40)];
    
    NSString *path = [[NSString alloc] initWithString:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"img115_22.png"]];
    UIImage *bkgImg = [[UIImage alloc] initWithContentsOfFile:path];
    [imageView setImage:bkgImg];
    [bkgImg release];
    [path release];
    
    [alert addSubview:imageView];
    [imageView release];
    
    [alert show];
    [alert release];
}

@end

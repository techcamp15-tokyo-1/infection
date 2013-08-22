
#import "TashouNoEnViewController.h"

#define kSessionID @"_tashounoen"

@implementation TashouNoEnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	NSString *message = [[NSUserDefaults standardUserDefaults] objectForKey:@"message"];
	if(message) {
		[messageTextField setText:message];
	}

	mySession = [[GKSession alloc] initWithSessionID:kSessionID displayName:@"oosawa" sessionMode:GKSessionModePeer];
	mySession.delegate = self;
	[mySession setDataReceiveHandler:self withContext:nil];
	mySession.available = YES;
	
	[self addLog:[NSString stringWithFormat:@"誰かを探し始めた！自分のIDは %@",mySession.peerID]];
    [self playDummyAudio];
}

- (void) playDummyAudio {
    // ファイルのパスを作成します。
    NSString *path = @"10min.mp3";
    // ファイルのパスを NSURL へ変換します。
    NSURL* url = [NSURL fileURLWithPath:path];
    
    // ファイルを読み込んで、プレイヤーを作成します。
    AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    player.numberOfLoops = -1;
    // 再生
    [player play];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}


- (void)dealloc {
	[logTextView release];
	[messageTextField release];
	
    [super dealloc];
}

#pragma mark Helper
- (void)addLog:(NSString*)logString {
	[self performSelectorOnMainThread:@selector(updateLog:) withObject:logString waitUntilDone:YES];
}

- (void)updateLog:(NSString*)logString {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	logTextView.text = [NSString stringWithFormat:@"- %@\n%@",logString,logTextView.text];
	[pool release];
}


#pragma mark GKSessionDelegate

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error {
	[self addLog:[NSString stringWithFormat:@"%@ とうまく接続できない。 (%@)",peerID,[error localizedDescription]]];
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
	[self addLog:[NSString stringWithFormat:@"ネットワークがおかしい？ (%@)",[error localizedDescription]]];
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
	[self addLog:[NSString stringWithFormat:@"%@ から接続したいと言われた！",peerID]];

	NSError *error;
	if(![mySession acceptConnectionFromPeer:peerID error:&error]) {
		[self addLog:[NSString stringWithFormat:@"%@ と接続できなかった… (%@)",peerID,[error localizedDescription]]];
	} else {
		[self addLog:[NSString stringWithFormat:@"%@ と接続できた！",peerID]];

	}
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {	
	switch (state) {
		case GKPeerStateAvailable:
			[self addLog:[NSString stringWithFormat:@"%@ を見つけた！",peerID]];
            [self addLog:[NSString stringWithFormat:@"displayName = %@", [mySession displayNameForPeer:peerID]]];
			break;
		case GKPeerStateUnavailable:
			[self addLog:[NSString stringWithFormat:@"%@ を見失った！",peerID]];
			break;
		case GKPeerStateConnected:
			[self addLog:[NSString stringWithFormat:@"%@ が接続した！",peerID]];
			[mySession sendData:[[messageTextField text] dataUsingEncoding:NSUTF8StringEncoding] toPeers:[NSArray arrayWithObject:peerID] withDataMode:GKSendDataReliable error:nil];
			[self addLog:[NSString stringWithFormat:@"%@ にメッセージを送った！「%@」",peerID,[messageTextField text]]];
			break;
		case GKPeerStateDisconnected:
			[self addLog:[NSString stringWithFormat:@"%@ が切断された！",peerID]];
			break;
		case GKPeerStateConnecting:
			[self addLog:[NSString stringWithFormat:@"%@ が接続中！",peerID]];
			break;
		default:
			break;
	}
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context {
	[self addLog:[NSString stringWithFormat:@"%@ からメッセージを受け取った！ 「%@」",peer,[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]]];
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
	[[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"message"];
}

@end

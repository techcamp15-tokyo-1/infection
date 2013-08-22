
#import "TashouNoEnViewController.h"

#define kSessionID @"_tashounoen"

@implementation TashouNoEnViewController



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
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
    // バックグラウンド再生を許可
    AVAudioSession* session = [AVAudioSession sharedInstance];
    NSError* error = nil;
    [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    [session setActive:YES error:&error];
    
    
    // ファイルのパスを作成
    NSString *path = [[NSBundle mainBundle] pathForResource:@"jazz" ofType:@"mp3"];
    // ファイルのパスを NSURL へ変換します。
    NSURL* url = [NSURL fileURLWithPath:path];
    // ファイルを読み込んで、プレイヤーを作成
    AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    // 無限ループ設定
    player.numberOfLoops = -1;
    // 再生
    [player play];
}
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[logTextView release];
	[messageTextField release];
	
    [super dealloc];
}

#pragma mark Helper
- (void)addLog:(NSString*)logString {
	
	//mainTextView.text = [NSString stringWithFormat:@"- %@\n%@",logString,mainTextView.text];
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
			//[self addLog:[NSString stringWithFormat:@"%@ を見つけた！",peerID]];
			[self addLog:[NSString stringWithFormat:@"%@ を見つけた！",[mySession displayNameForPeer: peerID]]];
			[self addLog:[NSString stringWithFormat:@"%@ に接続しに行く！",peerID]];
            [mySession connectToPeer:peerID withTimeout:10.0f];
			break;
		case GKPeerStateUnavailable:
			[self addLog:[NSString stringWithFormat:@"%@ を見失った！",peerID]];
			break;
		case GKPeerStateConnected:
			[self addLog:[NSString stringWithFormat:@"%@ が接続した！",peerID]];
            NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                            @"name",           @"my virus",
                                            @"infection rate", 0.5,
                                            @"remaining time", 10, nil];
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                options:NSJSONWritingPrettyPrinted
                                error:nil];
			[mySession sendData:jsonData toPeers:[NSArray arrayWithObject:peerID] withDataMode:GKSendDataReliable error:nil];
			[self addLog:[NSString stringWithFormat:@"%@ にメッセージを送った！「%@」",peerID,jsonData]];
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
    NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
	[self addLog:[NSString stringWithFormat:@"%@ からメッセージを受け取った！ 「%@」",peer,jsonDictionary]];
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
	[[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"message"];
}

@end

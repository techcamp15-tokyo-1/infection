
#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface TashouNoEnViewController : UIViewController <GKSessionDelegate,UITextFieldDelegate> {
	GKSession *mySession;
	
	IBOutlet UITextView *logTextView;
	IBOutlet UITextField *messageTextField;
}

- (void)addLog:(NSString*)logString;

@end

#import "ViewControllers.h"

@interface MakeVirusViewController ()

@end


@implementation MakeVirusViewController
{
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//作成ボタンを押した時の処理
- (IBAction)onMakeButtonCliked:(id)sender {
    UITabBarController *controller = self.tabBarController;
    controller.selectedViewController = [controller.viewControllers objectAtIndex: 2];
}

//画面の回転方向の指定
- (BOOL) shouldAutorotate
{
    return YES;
}

- (NSUInteger) supportedInterfaceOrientations
{
    // 横画面固定
    //return UIInterfaceOrientationMaskPortrait;
}

- (void)dealloc {
    [_makeButton release];
    [super dealloc];
}
@end
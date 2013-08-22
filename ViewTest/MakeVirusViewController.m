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
        // タブに表示する情報を設定します
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:
                           UITabBarSystemItemFavorites tag:1];
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

@end
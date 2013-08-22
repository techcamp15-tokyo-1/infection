#import "ProfileViewControllerFactory.h"
#import "ViewControllers.h"

@implementation ProfileViewControllerFactory

+ (UIViewController*) createProfileViewController
{
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    
    // タブに登録したいViewControllerを配列に追加
    [viewControllers addObject:[[ProfileViewController alloc] init]];
    [viewControllers addObject:[[MakeVirusViewController alloc] init]];
    [viewControllers addObject:[[SpreadViewController alloc] init]];
    
    // タブを作成して返す
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = viewControllers;
    return tabBarController;
}

@end
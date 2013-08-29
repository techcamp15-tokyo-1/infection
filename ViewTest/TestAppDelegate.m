//
//  TestAppDelegate.m
//  ViewTest
//
//  Created by techcamp on 13/08/22.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import "TestAppDelegate.h"
#import "TestAppDelegate.h"
#import "AudioPlayer.h"
#import "MyGKSessionDelegate.h"
#import "UIApplication+UIID.h"
#import "HTTPRequester.h"

@implementation TestAppDelegate

@synthesize virusData = _virusData;
@synthesize pointData = _pointData;
@synthesize viewData = _viewData;
@synthesize inSpreadVirusId = _inSpreadVirudId;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //    self.window.backgroundColor = [UIColor whiteColor];
    //
    //    // Factory Methodを用いてメイン画面を生成し、ウィンドウに登録
    //    viewController = [ProfileViewControllerFactory createProfileViewController];
    //    [self.window setRootViewController:viewController];
    //
    //    [self.window makeKeyAndVisible];
    //    return YES;
    
    //view間で受け渡すデータの初期化
    pointData = [NSNumber numberWithInt:0];
    self.pointData = [NSNumber numberWithInt:0];
    viewData = VIEW_VIRUS_LIST;
    self.viewData = VIEW_VIRUS_LIST;
    [self initializeProfile];
    
    //background処理の初期化
    NSLog(@"initializing ...");
    NSUserDefaults* nd = [NSUserDefaults standardUserDefaults];
    NSString* name = [[UIApplication sharedApplication] uniqueInstallationIdentifier];
    [nd setObject:name forKey:@"Name"];
    return YES;
}

//ユーザーデフォルトの削除
- (void)deleteUserDefault:(NSString*)key
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:key];
}

//初回起動時にnilになるのを防ぐため、user defaultを初期化
- (void)initializeProfile
{
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionaryWithCapacity:1];
    //nameの初期値を設定
    //virus countの初期値
    [defaultValues setValue:@"" forKey:NAME_KEY];
    [defaultValues setValue:@0 forKey:@"#Viruses"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //初期値をUserDefaultに適用
    [userDefaults registerDefaults:defaultValues];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

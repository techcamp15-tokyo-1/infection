//
//  TestViewController.m
//  ViewTest
//
//  Created by techcamp on 13/08/22.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import "ViewControllers.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

//ボタン押下時の処理
- (IBAction)responseToButtonClick:(id)sender {
    //textviewから値を取得
    NSString *text = self.nameText.text;
    
    //TODO
    //textの値を用いて通信
    //TODO
    //通信結果によって場合分け
    
    //値をuser defaultに書き出し
    [self writeProtile:text];
    
    //viewの遷移
    [self changeViewToMakeVirus];
}


//make virus viewへの遷移
- (void)changeViewToMakeVirus
{
    UITabBarController *controller = self.tabBarController;
    controller.selectedViewController = [controller.viewControllers objectAtIndex: 1];    
}


//初回起動時にnilになるのを防ぐため、user defaultを初期化
- (void)initializeProfile
{
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionaryWithCapacity:1];
    //nameの初期値を設定
    [defaultValues setValue:@"" forKey:NAME_KEY];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //初期値をUserDefaultに適用
    [userDefaults registerDefaults:defaultValues];
}


//ユーザーデフォルトから読み込み
- (void)readProfile
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *nameStr = [userDefaults stringForKey:NAME_KEY];
    self.nameText.text = nameStr;
}


//ユーザーでフォルトへの書き出し
- (void)writeProtile:(NSString*) nameStr
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nameStr forKey:NAME_KEY];
    [userDefaults synchronize];
}


//returnが押されるとキーボードを隠す
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //プロファイルの初期化・読み込み
    [self initializeProfile];
    [self readProfile];
    self.nameText.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}


- (BOOL) shouldAutorotate {
    return YES;
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)dealloc {
    [_nameText release];
    [_registerButton release];
    [super dealloc];
}
@end
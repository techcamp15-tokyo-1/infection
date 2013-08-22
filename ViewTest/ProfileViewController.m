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
        // タブに表示する情報を設定します
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:
                           UITabBarSystemItemFeatured tag:0];
        //ImageViewの初期化
        _ProfileImage = [[UIImageView alloc] initWithFrame:CGRectMake(140.0, 0.0, 40.0, 40.0)];
        [self.view addSubview:_ProfileImage];
        //Buttonの追加
    }
    return self;
}

- (IBAction)responseToButtonClick:(id)sender {
    //TODO
    //登録ボタンをクリック
    //その後ウイルス作成に遷移
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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

//画面の回転方向の指定
- (BOOL) shouldAutorotate
{
    return NO;
}

- (NSUInteger) supportedInterfaceOrientations
{
    // 横画面固定
    //return UIInterfaceOrientationMaskPortrait;
}

- (void)dealloc {
    [_ProfileImage release];
    [_NameText release];
    [_RegisterButton release];
    [super dealloc];
}
@end
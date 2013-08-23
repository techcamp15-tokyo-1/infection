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
    NSString *text = _nameText.text;
    //TODO
    //サーバーとの通信開始
    [self changeViewToMakeVirus];
}


//make virus viewへの遷移
- (void)changeViewToMakeVirus
{
    UITabBarController *controller = self.tabBarController;
    controller.selectedViewController = [controller.viewControllers objectAtIndex: 1];    
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
	// Do any additional setup after loading the view, typically from a nib.
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
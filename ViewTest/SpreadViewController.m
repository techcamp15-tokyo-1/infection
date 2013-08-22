//
//  SpreadViewController.m
//  test
//
//  Created by techcamp on 13/08/22.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import "SpreadViewController.h"

@interface SpreadViewController ()

@end

@implementation SpreadViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

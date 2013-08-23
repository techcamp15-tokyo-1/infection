//
//  VirusDetailViewController.m
//  Infection
//
//  Created by techcamp on 13/08/22.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import "VirusDetailViewController.h"

@implementation VirusDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

- (void)dealloc {
//    [_VirusImage release];
//    [_infectionRate release];
//    [_spreadButton release];
//    [super dealloc];
}


//-(IBAction)pressCancelButton:(id)sender
//{
//    // [3] delegate オブジェクトにメッセージを送信
//    if([_delegate respondsToSelector:@selector(didPressCloseButton)]){
//        [_delegate didPressCloseButton];
//    }
//}
//
//-(IBAction)pressExecuteButton:(id)sender
//{
//    // [3] delegate オブジェクトにメッセージを送信
//    if([_delegate respondsToSelector:@selector(didPressCloseButton)]){
//        [_delegate didPressCloseButton];
//    }
//}

@end

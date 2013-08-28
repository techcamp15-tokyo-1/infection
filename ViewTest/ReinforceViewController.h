//
//  ReinforceViewController.h
//  Infection
//
//  Created by techcamp on 13/08/26.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Virus.h"
#import "UserDefaultKey.h"

//画面表示切り替えのパターン
#define VIEW_VIRUS_LIST 0
#define VIEW_REINFORCE 1

@interface ReinforceViewController : UIViewController
{
    @private    
    Virus *selectedVirus;
    NSNumber *point;
}

- (void)initViewItem;


@property (retain, nonatomic) IBOutlet UILabel *nowPointLabel;
@property (retain, nonatomic) IBOutlet UILabel *nowPointValue;
@property (retain, nonatomic) IBOutlet UILabel *nameValue;
@property (retain, nonatomic) IBOutlet UILabel *infectionLabel;
@property (retain, nonatomic) IBOutlet UILabel *durabilityLabel;
@property (retain, nonatomic) IBOutlet UILabel *infectionValue;
@property (retain, nonatomic) IBOutlet UILabel *durabilityValue;
@property (retain, nonatomic) IBOutlet UIStepper *infectionStepper;
@property (retain, nonatomic) IBOutlet UIStepper *durabilityStepper;
@property (retain, nonatomic) IBOutlet UIButton *cancelButton;
@property (retain, nonatomic) IBOutlet UIButton *okButton;

@property (retain, nonatomic) IBOutlet UIBarButtonItem *blueToothSwitch;

@end

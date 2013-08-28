//
//  MakeViewController.h
//  test
//
//  Created by techcamp on 13/08/21.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyGKSessionDelegate.h"

#define MAX_SUM_PARAM 100

@interface MakeVirusViewController : UIViewController <UITextFieldDelegate>
{
    @private
    NSInteger point;
}

- (IBAction)backgroundTapped:(id)sender;
- (void)initViewItem;

@property (retain, nonatomic) IBOutlet UILabel *remnantValue;
@property (retain, nonatomic) IBOutlet UITextField *nameText;
@property (retain, nonatomic) IBOutlet UIButton *makeButton;

@property (retain, nonatomic) IBOutlet UILabel *infectionRateValue;
@property (retain, nonatomic) IBOutlet UIStepper *infectionRateStepper;
@property (retain, nonatomic) IBOutlet UILabel *durabilityValue;
@property (retain, nonatomic) IBOutlet UIStepper *durabilityStepper;

@property (retain, nonatomic) IBOutlet UISwitch *blueToothSwitch;

@end

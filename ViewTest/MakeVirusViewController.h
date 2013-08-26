//
//  MakeViewController.h
//  test
//
//  Created by techcamp on 13/08/21.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MAX_SUM_PARAM 100

@interface MakeVirusViewController : UIViewController <UITextFieldDelegate>
- (IBAction)backgroundTapped:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *infectionRateText;
@property (retain, nonatomic) IBOutlet UILabel *remnantText;
@property (retain, nonatomic) IBOutlet UITextField *durabilityText;
@property (retain, nonatomic) IBOutlet UIButton *makeButton;
@end

//
//  TestViewController.h
//  ViewTest
//
//  Created by techcamp on 13/08/22.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController <UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UITextField *nameText;
@property (retain, nonatomic) IBOutlet UIButton *registerButton;

- (IBAction)responseToButtonClick:(id)sender;

@end

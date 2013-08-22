//
//  TestViewController.h
//  ViewTest
//
//  Created by techcamp on 13/08/22.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIImageView *ProfileImage;
@property (retain, nonatomic) IBOutlet UITextField *NameText;
@property (retain, nonatomic) IBOutlet UIButton *RegisterButton;

- (IBAction)responseToButtonClick:(id)sender;

@end

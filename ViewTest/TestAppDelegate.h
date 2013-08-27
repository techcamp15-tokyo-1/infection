//
//  TestAppDelegate.h
//  ViewTest
//
//  Created by techcamp on 13/08/22.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Virus.h"
#import "ReinforceViewController.h"

@interface TestAppDelegate : UIResponder <UIApplicationDelegate>
{
    Virus *virusData;
    NSNumber *pointData;
    NSInteger viewData;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Virus *virusData;
@property (strong, nonatomic) NSNumber *pointData;
@property (nonatomic) NSInteger viewData;

@end
//
//  ReinforceListViewController.h
//  Infection
//
//  Created by techcamp on 13/08/28.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Virus.h"
#import "TestAppDelegate.h"

@interface ReinforceListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    @private
    NSMutableArray *itemArray;
    //選択したウイルス
    Virus *selectedVirus;
}

@property (retain, nonatomic) IBOutlet UITableView *virusList;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *blueToothSwitch;
@end

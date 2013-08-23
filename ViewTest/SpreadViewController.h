//
//  TableViewViewController.h
//  TableView
//
//  Created by picaudiopro on 9/22/11.
//  Copyright 2011 picaudiopro. All rights reserved.
//

#import <UIKit/UIKit.h>


//画面表示切り替えのパターン
#define VIEW_VIRUS_LIST 0
#define VIEW_SPREAD 1
#define VIEW_POINT_GET 2

@interface SpreadViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    
    @private
    NSInteger view_mode;
    BOOL isShowTable;
    
	IBOutlet UILabel *textLabel;
	NSArray *itemArray;
}

@property (retain, nonatomic) IBOutlet UILabel *spreadText;
@property (retain, nonatomic) IBOutlet UITableView *virusList;
@property (retain, nonatomic) IBOutlet UILabel *pointGetText;
@property (retain, nonatomic) IBOutlet UIButton *toReinnforceTabButton;

@end


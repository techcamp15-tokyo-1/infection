//
//  TableViewViewController.h
//  TableView
//
//  Created by picaudiopro on 9/22/11.
//  Copyright 2011 picaudiopro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Virus.h"


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
	NSMutableArray *itemArray;
    
    //選択したウイルスのid
    NSInteger virus_id;
    
    //タイマーの切り替えが必要なため、管理しておく必要がある
    NSTimer *timer;
}

- (void)createTimer;
- (void)doTimer:(NSTimer *)timer;
- (void)getVirusNumber;

- (IBAction)onToReinforceViewButtonClicked:(id)sender;

@property (retain, nonatomic) IBOutlet UILabel *spreadText;
@property (retain, nonatomic) IBOutlet UILabel *infectedPersonText;
@property (retain, nonatomic) IBOutlet UILabel *infectedNumberText;
@property (retain, nonatomic) IBOutlet UITableView *virusList;
@property (retain, nonatomic) IBOutlet UILabel *pointGetText;
@property (retain, nonatomic) IBOutlet UIButton *toReinnforceTabButton;

@end


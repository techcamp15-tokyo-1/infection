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

@interface SpreadViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    @private
    NSInteger view_mode;
    
	IBOutlet UILabel *textLabel;
	NSMutableArray *itemArray;
    
    //選択したウイルス
    Virus *selectedVirus;
    //総感染人数
    NSNumber *totalInfectedNumber;
    
    //タイマーの切り替えが必要なため、管理しておく必要がある
    NSTimer *timer;
}

@property (retain, nonatomic) IBOutlet UITableView *virusList;
- (void)createTimer;
- (void)doTimer:(NSTimer *)timer;
- (void)getVirusNumber;

- (IBAction)onToReinforceViewButtonClicked:(id)sender;

@end


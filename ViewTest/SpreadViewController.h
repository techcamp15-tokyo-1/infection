//
//  TableViewViewController.h
//  TableView
//
//  Created by picaudiopro on 9/22/11.
//  Copyright 2011 picaudiopro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VirusDetailViewController.h"



@interface SpreadViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
{
    @private
    BOOL isShowTable;
    
	IBOutlet UILabel *textLabel;
	NSArray *itemArray;
    
    IBOutlet UITableView *virusList;
    IBOutlet UILabel *text;
}

@end


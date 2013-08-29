//
//  TableViewViewController.m
//  TableView
//
//  Created by picaudiopro on 9/22/11.
//  Copyright 2011 picaudiopro. All rights reserved.
//

#import "SpreadViewController.h"
#import <GameKit/GameKit.h>
#import "MyGKSessionDelegate.h"
#import "AudioPlayer.h"
#import "HTTPRequester.h"
#import "JSONConverter.h"
#import "UserDefaultKey.h"
#import "ReinforceViewController.h"
#import "TestAppDelegate.h"

@implementation SpreadViewController


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _virusList.delegate = self;
    _virusList.dataSource  = self;
    
    //navigation barの背景を変更
    UIColor *red = [UIColor colorWithRed:0.5 green:0.2 blue:0.2 alpha:1.0];
    [self.navigationController.navigationBar setTintColor:red];
    
    //フィールド値の初期化
    view_mode = VIEW_VIRUS_LIST;
    totalInfectedNumber = [NSNumber numberWithInt:0];
    [self switchView:view_mode];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.virusList reloadData];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[itemArray release];
    [_virusList release];
    [super dealloc];
}


//tableviewと拡散中の切り替え
- (void)switchView:(NSInteger)mode{
    view_mode = mode;
}



/**
 * ウイルス一覧
 */

//
//  tableView:numberOfRowsInSection
//    NSArrayにデータをセットして、その個数を返す。
//    本メソッドは、UITableViewDataSourceプロトコルを採用しているのでコールされる。
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [self getVirusListFromUserDefault];
    
	return [itemArray count];
}

//ユーザーデフォルトからリストを取得
- (void)getVirusListFromUserDefault
{
    itemArray = [[NSMutableArray alloc] init];
    
    NSUserDefaults *_userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* array = [_userDefaults arrayForKey:VIRUS_LIST_KEY];
    for ( NSDictionary* object in array ) {
        Virus *virus = [[Virus alloc] initWithDictionary:object];
        [itemArray addObject:virus];
    }
}

//
//  tableView:cellForRowAtIndexPath
//    CellにNSArrayに登録されている文字列を設定
//    本メソッドは、UITableViewDataSourceプロトコルを採用しているのでコールされる。
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	cell = [[[UITableViewCell alloc] init] autorelease];
    cell.backgroundColor = [UIColor clearColor];
    
    UILabel *textView = [[UILabel alloc] initWithFrame:CGRectMake(40, 2, 160, 40)];
    textView.text = [[itemArray objectAtIndex: indexPath.row] getName];
    textView.backgroundColor = [UIColor clearColor];
    textView.textColor = [UIColor blackColor];
    [textView setFont:[UIFont systemFontOfSize:25]];
    
    [cell addSubview:textView];
    
    //セルに画像を追加
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(240, 0, 40, 40)];
    
    NSString *path;
    //アイコンを変更
    switch ([[[itemArray objectAtIndex: indexPath.row] getImageNo] intValue]) {
        case 0:
            path = [[NSString alloc] initWithString:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"img115_22.png"]];
            break;
            
        case 1:
            path = [[NSString alloc] initWithString:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"img115_71.png"]];
            break;
            
        default:
            path = [[NSString alloc] initWithString:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"img115_31.png"]];
            break;
    }
    UIImage *bkgImg = [[UIImage alloc] initWithContentsOfFile:path];
    [imageView setImage:bkgImg];
    [bkgImg release];
    [path release];
    
    [cell addSubview:imageView];
    
	return cell;
}


//
//  tableView:didSelectRowAtIndexPath
//    選択されたCellの文字列をToolBarにあるLabelにセットし表示する。
//    本メソッドは、UITableViewDelegateプロトコルを採用しているのでコールされる。
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //選択したvirusを保持
    selectedVirus = [itemArray objectAtIndex:[indexPath row]];
    TestAppDelegate *testAppDelegate = [[UIApplication sharedApplication] delegate];
    testAppDelegate.virusData = selectedVirus;
    
    //詳細に遷移
    [self performSegueWithIdentifier:@"toDetailView" sender:self];
}

@end

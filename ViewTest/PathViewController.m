//
//  PathViewController.m
//  Infection
//
//  Created by techcamp on 13/08/28.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import "PathViewController.h"

@interface PathViewController ()

@end

@implementation PathViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _virusList.delegate = self;
    _virusList.dataSource  = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_virusList release];
    [_blueToothSwitch release];
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.virusList reloadData];
    [super viewWillAppear:animated];
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
	cell.textLabel.text = [[itemArray objectAtIndex: indexPath.row] getName];
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
    [self performSegueWithIdentifier:@"toWebView" sender:self];
}

- (IBAction)onBlutToothSwitchClicked:(id)sender {
    //TODO
}

@end

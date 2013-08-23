//
//  TableViewViewController.m
//  TableView
//
//  Created by picaudiopro on 9/22/11.
//  Copyright 2011 picaudiopro. All rights reserved.
//

#import "SpreadViewController.h"


@implementation SpreadViewController

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _virusList.delegate = self;
    _virusList.dataSource  = self;
    
    view_mode = VIEW_VIRUS_LIST;
    [self switchView:view_mode];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
    [_spreadText release];
    [_spreadText release];
    [_toReinnforceTabButton release];
    [_pointGetText release];
    [super dealloc];
}


//tableviewと拡散中の切り替え
- (void)switchView:(NSInteger)mode{
    view_mode = mode;
    
    switch(view_mode){
        case VIEW_VIRUS_LIST:
            _virusList.hidden = NO;
            _spreadText.hidden = YES;
            _pointGetText.hidden = YES;
            _toReinnforceTabButton.hidden = YES;
            break;
        case VIEW_SPREAD:
            _virusList.hidden = YES;
            _spreadText.hidden = NO;
            _pointGetText.hidden = YES;
            _toReinnforceTabButton.hidden = YES;
            break;
        case VIEW_POINT_GET:
            _virusList.hidden = YES;
            _spreadText.hidden = YES;
            _pointGetText.hidden = NO;
            _toReinnforceTabButton.hidden = NO;
            break;
    }
}



/**
 * ウイルス一覧
 */

//TODO
//サーバーからArrayを受け取ってリスト表示
//
//  tableView:numberOfRowsInSection
//    NSArrayにデータをセットして、その個数を返す。
//    本メソッドは、UITableViewDataSourceプロトコルを採用しているのでコールされる。
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	itemArray = [[NSArray alloc] initWithObjects:@"Spade", @"Club", @"Diamond", @"Heart", nil];
	return [itemArray count];
}


//
//  tableView:cellForRowAtIndexPath
//    CellにNSArrayに登録されている文字列を設定
//    本メソッドは、UITableViewDataSourceプロトコルを採用しているのでコールされる。
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	cell = [[[UITableViewCell alloc] init] autorelease];
	cell.textLabel.text = [itemArray objectAtIndex: indexPath.row];
	return cell;
}


//
//  tableView:didSelectRowAtIndexPath
//    選択されたCellの文字列をToolBarにあるLabelにセットし表示する。
//    本メソッドは、UITableViewDelegateプロトコルを採用しているのでコールされる。
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	textLabel.text = [itemArray objectAtIndex:[indexPath row]];
    
    //alertの表示
    [self showVirusDetail:[itemArray objectAtIndex:[indexPath row]] :@0.5:@0.5];
}

//ウイルス拡散alertの表示
- (void)showVirusDetail:(NSString *) virus_name :(NSNumber *) virus_infection_rate :(NSNumber *)virus_durability{
 
    UIAlertView *virusDetailAlert = [[UIAlertView alloc] initWithTitle:virus_name message:@"このウイルスを拡散しますか？" delegate:self cancelButtonTitle:@"やめる" otherButtonTitles:@"実行", nil];
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(220, 10, 40, 40)];
//    
//    NSString *path = [[NSString alloc] initWithString:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"smile.png"]];
//    UIImage *bkgImg = [[UIImage alloc] initWithContentsOfFile:path];
//    [imageView setImage:bkgImg];
//    [bkgImg release];
//    [path release];
    
//    [virusDetailAlert addSubview:imageView];
//    [imageView release];
    
    [virusDetailAlert show];
    [virusDetailAlert release];
}

//alertのボタン押下時の処理
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    switch (buttonIndex) {
        case 0: // cancel
            [self switchView:VIEW_VIRUS_LIST];
            break;
        case 1: // execute
            [self switchView:VIEW_SPREAD];
            break;
        default: // cancelとか
            break;
    }
}



/**
 * 拡散中
 */


/**
 * Point Get
 */
- (IBAction)onToReinforceButtonClicked:(id)sender {
    UITabBarController *controller = self.tabBarController;
    controller.selectedViewController = [controller.viewControllers objectAtIndex: 3];
}

@end

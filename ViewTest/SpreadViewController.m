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
    [_toReinnforceTabButton release];
    [_pointGetText release];
    [_infectedNumberText release];
    [_infectedPersonText release];
    [super dealloc];
}


//tableviewと拡散中の切り替え
- (void)switchView:(NSInteger)mode{
    view_mode = mode;
    
    switch(view_mode){
        case VIEW_VIRUS_LIST:
            _virusList.hidden = NO;
            _spreadText.hidden = YES;
            _infectedPersonText.hidden = YES;
            _infectedNumberText.hidden = YES;
            _pointGetText.hidden = YES;
            _toReinnforceTabButton.hidden = YES;
            break;
        case VIEW_SPREAD:
            _virusList.hidden = YES;
            _spreadText.hidden = NO;
            _infectedPersonText.hidden = NO;
            _infectedNumberText.hidden = NO;
            _pointGetText.hidden = YES;
            _toReinnforceTabButton.hidden = YES;
            break;
        case VIEW_POINT_GET:
            _virusList.hidden = YES;
            _spreadText.hidden = YES;
            _infectedPersonText.hidden = YES;
            _infectedNumberText.hidden = YES;
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
    itemArray = [[NSMutableArray alloc] init];
    Virus *virus1 = [[Virus alloc] initWithValue:@0 :@"virus1" :@100 :@100];
    Virus *virus2 = [[Virus alloc] initWithValue:@1 :@"virus2" :@100 :@100];
    Virus *virus3 = [[Virus alloc] initWithValue:@2 :@"virus3" :@100 :@100];
    
    [itemArray addObject:virus1];
    [itemArray addObject:virus2];
    [itemArray addObject:virus3];
    
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
	cell.textLabel.text = [[itemArray objectAtIndex: indexPath.row] getName];
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
    [self showVirusDetail:[itemArray objectAtIndex:[indexPath row]]];
}

//ウイルス拡散alertの表示
//- (void)showVirusDetail:(NSString *)virus_name :(NSNumber *)virus_infection_rate :(NSNumber *)virus_durability{
- (void)showVirusDetail:(Virus*) virus {
    UIAlertView *virusDetailAlert = [[UIAlertView alloc] initWithTitle:[virus getName] message:@"このウイルスを拡散しますか？" delegate:self cancelButtonTitle:@"やめる" otherButtonTitles:@"実行", nil];
    
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
        case 1:
        {
            //TODO
            //アプリ起動時にBT通信Sessionを作成しておき、ここではGKSessionでaddVirusを行う
            //blue tooth 通信の開始
            [AudioPlayer playDummyAudioBackground];
            GKSession* session = [[GKSession alloc] initWithSessionID: @"infection" displayName:nil sessionMode:GKSessionModePeer];
            MyGKSessionDelegate* delegate = [MyGKSessionDelegate sharedInstance];
            [delegate addVirus:[[Virus alloc] initWithValue:@1 :@"virus_test" :@10 :@100]];
            session.delegate = delegate;
            [session setDataReceiveHandler:[MyGKSessionDelegate sharedInstance] withContext:nil];
            session.available = YES;
            
            //画面遷移の設定
            [self switchView:VIEW_SPREAD];
            //デフォルトの感染人数の設定
            _infectedNumberText.text = [[NSString alloc] initWithFormat:@"1"];
            
            //タイマーの開始
            [self createTimer];
            
            break;
        }
        default: // cancelとか
            break;
    }
}



/**
 * 拡散中
 */
/**
 * タイマーを生成する
 */
- (void)createTimer
{
    // 指定時間経過後に呼び出すメソッドに渡すデータをセット(この場合はなくてもいいかも？)
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Snoopy", @"name",
                              [NSNumber numberWithInt:10], @"age", nil];
    
    // タイマーを生成:Intervalで時間(sec),repeatsで繰り返し(YES,NO)
    timer = [NSTimer scheduledTimerWithTimeInterval:60.0f
                                     target:self
                                   selector:@selector(doTimer:)
                                   userInfo:userInfo
                                    repeats:YES
     ];
    
}

/**
 * 指定時間後にタイマーから呼ばれる
 * @param timer 呼び出し元のNSTimerオブジェクト
 */
- (void)doTimer:(NSTimer *)timer
{
    NSLog(@"Timer func is called.");
    [self getVirusNumber];
}

/**
 * サーバーにvirus_idでPOSTし、JSONの結果を受信
 * TODO 引数にセットしたデータを送信
 */
- (void)getVirusNumber
{
    NSLog(@"HTTP POST to get number of infected person.");
    
    //定数化して持つべき
    NSString *url = @"http://www53.atpages.jp/infectionapp/state.php/";
    NSDictionary *virus_info = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @0, @"virus_id", nil];
    //HTTP POST REQUESTを送信
    NSData *response = [HTTPRequester sendPostWithDictionary:url :virus_info];
    
    //POST結果を文字列で出力
    NSString *myString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"%@",myString);

    //NSDictionaryに変換
    NSDictionary *dictionary = [JSONConverter objectFrom:response];
    
    //結果からinfected_nowを取得し、現在の感染人数を反映
    NSInteger number = [[dictionary objectForKey:@"infected_now"] intValue];
    _infectedNumberText.text = [[NSString alloc] initWithFormat:@"%d",number];
    
    //infected_nowが0になった時点でタイマーの繰り返しを切って画面遷移
    //TODO
    //BT通信を一旦切る?
    if(number <= 0){
        if(timer != nil){
            NSLog(@"Timer is killed because no person is infected with user's virus.");
            [timer invalidate];
            //画面遷移
            [self switchView:VIEW_POINT_GET];
        }
    }
}


/**
 * Point Get
 */
- (IBAction)onToReinforceViewButtonClicked:(id)sender {
    //ウイルス強化タブに移動
    UITabBarController *controller = self.tabBarController;
    controller.selectedViewController = [controller.viewControllers objectAtIndex: 3];
    //ウイルス強化画面に移動したら、view_modeをvirusの選択リストに戻す
    [self switchView:VIEW_VIRUS_LIST];

}

@end

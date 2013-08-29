//
//  VirusDetailViewController.m
//  Infection
//
//  Created by techcamp on 13/08/22.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import "VirusDetailViewController.h"
#import "AudioPlayer.h"

@implementation VirusDetailViewController

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
    
    //navigation barの背景を変更
    UIColor *red = [UIColor colorWithRed:0.5 green:0.2 blue:0.2 alpha:1.0];
    [self.navigationController.navigationBar setTintColor:red];

    //フィールド値の初期化
    view_mode = VIEW_DETAIL;
    isInSpread = NO;
    
    [self switchView:view_mode];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_nameValue release];
    [_infectionValue release];
    [_durabilityValue release];
    [_executeButton release];
    [_inSpreadLabel release];
    [_toReinforceViewButton release];
    [_infectedNowLabel release];
    [_infectedNowValue release];
    [_infectedTotalLabel release];
    [_infectedTotalValue release];
    [_getPointLabel release];
    [_getPointValue release];
    [_virusImage release];
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated
{
    //view表示時に通信中ならデータを受け取らない
    if(!isInSpread){
        //データを受け取って、ラベルに表示する
        TestAppDelegate *testAppDelegate = [[UIApplication sharedApplication] delegate];
        selectedVirus = testAppDelegate.virusData;
        NSString *temp = testAppDelegate.inSpreadVirusId;
        NSLog(@"%@", temp);
    
        //itemの初期化
        self.nameValue.text = [selectedVirus getName];
        self.infectionValue.text = [[selectedVirus getInfectionRate] stringValue];
        self.durabilityValue.text = [[selectedVirus getDurability] stringValue];
        //アイコンを変更
        switch ([[selectedVirus getImageNo] intValue]) {
                UIImage *img = [UIImage new];
            case 0:
                img = [UIImage imageNamed:@"img115_22.png"];
                self.virusImage.image = img;
                break;
                
            case 1:
                img = [UIImage imageNamed:@"img115_71.png"];
                self.virusImage.image = img;
                break;
                
            default:
                img = [UIImage imageNamed:@"img115_31.png"];
                self.virusImage.image = img;
                break;
        }
    }
    
    [self switchView:view_mode];
    
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    //ウイルス一覧に遷移
    if(!isInSpread){
        [self.navigationController popViewControllerAnimated:YES];
    }
}


//tableviewと拡散中の切り替え
- (void)switchView:(NSInteger)mode{
    view_mode = mode;
    
    switch(view_mode){
        case VIEW_DETAIL:
            _executeButton.hidden = NO;
            _inSpreadLabel.hidden = YES;
            _infectedNowLabel.hidden = YES;
            _infectedNowValue.hidden = YES;
            _infectedTotalLabel.hidden = YES;
            _infectedTotalValue.hidden = YES;
            _toReinforceViewButton.hidden = YES;
            _getPointLabel.hidden = YES;
            _getPointValue.hidden = YES;
            break;
        case VIEW_IN_SPREAD:
            _executeButton.hidden = YES;
            _inSpreadLabel.hidden = NO;
            _infectedNowLabel.hidden = NO;
            _infectedNowValue.hidden = NO;
            _infectedTotalLabel.hidden = NO;
            _infectedTotalValue.hidden = NO;
            _toReinforceViewButton.hidden = YES;
            _getPointLabel.hidden = YES;
            _getPointValue.hidden = YES;
            break;
        case VIEW_POINT:
            _executeButton.hidden = YES;
            _inSpreadLabel.hidden = YES;
            _infectedNowLabel.hidden = YES;
            _infectedNowValue.hidden = YES;
            _infectedTotalLabel.hidden = YES;
            _infectedTotalValue.hidden = YES;
            _toReinforceViewButton.hidden = NO;
            _getPointLabel.hidden = NO;
            _getPointValue.hidden = NO;
            break;
    }
}


- (IBAction)onButtonClicked:(id)sender {
    UIAlertView *virusDetailAlert = [[UIAlertView alloc] initWithTitle:[selectedVirus getName] message:@"このウイルスを拡散しますか？" delegate:self cancelButtonTitle:@"やめる" otherButtonTitles:@"実行", nil];
    
    [virusDetailAlert show];
    [virusDetailAlert release];
}


//alertのボタン押下時の処理
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    
    switch (buttonIndex) {
        case 0: // cancel
            break;
        case 1:
        {
            TestAppDelegate *testAppDelegate = [[UIApplication sharedApplication] delegate];
            testAppDelegate.inSpreadVirusId = [selectedVirus getVirusId];
            
            //blue tooth 通信の開始
            [AudioPlayer playDummyAudioBackground];
            NSString* name = [[NSUserDefaults standardUserDefaults] objectForKey:@"Name"];
            GKSession* session = [[GKSession alloc] initWithSessionID: @"infection" displayName:name sessionMode:GKSessionModePeer];
            MyGKSessionDelegate* delegate = [MyGKSessionDelegate sharedInstance];
            session.delegate = delegate;
            [session setDataReceiveHandler:[MyGKSessionDelegate sharedInstance] withContext:nil];
            session.available = YES;
            NSDictionary* virus_dict = [selectedVirus toNSDictionary];
            [HTTPRequester sendAsynchPostWithDictionary:@"http://nokok.dip.jp/infectionapp/spread.php" :virus_dict];
            [delegate addVirus:selectedVirus : NO];
            
            //拡散中のフラグをたてる
            isInSpread = YES;
            //画面遷移の設定
            [self switchView:VIEW_IN_SPREAD];
            //デフォルトの感染人数の設定
            self.infectedNowValue.text = [[NSString alloc] initWithFormat:@"1"];
            self.infectedTotalValue.text = [[NSString alloc] initWithFormat:@"1"];
            
            //タイマーの開始
            [self createTimer];
            
            //一覧に戻ってしまうと処理が面倒なのでとりあえず拡散中は戻れないようにしておく
            [self.navigationItem setHidesBackButton:YES];
             
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
    timer = [NSTimer scheduledTimerWithTimeInterval:30.0f
                                             target:self
                                           selector:@selector(doTimer:)
                                           userInfo:nil
                                            repeats:NO
             ];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

/**
 * 指定時間後にタイマーから呼ばれる
 * @param timer 呼び出し元のNSTimerオブジェクト
 */
- (void)doTimer:(NSTimer *)timer
{
    [self getVirusNumber];
}

/**
 * サーバーにvirus_idでPOSTし、JSONの結果を受信
 * TODO 引数にセットしたデータを送信
 */
- (void)getVirusNumber
{
    NSLog(@"timer invalidated");
    [timer invalidate];
    [timer retain];
    NSLog(@"HTTP POST to get number of infected person.");
    
    //定数化して持つべき
    NSString *urlstr = @"http://nokok.dip.jp/infectionapp/state.php/";
    NSDictionary* virus_dict = [selectedVirus toNSDictionary];
    NSLog(@"VIRUSDICT");
    NSLog(@"%@", virus_dict);
    //HTTP POST REQUESTを送信
    NSURL* url = [NSURL URLWithString:urlstr];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[[HTTPRequester postString:virus_dict] dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSLog(@"Response from %@", urlstr);
         if ([data length] >0 && error == nil)
         {
             //POST結果を文字列で出力
             NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
             //NSDictionaryに変換
             NSDictionary *dictionary = [JSONConverter objectFrom:data];
             // レスポンスで画面を更新
             NSInteger number = [[dictionary objectForKey:@"infected_now"] intValue];
             self.infectedNowValue.text = [[NSString alloc] initWithFormat:@"%d",number];
             NSInteger total_number = [[dictionary objectForKey:@"infected_total"] intValue];
             self.infectedTotalValue.text = [[NSString alloc] initWithFormat:@"%d",total_number];
             //infected_nowが0になった時点でタイマーの繰り返しを切って画面遷移
             if(number <= 0){
                 if(timer != nil){
                     //拡散中のフラグをリセット
                     isInSpread = NO;
                     NSLog(@"Timer is killed because no person is infected with user's virus. total %ld", (long)total_number);
                     [timer invalidate];
                     //総感染数をフィールドにセット
                     totalInfectedNumber = [NSNumber numberWithInt:total_number];
                     self.getPointValue.text = [totalInfectedNumber stringValue];
                     //画面遷移
                     [self switchView:VIEW_POINT];
                     return;
                 }
             }
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Nothing was downloaded.");
         }
         else if (error != nil){
             NSLog(@"Error = %@", error);
         }
         NSLog(@"timer fired");
         [self createTimer];
     }];
}


/**
 * Point Get
 */
- (IBAction)onToReinforceViewButtonClicked:(id)sender {
    //reinforceViewControllerにvirusを渡す
    //データを送る準備
    TestAppDelegate *testAppDelegate = [[UIApplication sharedApplication] delegate];
    testAppDelegate.virusData = selectedVirus;
    testAppDelegate.pointData = totalInfectedNumber;
    testAppDelegate.viewData = VIEW_REINFORCE;//reinforce_viewとで定数が被らないようにする
    //ウイルス強化タブに移動
    UITabBarController *controller = self.tabBarController;
    controller.selectedViewController = [controller.viewControllers objectAtIndex: 2];
    //ウイルス強化画面に移動したら、view_modeをvirusの選択リストに戻す
    [self switchView:VIEW_DETAIL];
    //この時点で一覧に戻ることを許可
    [self.navigationItem setHidesBackButton:NO];
    //ウイルス一覧に遷移
    [self.navigationController popViewControllerAnimated:YES];
}

@end

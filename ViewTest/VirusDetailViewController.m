//
//  VirusDetailViewController.m
//  Infection
//
//  Created by techcamp on 13/08/22.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import "VirusDetailViewController.h"

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
    }
    
    [self switchView:view_mode];
    
    [super viewWillAppear:animated];
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
    BOOL connection_failed = NO;
    switch (buttonIndex) {
        case 0: // cancel
            break;
        case 1:
        {
            TestAppDelegate *testAppDelegate = [[UIApplication sharedApplication] delegate];
            testAppDelegate.inSpreadVirusId = [selectedVirus getVirusId];
            
            //blue tooth 通信の開始
            MyGKSessionDelegate* delegate = [MyGKSessionDelegate sharedInstance];
            NSDictionary* virus_dict = [selectedVirus toNSDictionary];
            NSData* response = [HTTPRequester sendPostWithDictionary:@"http://www53.atpages.jp/infectionapp/spread.php" :virus_dict];
            if (response == nil) {
                connection_failed = YES;
                break;
            }
            NSLog(@"%@", [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            [delegate addVirus:selectedVirus];
            
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
    if (connection_failed) {
        UIAlertView *connectionFailedAlert = [[UIAlertView alloc] initWithTitle:@"サーバーとの通信に失敗しました" message:@"もう一度拡散してください。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [connectionFailedAlert show];
        [connectionFailedAlert release];
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
    NSDictionary* virus_dict = [selectedVirus toNSDictionary];
    //HTTP POST REQUESTを送信
    NSData *response = [HTTPRequester sendPostWithDictionary:url :virus_dict];
    
    //POST結果を文字列で出力
    NSString *myString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"%@",myString);
    
    //NSDictionaryに変換
    NSDictionary *dictionary = [JSONConverter objectFrom:response];
    
    //結果からinfected_nowを取得し、現在の感染人数を反映
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
        }
    }
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
    //一覧に遷移
    [self.navigationController popViewControllerAnimated:YES];
}

@end

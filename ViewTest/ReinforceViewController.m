//
//  ReinforceViewController.m
//  Infection
//
//  Created by techcamp on 13/08/26.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import "ReinforceViewController.h"
#import "TestAppDelegate.h"

/*
@interface ReinforceViewController ()

@end
 */

@implementation ReinforceViewController

//TODO
//SpreadViewのpoint getから遷移するときにvirus, view_mode, pointを指定

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
    
    //値の初期化
    selectedVirus = [[Virus alloc] init];
    point = [NSNumber numberWithInt:0];
    [self initViewItem];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.virusList reloadData];
    
    //データを受け取って、ラベルに表示する
    TestAppDelegate *testAppDelegate = [[UIApplication sharedApplication] delegate];
    selectedVirus = testAppDelegate.virusData;
    point = testAppDelegate.pointData;
    view_mode = testAppDelegate.viewData;
    
    //viewを遷移
    [self switchView:view_mode];
}


- (void)initViewItem
{
    self.nowPointValue.text = @"0";
    self.nameValue.text = @"";
    self.infectionValue.text = @"0";
    self.durabilityValue.text = @"0";
    
    self.infectionStepper.value = 0;
    self.infectionStepper.minimumValue = 0;
    self.infectionStepper.maximumValue = 10;
    self.infectionStepper.stepValue = 1;
    
    self.durabilityStepper.value = 0;
    self.durabilityStepper.minimumValue = 0;
    self.durabilityStepper.maximumValue = 10;
    self.durabilityStepper.stepValue = 1;
}


//tableviewと拡散中の切り替え
- (void)switchView:(NSInteger)mode{
    view_mode = mode;
    
    switch(view_mode){
        case VIEW_VIRUS_LIST:
            self.virusList.hidden = NO;
            self.nowPointLabel.hidden = YES;
            self.infectionLabel.hidden = YES;
            self.durabilityLabel.hidden = YES;
            self.infectionValue.hidden = YES;
            self.durabilityValue.hidden = YES;
            self.infectionStepper.hidden = YES;
            self.durabilityStepper.hidden = YES;
            break;
            
        case VIEW_REINFORCE:
            self.virusList.hidden = YES;
            self.nowPointLabel.hidden = NO;
            self.infectionLabel.hidden = NO;
            self.durabilityLabel.hidden = NO;
            self.infectionValue.hidden = NO;
            self.durabilityValue.hidden = NO;
            self.infectionStepper.hidden = NO;
            self.durabilityStepper.hidden = NO;
            //stepper, itemの値をvirus, pointに従って変更
            //selectedVirusの値に従ってItemに値をセット
            self.nowPointValue.text = [point stringValue];
            self.nameValue.text = [selectedVirus getName];
            self.infectionValue.text = [[selectedVirus getInfectionRate] stringValue];
            self.durabilityValue.text = [[selectedVirus getDurability] stringValue];
            //stepperの値を変更
            self.infectionStepper.value = 0;
            self.infectionStepper.minimumValue = 0;
            self.infectionStepper.maximumValue = [point integerValue];
            self.infectionStepper.stepValue = 1;
            self.durabilityStepper.value = 0;
            self.durabilityStepper.minimumValue = 0;
            self.durabilityStepper.maximumValue = [point integerValue];
            self.durabilityStepper.stepValue = 1;
            break;
            
        default:
            break;
    }
}


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
    //強化に遷移
    [self switchView:VIEW_REINFORCE];
}


/**
 * Itemをタップした時の動作
 */
- (IBAction)onInfectionStepperClicked:(id)sender {
    //現在の値にStepperの値を足して表示
    int sum = (int)self.infectionStepper.value + [[selectedVirus getInfectionRate] intValue];
    self.infectionValue.text = [NSString stringWithFormat:@"%d", sum];
    //現在の残りポイントを更新
    int remain = [point intValue] - (int)self.infectionStepper.value - (int)self.durabilityStepper.value;
    self.nowPointValue.text = [NSString stringWithFormat:@"%d", remain];
    //stepperの最大値を変更
    self.infectionStepper.maximumValue = [point intValue] - (int)self.durabilityStepper.value;
    self.durabilityStepper.maximumValue = [point intValue] - (int)self.infectionStepper.value;
}

- (IBAction)onDurabilityStepperClicked:(id)sender {
    //現在の値にStepperの値を足して表示
    int sum = (int)self.durabilityStepper.value + [[selectedVirus getDurability] intValue];
    self.durabilityValue.text = [NSString stringWithFormat:@"%d", sum];
    //現在の残りポイントを更新
    int remain = [point intValue] - (int)self.infectionStepper.value - (int)self.durabilityStepper.value;
    self.nowPointValue.text = [NSString stringWithFormat:@"%d", remain];
    //stepperの最大値を変更
    self.infectionStepper.maximumValue = [point intValue] - (int)self.durabilityStepper.value;
    self.durabilityStepper.maximumValue = [point intValue] - (int)self.infectionStepper.value;
}


- (IBAction)onButtonClicked:(id)sender {
    //新しい値を持ったvirusを生成
    Virus *temp = [[Virus alloc] initWithValue:[selectedVirus getVirusId] :[selectedVirus getName] :[selectedVirus getInfectionRate] :[selectedVirus getDurability]];
    [temp setInfectionRate:[NSNumber numberWithInt:[self.infectionValue.text intValue]]];
    [temp setDurability:[NSNumber numberWithInt:[self.durabilityValue.text intValue]]];
    
    //UserDefaultの値を書き換える
    NSUserDefaults *_userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* array = [_userDefaults arrayForKey:VIRUS_LIST_KEY];
    NSUInteger index = 0;
    for ( NSDictionary* object in array ) {
        Virus *virus = [[Virus alloc] initWithDictionary:object];
        //virus_idが一致したvirusを置き換える
        if([[virus getVirusId] isEqualToString:[temp getVirusId]]){
            NSLog(@"replace at index=%d, with %@, %@", index, [temp getInfectionRate], [temp getDurability]);
            
            NSMutableArray *mArr;
            mArr = [NSMutableArray arrayWithArray:array];
            [mArr replaceObjectAtIndex:index withObject:[temp toNSDictionary]];
            array = mArr;
            
            [_userDefaults setObject:array forKey:VIRUS_LIST_KEY];
            [_userDefaults synchronize];
            break;
        }
        index++;
    }

    //pointを0にリセット
    point = [NSNumber numberWithInt:0];
    //TestAppDelegateの値をリセット
    TestAppDelegate *testAppDelegate = [[UIApplication sharedApplication] delegate];
    testAppDelegate.pointData = point;
    testAppDelegate.viewData = VIEW_VIRUS_LIST;
    
    //virus list を更新して遷移
    [self.virusList reloadData];
    [self switchView:VIEW_VIRUS_LIST];
}


- (IBAction)onCancelButtonClicked:(id)sender {
    //TestAppDelegateの値をリセット
    TestAppDelegate *testAppDelegate = [[UIApplication sharedApplication] delegate];
    point = testAppDelegate.pointData;
    testAppDelegate.viewData = VIEW_VIRUS_LIST;
    //virus list を更新して遷移
    [self.virusList reloadData];
    [self switchView:VIEW_VIRUS_LIST];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_virusList release];
    [_nowPointLabel release];
    [_infectionLabel release];
    [_durabilityLabel release];
    [_infectionValue release];
    [_durabilityValue release];
    [_infectionStepper release];
    [_durabilityStepper release];
    [_cancelButton release];
    [_okButton release];
    [_nameValue release];
    [super dealloc];
}
@end

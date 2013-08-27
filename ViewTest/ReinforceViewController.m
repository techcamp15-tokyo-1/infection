//
//  ReinforceViewController.m
//  Infection
//
//  Created by techcamp on 13/08/26.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import "ReinforceViewController.h"

/*
@interface ReinforceViewController ()

@end
 */

@implementation ReinforceViewController

//virusをSpreadViewControllerから受け取るためにsynthesizeに
@synthesize selectedVirus;
@synthesize point;

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
    
    //viewの初期化
    view_mode = VIEW_VIRUS_LIST;
    [self switchView:view_mode];
    [self initViewItem];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.virusList reloadData];
    [super viewWillAppear:animated];
}


- (void)initViewItem
{
    self.nowPointValue.text = @"0";
    self.nameValue.text = @"";
    self.infectionValue.text = @"0";
    self.durabilityValue.text = @"0";
    
    //条件によってstepperの上限値を変更
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
            //selectedVirusの値に従ってItemに値をセット
            self.nameValue.text = [selectedVirus getName];
            self.infectionValue.text = [[selectedVirus getInfectionRate] stringValue];
            self.durabilityValue.text = [[selectedVirus getDurability] stringValue];
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
    //TODO
    //押したvirusに従って、そのvirusの強化viewに遷移
    //選択したvirusを保持
    selectedVirus = [itemArray objectAtIndex:[indexPath row]];
    //強化に遷移
    [self switchView:VIEW_REINFORCE];
}

- (IBAction)onInfectionStepperClicked:(id)sender {
    //現在の値にStepperの値を足して表示
    int sum = (int)self.infectionStepper.value + [[selectedVirus getInfectionRate] intValue];
    self.infectionValue.text = [NSString stringWithFormat:@"%d", sum];
}

- (IBAction)onDurabilityStepperClicked:(id)sender {
    //現在の値にStepperの値を足して表示
    int sum = (int)self.durabilityStepper.value + [[selectedVirus getDurability] intValue];
    self.durabilityValue.text = [NSString stringWithFormat:@"%d", sum];
}


- (IBAction)onButtonClicked:(id)sender {
    //TODO
    //UserDefaultの値を書き換える
    
    //virus list に遷移
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

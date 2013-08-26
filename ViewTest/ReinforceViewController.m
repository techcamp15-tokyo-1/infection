//
//  ReinforceViewController.m
//  Infection
//
//  Created by techcamp on 13/08/26.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import "ReinforceViewController.h"

@interface ReinforceViewController ()

@end

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
    
    view_mode = VIEW_REINFORCE;
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
    self.nowPointLabel.text = @"0";
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
    
//    NSUserDefaults *_userDefaults = [NSUserDefaults standardUserDefaults];
//    NSArray* array = [_userDefaults arrayForKey:VIRUS_LIST_KEY];
//    for ( NSDictionary* object in array ) {
//        Virus *virus = [[Virus alloc] initWithDictionary:object];
//        [itemArray addObject:virus];
//    }
}

//
//  tableView:cellForRowAtIndexPath
//    CellにNSArrayに登録されている文字列を設定
//    本メソッドは、UITableViewDataSourceプロトコルを採用しているのでコールされる。
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	cell = [[[UITableViewCell alloc] init] autorelease];
	//cell.textLabel.text = [[itemArray objectAtIndex: indexPath.row] getName];
	return cell;
}


//
//  tableView:didSelectRowAtIndexPath
//    選択されたCellの文字列をToolBarにあるLabelにセットし表示する。
//    本メソッドは、UITableViewDelegateプロトコルを採用しているのでコールされる。
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (IBAction)onInfectionStepperClicked:(id)sender {
    self.infectionValue.text = [NSString stringWithFormat:@"%d", (int)self.infectionStepper.value];
}

- (IBAction)onDurabilityStepperClicked:(id)sender {
    self.durabilityValue.text = [NSString stringWithFormat:@"%d", (int)self.durabilityStepper.value];
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
    [super dealloc];
}
@end

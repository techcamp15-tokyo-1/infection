//
//  ReinforceViewController.m
//  Infection
//
//  Created by techcamp on 13/08/26.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import "ReinforceViewController.h"
#import "TestAppDelegate.h"

@interface ReinforceViewController ()

@end

@implementation ReinforceViewController

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
    selectedVirus = [[Virus alloc] init];
    point = [NSNumber numberWithInt:0];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //データを受け取って、ラベルに表示する
    TestAppDelegate *testAppDelegate = [[UIApplication sharedApplication] delegate];
    selectedVirus = testAppDelegate.virusData;
    point = testAppDelegate.pointData;
    [self initViewItem];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    //ウイルス一覧に遷移
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)initViewItem
{
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
    //TODO
    //アニメーション終了まで待機
    //[self evolveImageAnimation];
    
    //新しい値を持ったvirusを生成
    Virus *temp = [[Virus alloc] initWithValue:[selectedVirus getVirusId] :[selectedVirus getName] :[selectedVirus getInfectionRate] :[selectedVirus getDurability]];
    int next_image_no = [[selectedVirus getImageNo] intValue] + [point intValue];
    [temp setImageNo:[[NSNumber alloc] initWithInt:next_image_no]];
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
    testAppDelegate.virusData = selectedVirus;
    testAppDelegate.pointData = point;
    testAppDelegate.viewData = VIEW_VIRUS_LIST;
    
    //ウイルス一覧に遷移
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)onCancelButtonClicked:(id)sender {
    //押すと強化の値がリセットされるように変更
    [self initViewItem];
}


- (void)evolveImageAnimation
{
    UIImage *image = [UIImage imageNamed:@"img115_71.png"];
    UIImageView *nextView = [[UIImageView alloc] initWithImage:image];
    
    //トランジションアニメーションを実行
    [UIView transitionFromView:self.virusImage
                        toView:nextView
                      duration:1.0f
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:^(BOOL finished) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
    
    [self.virusImage startAnimating]; // アニメーション開始!!
    [image release]; // きちんと後片付け
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
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
    [_virusImage release];
    [super dealloc];
}
@end

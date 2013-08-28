#import "ViewControllers.h"
#import "Virus.h"
#import "UserDefaultKey.h"
#import "UIApplication+UIID.h"

@interface MakeVirusViewController ()

@end


@implementation MakeVirusViewController
{
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //フィールド値を初期化
    point = MAX_SUM_PARAM;
    [self initViewItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}


- (BOOL) shouldAutorotate {
    return YES;
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)viewDidAppear:(BOOL)animated
{
    //フィールド値を初期化
    point = MAX_SUM_PARAM;
    [self initViewItem];
}

- (void)dealloc {
    [_makeButton release];
    [_remnantValue release];
    [_nameText release];
    [_infectionRateValue release];
    [_durabilityValue release];
    [_infectionRateStepper release];
    [_durabilityStepper release];
    [super dealloc];
}


- (void)initViewItem
{
    self.infectionRateValue.text = @"0";
    self.durabilityValue.text = @"0";
    self.remnantValue.text = @"100";
    
    //デフォルトの作成値は100
    self.infectionRateStepper.value = 0;
    self.infectionRateStepper.minimumValue = 0;
    self.infectionRateStepper.maximumValue = MAX_SUM_PARAM;
    self.infectionRateStepper.stepValue = 1;
    
    self.durabilityStepper.value = 0;
    self.durabilityStepper.minimumValue = 0;
    self.durabilityStepper.maximumValue = MAX_SUM_PARAM;
    self.durabilityStepper.stepValue = 1;
}


//作成ボタンを押した時の処理
- (IBAction)onMakeButtonCliked:(id)sender {
    NSString* uiid = [[UIApplication sharedApplication] uniqueInstallationIdentifier];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger virus_n = [userDefaults integerForKey:@"#Viruses"];
    NSString* virus_id = [uiid stringByAppendingFormat:@"_%d", virus_n];
    [userDefaults setInteger:virus_n+1 forKey:@"#Viruses"];

    //infection rateの数値を取得
    NSNumber *inputInfectionRate = [NSNumber numberWithInt:[self.infectionRateValue.text intValue]];
    //durabilityの数値を取得
    NSNumber *inputDurability = [NSNumber numberWithInt:[self.durabilityValue.text intValue]];
    //nameを取得
    NSString *inputName = self.nameText.text;
    //ウイルスを生成
    Virus *virus = [[Virus alloc] initWithValue:virus_id :inputName :inputInfectionRate :inputDurability];
    //user defaultに保存
    [self addToUserDefault:virus];
    //viewを遷移
    [self changeViewToSpreadView];
}


//ユーザーデフォルトに追加
- (void)addToUserDefault:(Virus*)virus
{
    NSLog(@"infection rate :%@, durability:%@", [virus getInfectionRate], [virus getDurability]);
    
    NSUserDefaults *_userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *arr;
    
    arr = [_userDefaults arrayForKey:VIRUS_LIST_KEY]; //読み込み
    if(arr != nil){
        NSMutableArray *mArr;
        mArr = [NSMutableArray arrayWithArray:arr];
        [mArr addObject:[virus toNSDictionary]];
        arr = mArr;
        
        [_userDefaults setObject:arr forKey:VIRUS_LIST_KEY];
        [_userDefaults synchronize];
    } else {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array addObject:[virus toNSDictionary]];
        
        [_userDefaults setObject:array forKey:VIRUS_LIST_KEY]; //ここで指定したキーで保存・読み込みを行う
        [_userDefaults synchronize]; //保存を実行
    }
}

//拡散開始viewへの遷移
- (void)changeViewToSpreadView
{
    UITabBarController *controller = self.tabBarController;
    controller.selectedViewController = [controller.viewControllers objectAtIndex: 1];
}


- (IBAction)onInfectionRateStepperClicked:(id)sender {
    int sum = (int)self.infectionRateStepper.value;
    self.infectionRateValue.text = [NSString stringWithFormat:@"%d", sum];
    //現在の残りポイントを更新
    int remain = point - (int)self.infectionRateStepper.value - (int)self.durabilityStepper.value;
    self.remnantValue.text = [NSString stringWithFormat:@"%d", remain];
    //stepperの最大値を変更
    self.infectionRateStepper.maximumValue = point - (int)self.durabilityStepper.value;
    self.durabilityStepper.maximumValue = point - (int)self.infectionRateStepper.value;
}


- (IBAction)onDurabilityStepperCliked:(id)sender {
    int sum = (int)self.durabilityStepper.value;
    self.durabilityValue.text = [NSString stringWithFormat:@"%d", sum];
    //現在の残りポイントを更新
    int remain = point - (int)self.infectionRateStepper.value - (int)self.durabilityStepper.value;
    self.remnantValue.text = [NSString stringWithFormat:@"%d", remain];
    //stepperの最大値を変更
    self.infectionRateStepper.maximumValue = point - (int)self.durabilityStepper.value;
    self.durabilityStepper.maximumValue = point - (int)self.infectionRateStepper.value;
}

//背景がタップされた時にキーボードを閉じる
- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}


//returnが押されるとキーボードを隠す
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}


@end

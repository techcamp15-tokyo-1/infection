#import "ViewControllers.h"
#import "Virus.h"
#import "UserDefaultKey.h"

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


//作成ボタンを押した時の処理
- (IBAction)onMakeButtonCliked:(id)sender {
    [self changeViewToSpreadView];
    
    //TODO
    //通信の結果によって条件分岐
    
    //TODO
    //一意になるようにリストから重複しない最小のidを取得
    //infection rateの数値を取得
    NSNumber *inputInfectionRate = [NSNumber numberWithInt:[self.infectionRateText.text intValue]];
    //durabilityの数値を取得
    NSNumber *inputDurability = [NSNumber numberWithInt:[self.durabilityText.text intValue]];
    //ウイルスを生成
    Virus *virus = [[Virus alloc] initWithValue:@0 :@"default" :inputInfectionRate :inputDurability];
    //user defaultに保存
    [self addToUserDefault:virus];
}


//ユーザーデフォルトに追加
- (void)addToUserDefault:(Virus*)virus
{
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
        NSLog(@"add to user default array");
    } else {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array addObject:[virus toNSDictionary]];
        
        [_userDefaults setObject:array forKey:VIRUS_LIST_KEY]; //ここで指定したキーで保存・読み込みを行う
        [_userDefaults synchronize]; //保存を実行
        NSLog(@"make new user default array");
    }
}


//TODO
//ユーザーでフォルトの削除

//ユーザーでフォルトから読み込んで値を出力
- (void)showUserDefaultList
{
    NSUserDefaults *_userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* array = [_userDefaults arrayForKey:VIRUS_LIST_KEY];
    for ( NSDictionary* object in array ) {
        NSNumber *id = [NSNumber numberWithInt:[[object objectForKey:@"virus_id"] intValue]];
        NSString *name = [object objectForKey:@"name"];
        NSNumber *infection = [NSNumber numberWithInt:[[object objectForKey:@"infection_rate"] intValue]];
        NSNumber *durability = [NSNumber numberWithInt:[[object objectForKey:@"durability"] intValue]];
        NSLog(@"%@, %@, %@, %@", id, name, infection, durability);
    }
}



//拡散開始viewへの遷移
- (void)changeViewToSpreadView
{
    UITabBarController *controller = self.tabBarController;
    controller.selectedViewController = [controller.viewControllers objectAtIndex: 2];
}


//text field への数値のみの入力制限
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    
    if ([string rangeOfCharacterFromSet:set].location != NSNotFound) {
        NSLog(@"入力は数値のみです。 %@", string);
        return NO;
    }
    
    NSInteger remnantValue = [self getIntSumOfTextFiled];
    _remnantText.text =[[NSString alloc] initWithFormat:@"%d",MAX_SUM_PARAM - remnantValue];
    
    return YES;
}

//入力制限のため、パラメータの合計値を取得して返す
-(NSInteger)getIntSumOfTextFiled
{
    //infection rateの数値を取得
    NSString *inputInfectionRate = _infectionRateText.text;
    NSInteger inputNumInfectionRate = [inputInfectionRate intValue];
    
    //durabilityの数値を取得
    NSString *inputDurability = _durabilityText.text;
    NSInteger inputNumDurability = [inputDurability intValue];
    
    return inputNumInfectionRate + inputNumDurability;
}

//背景がタップされた時にキーボードを閉じる
- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

- (void)dealloc {
    [_makeButton release];
    [_infectionRateText release];
    [_durabilityText release];
    [_remnantText release];
    [super dealloc];
}

@end
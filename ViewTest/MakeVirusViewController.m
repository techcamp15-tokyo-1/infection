#import "ViewControllers.h"

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
    //各パラメータの値を取得
    //infection rateの数値を取得
    NSString *inputInfectionRate = _infectionRateText.text;
    NSInteger inputNumInfectionRate = [inputInfectionRate intValue];
    
    //durabilityの数値を取得
    NSString *inputDurability = _durabilityText.text;
    NSInteger inputNumDurability = [inputDurability intValue];

    //TODO
    //通信を開始
    [self changeViewToSpread];
}


//拡散開始viewへの遷移
- (void)changeViewToSpread
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

//returnが押されるとキーボードを隠す
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.infectionRateText.delegate = self;
    self.durabilityText.delegate = self;
}

- (void)viewDidUnload
{
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

- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}

@end
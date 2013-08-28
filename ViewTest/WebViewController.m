//
//  WebViewController.m
//  Infection
//
//  Created by techcamp on 13/08/28.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import "WebViewController.h"
#import "HTTPRequester.h"
#import "TestAppDelegate.h"
#import "Virus.h"

@interface WebViewController ()

@end

@implementation WebViewController

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
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //TODO
    //とりあえずAppDelegateから取得しているが、リストから取得できるように変更
    TestAppDelegate *testAppDelegate = [[UIApplication sharedApplication] delegate];
    Virus *virus = testAppDelegate.virusData;
    //user default から取得
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *nameStr = [userDefaults stringForKey:NAME_KEY];
    
    NSLog(@"%@, %@", [virus getVirusId], nameStr);
    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjects:
                                    @[[virus getVirusId], nameStr]
                                                               forKeys:@[@"virus_id", @"name"]];
    
    
    NSData* response = [HTTPRequester sendPostWithDictionary:@"http://nokok.dip.jp/infectionapp/visualize.php" :jsonDictionary];
    if (response == nil) {
        NSLog(@"%@", @"connection failed");
        return;
    }
    NSLog(@"%@", [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
    NSLog(@"%@", response);
    
    NSURL *url = [NSURL URLWithString:@"http://nokok.dip.jp/infectionapp/visualize.php"];
    [self.WebView loadData:response MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:url];
    
    //    NSURL *url = [NSURL URLWithString:@"http://d.hatena.ne.jp/murapong"];
    //    [[UIApplication sharedApplication] openURL:url];
}


- (IBAction)onBlueToothSwitchClicked:(id)sender {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_WebView release];
    [_blueToothSwitch release];
    [super dealloc];
}
@end

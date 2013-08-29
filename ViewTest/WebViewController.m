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
    [self.WebView loadData:[@"ロード中" dataUsingEncoding: NSUTF8StringEncoding] MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:nil];
    TestAppDelegate *testAppDelegate = [[UIApplication sharedApplication] delegate];
    Virus *virus = testAppDelegate.virusData;
    //user default から取得
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *nameStr = [userDefaults stringForKey:NAME_KEY];
    
    NSURL* url = [NSURL URLWithString:@"http://nokok.dip.jp/infectionapp/visualize.php"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    NSMutableDictionary* dictionary = [[virus toNSDictionary] mutableCopy];
    [dictionary setValue:nameStr forKey:@"user_name"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[[HTTPRequester postString:dictionary] dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSLog(@"Response from visualize.php");
         if ([data length] >0 && error == nil)
         {
             [self.WebView loadData:data MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:url];
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Nothing was downloaded.");
         }
         else if (error != nil){
             NSLog(@"Error = %@", error);
             [self viewDidAppear:NO];
         }
     }];
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

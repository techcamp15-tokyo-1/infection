//
//  WebViewController.m
//  Infection
//
//  Created by techcamp on 13/08/28.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import "WebViewController.h"

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
    
    NSURL *url = [NSURL URLWithString:@"http://www.robinship.org"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.WebView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_WebView release];
    [super dealloc];
}
@end

//
//  VirusDetailViewController.h
//  Infection
//
//  Created by techcamp on 13/08/22.
//  Copyright (c) 2013年 technologycamp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyGKSessionDelegate.h"
#import "HTTPRequester.h"
#import "JSONConverter.h"
#import "Virus.h"
#import "TestAppDelegate.h"

//@protocol VirusDetailViewControllerDelegate <NSObject> // [1] プロトコルの宣言
//-(void)didPressCloseButton;
//@end

#define VIEW_DETAIL 0
#define VIEW_IN_SPREAD 1
#define VIEW_POINT 2

@interface VirusDetailViewController : UIViewController
{
    @private
    //view mode
    NSInteger view_mode;
    //選択したウイルス
    Virus *selectedVirus;
    //総感染人数
    NSNumber *totalInfectedNumber;
    //タイマーの切り替えが必要なため、管理しておく必要がある
    NSTimer *timer;
    //拡散中の場合、IDを保存
    BOOL inSpread;
    NSString *inSpreadVirusId;
}

- (void)switchView:(NSInteger)mode;

@property (retain, nonatomic) IBOutlet UILabel *nameValue;
@property (retain, nonatomic) IBOutlet UILabel *infectionValue;
@property (retain, nonatomic) IBOutlet UILabel *durabilityValue;
@property (retain, nonatomic) IBOutlet UIButton *executeButton;

@property (retain, nonatomic) IBOutlet UILabel *inSpreadLabel;

@property (retain, nonatomic) IBOutlet UILabel *infectedNowLabel;
@property (retain, nonatomic) IBOutlet UILabel *infectedNowValue;

@property (retain, nonatomic) IBOutlet UILabel *infectedTotalLabel;
@property (retain, nonatomic) IBOutlet UILabel *infectedTotalValue;

@property (retain, nonatomic) IBOutlet UILabel *getPointLabel;
@property (retain, nonatomic) IBOutlet UILabel *getPointValue;


@property (retain, nonatomic) IBOutlet UIButton *toReinforceViewButton;

@end

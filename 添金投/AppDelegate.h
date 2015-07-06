//
//  AppDelegate.h
//  添金投
//
//  Created by mac on 15/6/29.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorUtil.h"
#import "MBProgressHUD.h"
#import "NetworkModule.h"
#import "Toast+UIView.h"
#import "SBJson.h"
#import "SRRefreshView.h"
#import "SHLUILabel.h"
#import "ASIHTTPRequest.h"
#import "OpenUDID.h"
#import "HMSegmentedControl.h"
#import "LogOutViewController.h"
#import "LoginViewController.h"


#define NUMBERS @"0123456789\n"
//#define SERVERURL @"http://192.168.1.110:8803"

//天津投
#define SERVERURL @"http://192.168.1.110:8805"

@class DDMenuController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    UIBackgroundTaskIdentifier bgTask;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DDMenuController *menuController;
@property (strong, nonatomic) UIView *baseView;



@property (strong, nonatomic) NSMutableDictionary *dictionary;
@property (strong, nonatomic) NSMutableDictionary *dic;
@property (strong, nonatomic)NSString *strVC;
//从哪登录的
@property (strong, nonatomic)NSString *strlogin;

@property (strong, nonatomic) NSMutableDictionary *logingUser;



@end


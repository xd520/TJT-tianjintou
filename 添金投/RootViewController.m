//
//  RootViewController.m
//  添金投
//
//  Created by mac on 15/6/29.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "RootViewController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "DDMenuController.h"
#import "AccountInfoViewController.h"
#import "MoneyAccountViewController.h"
#import "MyGainViewController.h"
#import "MyBuyViewController.h"
#import "BussizeDetailViewController.h"
#import "MoneyInfoViewController.h"
#import "TradingAccountViewController.h"
#import "RechargeFirstViewController.h"
#import "WithdrawFirstViewController.h"
#import "BindCardViewController.h"
#import "DelegateTodayViewController.h"
#import "PassWordMangerViewController.h"
#import "HideViewController.h"
#import "MyMoneyViewController.h"
#import "FriendsViewController.h"
#import "AddWithdrawViewController.h"
#import "WithdrawViewController.h"
#import "RechargeViewController.h"
#import "AddRechargeViewController.h"
#import "LoginPassWordViewController.h"
#import "MoreViewController.h"


@interface RootViewController ()
{
    UITableView *table;
    float addHight;
    UIButton *logBtn;
    UIButton *logoinBtn;
    UIView *baseView;
    UILabel *titleLab;
    
    UILabel *total;
    UILabel * incomeLab;
    UILabel *accumulatedLab;
    int count;
    int hasMore;
     NSString *flagHub;
    UIImageView *logoImg;
    UILabel *setTextlogo;
    
}
@end

@implementation RootViewController


-(void)viewWillAppear:(BOOL)animated {
        [super viewWillAppear:animated];
        if ([flagHub isEqualToString:@"0"]) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            // hud.dimBackground = YES; //加层阴影
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.labelText = @"加载中...";
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                
                [self requestLogin:kBusinessTagGetJRhotproject];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            });
        }
        
        AppDelegate *delate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        if (delate.logingUser.count > 0) {
            if ([[delate.logingUser objectForKey:@"success"] boolValue] == YES) {
                baseView.hidden = NO;
                logoinBtn.hidden = YES;
                logBtn.enabled = YES;
                setTextlogo.textColor = [ColorUtil colorWithHexString:@"666666"];
                logoImg.image = [UIImage imageNamed:@"esc"];
                titleLab.text = [[delate.logingUser objectForKey:@"object"]objectForKey:@"username"];
                
                
               // if (hasMore != 1&& hasMore == 0) {
                
                    
              //  }
                
              
                
                
            } else {
                baseView.hidden = YES;
                logoinBtn.hidden = NO;
                titleLab.text = @"";
                logBtn.enabled = NO;
                setTextlogo.textColor = [ColorUtil colorWithHexString:@"ececec"];
                 logoImg.image = [UIImage imageNamed:@"esc02(1)"];
            }
            
        } else {
            baseView.hidden = YES;
            logoinBtn.hidden = NO;
            titleLab.text = @"";
            logBtn.enabled = NO;
            setTextlogo.textColor = [ColorUtil colorWithHexString:@"ececec"];
             logoImg.image = [UIImage imageNamed:@"esc02(1)"];
        }
    
    
        //if (count == 1) {
           // [self getUIFirst];
            
       // }
        
    }
    
    
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self getUIFirst];
}




-(void)getUIFirst {
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.logingUser.count > 0) {
        if ([[delegate.logingUser objectForKey:@"success"] boolValue] == YES) {
           
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.dimBackground = YES; //加层阴影
                hud.mode = MBProgressHUDModeIndeterminate;
                hud.labelText = @"加载中...";
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    
                    [self requestLogin:kBusinessTagGetJRMyzc];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                    });
                });
                
                
            }
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
   
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor = [ColorUtil colorWithHexString:@"e3a325"];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }

    
    UIImageView *firstView = [[UIImageView alloc] initWithFrame:CGRectMake(0, addHight, ScreenWidth - 60, 220)];
    firstView.image = [UIImage imageNamed:@"view_drawer_bg"];
    firstView.userInteractionEnabled = YES;
    
    logoinBtn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth - 210)/2, 60, 150, 50)];
    logoinBtn.layer.borderColor = [ColorUtil colorWithHexString:@"ffffff" withApla:0.45].CGColor;
    logoinBtn.layer.cornerRadius = 10;
    logoinBtn.layer.masksToBounds = YES;
    logoinBtn.layer.borderWidth = 1;
    logoinBtn.backgroundColor = [ColorUtil colorWithHexString:@"091918" withApla:0.45];
    [logoinBtn setTitle:@"登录  |  注册" forState:UIControlStateNormal];
    [logoinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [logoinBtn addTarget:self action:@selector(pushLogoin) forControlEvents:UIControlEventTouchUpInside];
    [firstView addSubview:logoinBtn];
    
 //我的账户数据模块
    baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 60, 220)];
    baseView.backgroundColor = [UIColor clearColor];
    
    titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 60, 40)];
    titleLab.font = [UIFont systemFontOfSize:18];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor whiteColor];
    titleLab.text = @"234";
    [baseView addSubview:titleLab];
    
    
    
    UILabel *totalTip = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, (ScreenWidth - 60)/2, 15)];
    totalTip.backgroundColor = [UIColor clearColor];
    totalTip.font = [UIFont systemFontOfSize:15];
    //totalTip.textAlignment = NSTextAlignmentCenter;
    totalTip.backgroundColor = [UIColor clearColor];
    totalTip.textColor = [UIColor whiteColor];
    totalTip.text = @"我的总资产(元)";
    [baseView addSubview:totalTip];
    
    //总资产
    total = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, ScreenWidth - 80, 30)];
    total.textAlignment = NSTextAlignmentCenter;
    total.font = [UIFont boldSystemFontOfSize:30];
    total.backgroundColor = [UIColor clearColor];
    total.textColor = [UIColor whiteColor];
    total.text = @"0.0";
    [baseView addSubview:total];
    
    
    //今日收益
    accumulatedLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 165, (ScreenWidth - 80)/2, 14)];
    // accumulatedLab.textAlignment = NSTextAlignmentCenter;
    accumulatedLab.font = [UIFont systemFontOfSize:14];
    accumulatedLab.textColor = [UIColor whiteColor];
    accumulatedLab.backgroundColor = [UIColor clearColor];
    accumulatedLab.text = @"0.0";
    [baseView addSubview:accumulatedLab];
    
   
    
    
    
    UILabel *incomeTip = [[UILabel alloc] initWithFrame:CGRectMake(20, 145, (ScreenWidth - 100)/2, 14)];
    incomeTip.font = [UIFont systemFontOfSize:14];
    //incomeTip.textAlignment = NSTextAlignmentCenter;
    incomeTip.textColor = [UIColor whiteColor];
    incomeTip.backgroundColor = [UIColor clearColor];
    incomeTip.text = @"累计已收益(元)";
    [baseView addSubview:incomeTip];
    
    //累计收益
    incomeLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 30 + 20, 165, (ScreenWidth - 20)/2, 14)];
    //incomeLab.textAlignment = NSTextAlignmentCenter;
    incomeLab.font = [UIFont systemFontOfSize:14];
    incomeLab.textColor = [UIColor whiteColor];
    incomeLab.backgroundColor = [UIColor clearColor];
    incomeLab.text = @"0.0";
    [baseView addSubview:incomeLab];
    
    UILabel *foodTip = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 + 20 - 30, 145, (ScreenWidth - 100)/2, 14)];
    foodTip.font = [UIFont systemFontOfSize:14];
    // foodTip.textAlignment = NSTextAlignmentCenter;
    foodTip.textColor = [UIColor whiteColor];
    foodTip.backgroundColor = [UIColor clearColor];
    foodTip.text = @"预期待收益(元)";
    [baseView addSubview:foodTip];
    
    
    
    //提现
    UIButton *tixianBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    tixianBtn.frame = CGRectMake(ScreenWidth/2 - 30, 220 - 35, ScreenWidth/2 - 30, 35);
    tixianBtn.backgroundColor = [ColorUtil colorWithHexString:@"091918" withApla:0.45];
    [tixianBtn setTitle:@"提现" forState:UIControlStateNormal];
   
    [tixianBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tixianBtn.tag = 1001;
    [tixianBtn addTarget:self action:@selector(getMoneyMethods:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:tixianBtn];
    
    
    
    //充值
    UIButton *chongzhiBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    chongzhiBtn.frame = CGRectMake(0, 220 - 35, ScreenWidth/2, 35);
    chongzhiBtn.backgroundColor = [ColorUtil colorWithHexString:@"091918" withApla:0.45];
    [chongzhiBtn setTitle:@"充值" forState:UIControlStateNormal];
    
    [chongzhiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    chongzhiBtn.tag = 1002;
    [chongzhiBtn addTarget:self action:@selector(getMoneyMethods:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:chongzhiBtn];
    
    
    [firstView addSubview:baseView];
    
    
    [self.view addSubview:firstView];
    
    
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, addHight + 220, ScreenWidth - 60,ScreenHeight - 20 - 220 - 40)];
    [table setDelegate:self];
    [table setDataSource:self];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
   // [table setBackgroundColor:[ColorUtil colorWithHexString:@"eeeeee"]];
    table.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:table];
 
    UIButton *setBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, ScreenHeight - 60 + addHight, (ScreenWidth - 60)/2, 40)];
    setBtn.backgroundColor = [UIColor whiteColor];
    UIImageView *setImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 30, 30)];
    setImg.image = [UIImage imageNamed:@"set"];
    [setBtn addSubview:setImg];
    UIView *lineVeiw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (ScreenWidth - 60)/2, 1)];
    lineVeiw.backgroundColor = [ColorUtil colorWithHexString:@"dedede"];
    [setBtn addSubview:lineVeiw];
    
    UILabel *setText = [[UILabel alloc] initWithFrame:CGRectMake(55, (40 - 15)/2, 30, 15)];
    setText.textColor = [ColorUtil colorWithHexString:@"666666"];
    setText.text = @"设置";
    setText.font = [UIFont systemFontOfSize:15];
    [setBtn addSubview:setText];
    
    NSLog(@"leading = %f,leading = %f xHeight = %f,capHeight = %f",setText.font.leading,setText.font.lineHeight,setText.font.xHeight,setText.font.capHeight);
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    [setBtn addTarget:self action:@selector(pushSet:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth - 60)/2 - 1, 5, 1, 30)];
    line.backgroundColor = [ColorUtil colorWithHexString:@"dedede"];
    [setBtn addSubview:line];
    
    
    [self.view addSubview:setBtn];
    
    
    logBtn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth - 60)/2, ScreenHeight - 60 + addHight, (ScreenWidth - 60)/2, 40)];
    logBtn.backgroundColor = [UIColor whiteColor];
    logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 30, 30)];
    logoImg.image = [UIImage imageNamed:@"esc"];
    [logBtn addSubview:logoImg];
    UIView *lineVeiwlog = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (ScreenWidth - 60)/2, 1)];
    lineVeiwlog.backgroundColor = [ColorUtil colorWithHexString:@"dedede"];
    [logBtn addSubview:lineVeiwlog];
    
    setTextlogo = [[UILabel alloc] initWithFrame:CGRectMake(55, (40 - 15)/2, 30, 15)];
    setTextlogo.textColor = [ColorUtil colorWithHexString:@"666666"];
    setTextlogo.text = @"退出";
    setTextlogo.font = [UIFont systemFontOfSize:15];
    [logBtn addSubview:setTextlogo];
    
    [logBtn addTarget:self action:@selector(pushSet:) forControlEvents:UIControlEventTouchUpInside];
    logBtn.enabled = NO;
    [self.view addSubview:logBtn];
    
    
}

-(void)pushSet:(UIButton *)btn {
    
    
    
    
    MoreViewController *cv = [[MoreViewController alloc] init];
     UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cv];
    nav.modalTransitionStyle = UIModalTransitionStyle;
    
    [self presentViewController:nav animated:YES completion:nil];

}


-(void)getMoneyMethods:(UIButton *)sender {
    
    AppDelegate *deletate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([[deletate.dictionary objectForKey:@"isSetCert"] boolValue]) {
        
        if ([[deletate.dictionary objectForKey:@"isBingingCard"] boolValue]) {
            if (sender.tag == 1001) {
                
                
                NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
                [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRapplyOutMoney owner:self];
                
            } else if (sender.tag == 1002){
                
                
                NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
                [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRapplyOutMoneyAgain owner:self];
            }
            
        } else {
            // NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
            //[[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRupdateUserInfo owner:self];
            [self.view makeToast:@"请先绑定银行卡" duration:2 position:@"center"];
        }
    } else {
        [self.view makeToast:@"请先实名认证" duration:2 position:@"center"];
        
    }
    
    
}




-(void)pushLogoin{
     LoginViewController *controller = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    controller.loginStr = @"1";
    nav.delegate = self;
     nav.modalTransitionStyle = UIModalTransitionStyle;
    
    [self presentViewController:nav animated:YES completion:nil];
    
  
    
    

}


#pragma mark - UINavigationController Delegate Methods
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    navigationController.navigationBarHidden = YES;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 60, 40)];
    
   
    NSArray *arrTitle = @[@"我的资产",@"当日申请",@"投资记录",@"我的收益",@"转账充值",@"资金变动",@"我的添金币",@"账户安全"];
    
    NSArray *arrImg = @[@"wdzc",@"drsq",@"tzjl",@"wdsy",@"zzcz",@"zjbd",@"wdsc",@"wdtjb",@"zhaq"];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(45, 17.5, 100, 15)];
    lab.text = [arrTitle objectAtIndex:indexPath.row];
    lab.textColor = [ColorUtil colorWithHexString:@"333333"];
    lab.font = [UIFont systemFontOfSize:15];
    [cell addSubview:lab];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
    img.image = [UIImage imageNamed:[arrImg objectAtIndex:indexPath.row]];
    [cell addSubview:img];
    }
    return cell;
}

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    UIViewController *vc ;
    
    switch (indexPath.row)
    {
        case 0:
            vc = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
            break;
            
        case 1:
            
            break;
            
            return;
            break;
    }
    
   
}
*/

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    return 40;
}




#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.logingUser.count > 0) {
        if ([[delegate.logingUser objectForKey:@"success"] boolValue] == YES) {
            if (indexPath.row == 0) {
                
                if ([[delegate.dictionary objectForKey:@"isSetCert"] boolValue]) {
                    
                   
                    MoneyAccountViewController *controller = [[MoneyAccountViewController alloc] init];
                    
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
                    nav.delegate = self;
                    
                    
                    
                    
                    nav.modalTransitionStyle = UIModalTransitionStyle;
                    
                    [self presentViewController:nav animated:YES completion:nil];
                   // [tableView deselectRowAtIndexPath:indexPath animated:YES];
                 
                }else {
                    
                    LoginPassWordViewController *controller = [[LoginPassWordViewController alloc] init];
                    
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
                    nav.delegate = self;
                    
                    nav.modalTransitionStyle = UIModalTransitionStyle;
                    
                    [self presentViewController:nav animated:YES completion:nil];
                }

                
            } else if(indexPath.row == 1){
                
                if ([[delegate.dictionary objectForKey:@"isSetCert"] boolValue]) {
                    
                    
                    DelegateTodayViewController *controller = [[DelegateTodayViewController alloc] init];
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
                    nav.delegate = self;
                    nav.modalTransitionStyle = UIModalTransitionStyle;
                    
                    [self presentViewController:nav animated:YES completion:nil];
                    
                }else {
                    
                    LoginPassWordViewController *controller = [[LoginPassWordViewController alloc] init];
                    
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
                    nav.delegate = self;
                    nav.modalTransitionStyle = UIModalTransitionStyle;
                    
                    [self presentViewController:nav animated:YES completion:nil];
                }
                
            } else if(indexPath.row == 2){
                
               
                    
                
                    MyGainViewController *controller = [[MyGainViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
                nav.delegate = self;
                nav.modalTransitionStyle = UIModalTransitionStyle;
                
                [self presentViewController:nav animated:YES completion:nil];
                
               
                
            } else if(indexPath.row == 3){
                
                if ([[delegate.dictionary objectForKey:@"isSetCert"] boolValue]) {
                    
                  
                    MyBuyViewController *controller = [[MyBuyViewController alloc] init];
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
                    nav.delegate = self;
                    nav.modalTransitionStyle = UIModalTransitionStyle;
                    
                    [self presentViewController:nav animated:YES completion:nil];
                    
                }else {
                   
                    LoginPassWordViewController *controller = [[LoginPassWordViewController alloc] init];
                    
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
                    nav.delegate = self;
                    nav.modalTransitionStyle = UIModalTransitionStyle;
                    
                    [self presentViewController:nav animated:YES completion:nil];
                }
                
            }else if(indexPath.row == 4){
                
                if ([[delegate.dictionary objectForKey:@"isSetCert"] boolValue]) {
                    
                   
                    BussizeDetailViewController *controller = [[BussizeDetailViewController alloc] init];
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
                    nav.delegate = self;
                    nav.modalTransitionStyle = UIModalTransitionStyle;
                    
                    [self presentViewController:nav animated:YES completion:nil];
                    
                }else {
                   
                    LoginPassWordViewController *controller = [[LoginPassWordViewController alloc] init];
                    
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
                    nav.delegate = self;
                    nav.modalTransitionStyle = UIModalTransitionStyle;
                    
                    [self presentViewController:nav animated:YES completion:nil];
                }
                
            }else if(indexPath.row == 9){
                
               
                HideViewController *controller = [[HideViewController alloc] init];
                
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
                nav.delegate = self;
                nav.modalTransitionStyle = UIModalTransitionStyle;
                
                [self presentViewController:nav animated:YES completion:nil];
                
            }else if(indexPath.row == 5){
                
                if ([[delegate.dictionary objectForKey:@"isSetCert"] boolValue]) {
                    
                   
                    MoneyAccountViewController *controller = [[MoneyAccountViewController alloc] init];
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
                    nav.delegate = self;
                    nav.modalTransitionStyle = UIModalTransitionStyle;
                    
                    [self presentViewController:nav animated:YES completion:nil];
                    
                }else {
                   
                    LoginPassWordViewController *controller = [[LoginPassWordViewController alloc] init];
                    
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
                    nav.delegate = self;
                    nav.modalTransitionStyle = UIModalTransitionStyle;
                    
                    [self presentViewController:nav animated:YES completion:nil];
                   // [tableView deselectRowAtIndexPath:indexPath animated:YES];
                    
                  
                }
                
            }else if(indexPath.row == 6){
                
               
                MyMoneyViewController *controller = [[MyMoneyViewController alloc] init];
                
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
                nav.delegate = self;
                nav.modalTransitionStyle = UIModalTransitionStyle;
                
                [self presentViewController:nav animated:YES completion:nil];
                
            }else if(indexPath.row == 7){
                
               
                PassWordMangerViewController *controller = [[PassWordMangerViewController alloc] init];
                
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
                nav.delegate = self;
                nav.modalTransitionStyle = UIModalTransitionStyle;
                
                [self presentViewController:nav animated:YES completion:nil];
                
                
                
            }

        } else {
            
           
            LoginViewController *controller = [[LoginViewController alloc] init];
            controller.loginStr = @"1";
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
            nav.delegate = self;
            nav.modalTransitionStyle = UIModalTransitionStyle;
            
            [self presentViewController:nav animated:YES completion:nil];
        }
        
    } else {
       
        LoginViewController *controller = [[LoginViewController alloc] init];
        controller.loginStr = @"1";
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        nav.delegate = self;
        nav.modalTransitionStyle = UIModalTransitionStyle;
        
        [self presentViewController:nav animated:YES completion:nil];
        
        
    }
    
 
    
    
    
}

-(void)reloadDataWith:(NSMutableDictionary *)arraydata {
    
    //总资产
    
    if ([[arraydata objectForKey:@"zzc"] isEqualToString:@""]||[[arraydata objectForKey:@"zzc"] isEqualToString:@"0"]) {
        total.text = @"0.00";
    } else {
        NSString *strZzc = [NSString stringWithFormat:@"%.2f",[[arraydata objectForKey:@"zzc"] floatValue]];
        
        NSRange range1 = [strZzc rangeOfString:@"."];//匹配得到的下标
        
        NSLog(@"rang:%@",NSStringFromRange(range1));
        
        //string = [string substringWithRange:range];//截取范围类的字符串
        
        
        
        NSString *string = [strZzc substringFromIndex:range1.location];
        
        NSString *str = [strZzc substringToIndex:range1.location];
        
        total.text = [NSString stringWithFormat:@"%@%@",[self AddComma:str],string];
        
        
    }
    
    //incomeLab.text = [NSString stringWithFormat:@"%.2f",[[arraydata objectForKey:@"jrZsz"] floatValue]];
    
    if ([[arraydata objectForKey:@"jrljdsy"] isEqualToString:@"0.0"]) {
        incomeLab.text = @"0.00";
    } else {
        
        NSString *strjrZsz = [NSString stringWithFormat:@"%.2f",[[arraydata objectForKey:@"jrljdsy"] floatValue]];
        NSRange range3 = [strjrZsz rangeOfString:@"."];//匹配得到的下标
        
        NSLog(@"rang:%@",NSStringFromRange(range3));
        
        //string = [string substringWithRange:range];//截取范围类的字符串
        
        
        
        NSString *string = [strjrZsz substringFromIndex:range3.location];
        
        NSString *str = [strjrZsz substringToIndex:range3.location];
        
        incomeLab.text = [NSString stringWithFormat:@"%@%@",[self AddComma:str],string];
        
    }
    
    
    //累计收益
    
    //accumulatedLab.text = [NSString stringWithFormat:@"%.2f",[[arraydata objectForKey:@"jrljzsy"] floatValue]];
    // accumulatedLab.text =[NSString stringWithFormat:@"%.2f",[[arraydata objectForKey:@"jrljzsy"] floatValue]];
    
    if ([[arraydata objectForKey:@"jrljzsy"] isEqualToString:@"0"]) {
        accumulatedLab.text = @"0.00";
    } else {
        
        NSString *strrljzsy = [NSString stringWithFormat:@"%.2f",[[arraydata objectForKey:@"jrljzsy"] floatValue]];
        
        NSRange range = [strrljzsy rangeOfString:@"."];//匹配得到的下标
        
        NSLog(@"rang:%@",NSStringFromRange(range));
        
        //string = [string substringWithRange:range];//截取范围类的字符串
        
        
        
        NSString *string1 = [strrljzsy substringFromIndex:range.location];
        
        NSString *str1 = [strrljzsy substringToIndex:range.location];
        
        accumulatedLab.text = [NSString stringWithFormat:@"%@%@",[self AddComma:str1],string1];
        
    }
}

- (NSString *)AddComma:(NSString *)string{//添加逗号
    
    NSString *str=[string stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    
    int numl=(int)[str length];
    NSLog(@"%d",numl);
    
    if (numl>3&&numl<7) {
        return [NSString stringWithFormat:@"%@,%@",
                [str substringWithRange:NSMakeRange(0,numl-3)],
                [str substringWithRange:NSMakeRange(numl-3,3)]];
    }else if (numl>6){
        return [NSString stringWithFormat:@"%@,%@,%@",
                [str substringWithRange:NSMakeRange(0,numl-6)],
                [str substringWithRange:NSMakeRange(numl-6,3)],
                [str substringWithRange:NSMakeRange(numl-3,3)]];
    }else{
        return str;
    }
    
}





#pragma mark - Request Methods
//请求登陆
- (void)requestLogin:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
}


#pragma mark - NetworkModuleDelegate Methods
-(void)beginPost:(kBusinessTag)tag{
    
}
-(void)endPost:(NSString *)result business:(kBusinessTag)tag{
    NSLog(@"%s %d 收到数据:%@", __FUNCTION__, __LINE__, result);
    NSMutableDictionary *jsonDic = [result JSONValue];
    if ([[jsonDic objectForKey:@"object"] isKindOfClass:[NSString class]]) {
        
        if ([[jsonDic objectForKey:@"object"] isEqualToString:@"loginTimeout"]&&[[jsonDic objectForKey:@"success"] boolValue] == NO) {
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.logingUser removeAllObjects];
            [delegate.dictionary removeAllObjects];
            [ASIHTTPRequest setSessionCookies:nil];
            LogOutViewController *cv = [[LogOutViewController alloc] init];
            cv.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cv animated:YES];
            
        }
    }else {
        
        if (tag== kBusinessTagGetJRMyzc) {
            NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
            if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
                //数据异常处理
                [MBProgressHUD hideHUDForView:self.view animated:YES];
               // [self.view makeToast:@"获取数据异常处理"];
                //            subing = NO;
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                // [self.view makeToast:@"登录成功!"];
                [self reloadDataWith:dataArray];
            }
        } else if (tag == kBusinessTagGetJRMyBankcard){
            NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
            if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
                AccountInfoViewController *cv = [[AccountInfoViewController alloc] init];
                cv.dicData = @{};
                cv.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:cv animated:YES];
            } else {
                AccountInfoViewController *cv = [[AccountInfoViewController alloc] init];
                cv.dicData = [[jsonDic objectForKey:@"object"] objectAtIndex:0];
                cv.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:cv animated:YES];
            }
            
        } else if (tag== kBusinessTagGetJRapplyOutMoney) {
            NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
            if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
                
                TradingAccountViewController *cv = [[TradingAccountViewController alloc] init];
                cv.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:cv animated:YES];
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                delegate.strVC = @"2";
                
                if ([[[dataArray objectForKey:@"cgywcsResult"] objectForKey:@"FID_YHMMXY"] isEqualToString:@"2"]) {
                    
                    AddWithdrawViewController *vc = [[AddWithdrawViewController alloc] init];
                    
                    vc.hidesBottomBarWhenPushed = YES;
                    
                    vc.dic = dataArray;
                    
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                    nav.delegate = self;
                     nav.modalTransitionStyle = UIModalTransitionStyle;
                    [self presentViewController:nav animated:YES completion:nil];
                    
                    
                } else {
                    
                    WithdrawViewController *vc = [[WithdrawViewController alloc] init];
                    
                    vc.hidesBottomBarWhenPushed = YES;
                    
                    vc.dic = dataArray;
                    
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                    nav.delegate = self;
                     nav.modalTransitionStyle = UIModalTransitionStyle;
                    [self presentViewController:nav animated:YES completion:nil];
                    
                }
                
                
                /*
                 
                 WithdrawFirstViewController *cv = [[WithdrawFirstViewController alloc] init];
                 cv.dic = dataArray;
                 cv.hidesBottomBarWhenPushed = YES;
                 [self.navigationController pushViewController:cv animated:YES];
                 */
            }
        } else if (tag== kBusinessTagGetJRapplyOutMoneyAgain) {
            NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
            if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
                //数据异常处理
                // [MBProgressHUD hideHUDForView:self.view animated:YES];
                //[self.view makeToast:bankNumStr];
                //            subing = NO;
                
                TradingAccountViewController *cv = [[TradingAccountViewController alloc] init];
                cv.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:cv animated:YES];
                
                
                
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                // [self.view makeToast:@"登录成功!"];
                //[self reloadDataWith:dataArray];
                
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                delegate.strVC = @"2";
                /*
                 RechargeFirstViewController *cv = [[RechargeFirstViewController alloc] init];
                 cv.dic = dataArray;
                 cv.hidesBottomBarWhenPushed = YES;
                 [self.navigationController pushViewController:cv animated:YES];
                 */
                
                if ([[[dataArray objectForKey:@"cgywcsResult"] objectForKey:@"FID_YHMMXY"] isEqualToString:@"1"]) {
                    
                    AddRechargeViewController *vc = [[AddRechargeViewController alloc] init];
                    
                    vc.hidesBottomBarWhenPushed = YES;
                    
                    vc.dic = dataArray;
                    
                    
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                    nav.delegate = self;
                     nav.modalTransitionStyle = UIModalTransitionStyle;
                    [self presentViewController:nav animated:YES completion:nil];
                    
                    
                    
                } else {
                    
                    
                    
                    RechargeViewController *vc = [[RechargeViewController alloc] init];
                    
                    vc.hidesBottomBarWhenPushed = YES;
                    
                    vc.dic = dataArray;
                    
                     UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                    nav.delegate = self;
                    nav.modalTransitionStyle = UIModalTransitionStyle;
                     [self presentViewController:nav animated:YES completion:nil];
                }
                
            }
        } else if (tag== kBusinessTagGetJRupdateUserInfo) {
            NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
            if ([[jsonDic objectForKey:@"success"] boolValue] == YES) {
                //数据异常处理
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                //[self.view makeToast:bankNumStr];
                //            subing = NO;
                
                TradingAccountViewController *cv = [[TradingAccountViewController alloc] init];
                cv.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:cv animated:YES];
            }
        }
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[NetworkModule sharedNetworkModule] cancel:tag];
}

-(void)errorPost:(NSError *)err business:(kBusinessTag)tag{
    NSLog(@"%s Error:%@", __FUNCTION__, @"连接数据服务器超时");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法连接" message:@"您所在地的网络信号微弱，无法连接到服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    if (tag==kBusinessTagGetJRMyzc) {
        hasMore = 1;
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //}
    [[NetworkModule sharedNetworkModule] cancel:tag];
}





- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

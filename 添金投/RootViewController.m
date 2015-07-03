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


@interface RootViewController ()
{
    UITableView *table;
    float addHight;
    UIButton *logBtn;
    UIButton *logoinBtn;
    UIView *baseView;
    UILabel *titleLab;
}
@end

@implementation RootViewController

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
    
    
    [self.view addSubview:firstView];
    
    
    
    
    
    
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, addHight + 220, ScreenWidth - 60,ScreenHeight - 20 - 220 - 40)];
    [table setDelegate:self];
    [table setDataSource:self];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
   // [table setBackgroundColor:[ColorUtil colorWithHexString:@"eeeeee"]];
    table.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:table];
 
    UIButton *setBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, ScreenHeight - 40, (ScreenWidth - 60)/2, 40)];
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
    
    [setBtn addTarget:self action:@selector(pushSet:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth - 60)/2 - 1, 5, 1, 30)];
    line.backgroundColor = [ColorUtil colorWithHexString:@"dedede"];
    [setBtn addSubview:line];
    
    
    [self.view addSubview:setBtn];
    
    
    logBtn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth - 60)/2, ScreenHeight - 40, (ScreenWidth - 60)/2, 40)];
    logBtn.backgroundColor = [UIColor whiteColor];
    UIImageView *logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 30, 30)];
    logoImg.image = [UIImage imageNamed:@"esc"];
    [logBtn addSubview:logoImg];
    UIView *lineVeiwlog = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (ScreenWidth - 60)/2, 1)];
    lineVeiwlog.backgroundColor = [ColorUtil colorWithHexString:@"dedede"];
    [logBtn addSubview:lineVeiwlog];
    
    UILabel *setTextlogo = [[UILabel alloc] initWithFrame:CGRectMake(55, (40 - 15)/2, 30, 15)];
    setTextlogo.textColor = [ColorUtil colorWithHexString:@"666666"];
    setTextlogo.text = @"退出";
    setTextlogo.font = [UIFont systemFontOfSize:15];
    [logBtn addSubview:setTextlogo];
    
    [logBtn addTarget:self action:@selector(pushSet:) forControlEvents:UIControlEventTouchUpInside];
    logBtn.enabled = NO;
    [self.view addSubview:logBtn];
    
    
}


-(void)pushLogoin{
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    LoginViewController *controller = [[LoginViewController alloc] init];
    //controller.title = [NSString stringWithFormat:@"Cell %li", indexPath.row];
    // UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [menuController setRootController:controller animated:YES];

}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 60, 40)];
    
   
    NSArray *arrTitle = @[@"我的资产",@"当日申请",@"投资记录",@"我的收益",@"转账充值",@"资金变动",@"我的收藏",@"我的添金币",@"账户安全"];
    
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
    
    if (indexPath.row == 0) {
        

    
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    MainViewController *controller = [[MainViewController alloc] init];
    //controller.title = [NSString stringWithFormat:@"Cell %li", indexPath.row];
   // UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [menuController setRootController:controller animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    } else {
    
        DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
        HomeViewController *controller = [[HomeViewController alloc] init];
        //controller.title = [NSString stringWithFormat:@"Cell %li", indexPath.row];
       // UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        
        [menuController setRootController:controller animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    }
    
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

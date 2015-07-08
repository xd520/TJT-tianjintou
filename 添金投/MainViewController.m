//
//  MainViewController.m
//  添金投
//
//  Created by mac on 15/6/29.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "MainViewController.h"
#import "HMSegmentedControl.h"
#import "AppDelegate.h"
#import "DDMenuController.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "DetailViewController.h"
#import "UserBackViewController.h"
#import "MessgeCenterViewController.h"
#import "MyUserMangerViewController.h"
#import "RegesterViewController.h"
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"
#import "DetailViewController.h"
#import "TransferDetailsViewController.h"
#import "RegesterViewController.h"


@interface MainViewController ()
{
    float addHight;
    NSMutableArray *imageArray;
    UIScrollView *scrollViewImage;
    UIPageControl *pageControl;
    UIScrollView *backScrollView;
    NSMutableArray *dataListFirst;
    NSString *flagHub;
    
    UITableView *table;
    UITableView *tablePast;
    NSString *start;
    NSString *startBak;
    NSString *limit;
    NSMutableArray *dataList;
    BOOL hasMore;
    UITableViewCell *moreCell;
    
    NSString *startPast;
    NSString *startBakPast;
    NSString *limitPast;
    NSMutableArray *dataListPast;
    BOOL hasMorePast;
    UITableViewCell *moreCellPast;
    
    
    SRRefreshView   *_slimeViewPast;
    SRRefreshView   *_slimeView;
    NSString *allGqlb;
    
    NSInteger count;
    NSInteger indext;
    NSInteger tipcount;
    NSInteger tipindext;
    
    
    UILabel *lab1;
    UILabel *lab2;
    UILabel *lab3;
    UILabel *lab4;
    
    
    UILabel *tiplab1;
    UILabel *tiplab2;
    UILabel *tiplab3;
    UILabel *tiplab4;
    
    
    NSString *sortName;
    NSString *sortVal;
    NSString *sortNamePast;
    NSString *sortValPast;
    
    
    
    
    
}
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    start = @"1";
    limit = @"10";
    startBak = @"";
    startPast = @"1";
    limitPast = @"10";
    startBakPast = @"";
    
    sortName = @"";
    sortVal = @"";
    sortNamePast = @"";
    sortValPast = @"";
    
    count = 0;
    indext = 0;
    tipcount = 0;
    tipindext = 0;
    
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor = [ColorUtil colorWithHexString:@"e3a325"];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }

    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 130)/2,addHight + 6, 130, 32)];
    logoView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:logoView];
    

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15, addHight + (44 - 26)/2, 26, 26);
    [btn setImage:[UIImage imageNamed:@"zhzc"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 44 + addHight, ScreenWidth, 40)];
    self.segmentedControl.sectionTitles = @[@"首页", @"投资专区",@"转让专区"];
    self.segmentedControl.selectedSegmentIndex = 0;
     self.segmentedControl.backgroundColor = [ColorUtil colorWithHexString:@"ffffff"];
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [ColorUtil colorWithHexString:@"666666"]};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [ColorUtil colorWithHexString:@"e3a325"]};
    
    // self.segmentedControl4.selectionIndicatorColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
    self.segmentedControl.selectionIndicatorColor = [ColorUtil colorWithHexString:@"e3a325"];
    
    /*
     HMSegmentedControlSelectionStyleTextWidthStripe, // Indicator width will only be as big as the text width
     HMSegmentedControlSelectionStyleFullWidthStripe, // Indicator width will fill the whole segment
     HMSegmentedControlSelectionStyleBox, // A rectangle that covers the whole segment
     HMSegmentedControlSelectionStyleArrow
     */
    
    
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
   // self.segmentedControl.selectionIndicatorHeight = 2;
    self.segmentedControl.tag = 3;
    
    __weak typeof(self) weakSelf = self;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(ScreenWidth * index, 0, ScreenWidth,  ScreenHeight - 114) animated:YES];
        if (index == 1) {
            
            if (dataList.count > 0) {
                [dataList removeAllObjects];
            }
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.dimBackground = YES;
            hud.delegate = self;
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.labelText = @"加载中...";
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                //[self requestCategoryList:start limit:limit tag:kBusinessTagGetJRwdtzloadData];
                start = @"1";
                //投资专区
                [self requestList:start limit:limit sortName:sortName val:sortVal tag:kBusinessTagGetJRwdtzloadData];
                
                //转让专区
                // [self requestTransferList:startPast limit:limitPast sortName:sortNamePast val:sortValPast tag:kBusinessTagGetJRcpzrwytz1];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            });
            
        } else if (index == 2) {
            
            if (dataListPast.count > 0) {
                [dataListPast removeAllObjects];
            }
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.dimBackground = YES;
            hud.delegate = self;
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.labelText = @"加载中...";
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                //[self requestCategoryList:start limit:limit tag:kBusinessTagGetJRwdtzloadData];
                //投资专区
                //[self requestList:start limit:limit sortName:sortName val:sortVal tag:kBusinessTagGetJRwdtzloadData];
                startPast = @"1";
                //转让专区
                 [self requestTransferList:startPast limit:limitPast sortName:sortNamePast val:sortValPast tag:kBusinessTagGetJRcpzrwytz1];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            });
            
        
        }
        
        
    }];
    
    
    UIView *viewLine0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    viewLine0.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [self.segmentedControl addSubview:viewLine0];
    
    
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 39, ScreenWidth, 1)];
    viewLine.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [self.segmentedControl addSubview:viewLine];
    
    
    [self.view addSubview:self.segmentedControl];
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 84 + addHight, ScreenWidth, ScreenHeight - 104)];
   // self.scrollView.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(ScreenWidth * 3,  ScreenHeight - 104);
    self.scrollView.delegate = self;
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, ScreenWidth,  ScreenHeight - 104) animated:NO];
    [self.view addSubview:self.scrollView];
    
    
    NSArray *titleArr = @[@"默认",@"预期收益↑",@"投资期限↑",@"起投金额↑"];
    float autoSizeScaleX,autoSizeScaleY;
    if(ScreenHeight > 480){
        autoSizeScaleX = ScreenWidth/320;
        autoSizeScaleY = ScreenHeight/568;
    }else{
        autoSizeScaleX = 1.0;
        autoSizeScaleY = 1.0;
    }
    
    
    //↓
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [[UIButton alloc] init];
        
        btn.tag = i;
        btn.backgroundColor = [UIColor whiteColor];
        
        if (i == 0) {
            
            btn.frame = CGRectMake(ScreenWidth + 0, 0, 55*autoSizeScaleX, 40);
            
            lab1 = [[UILabel alloc] init];
            lab1.frame = CGRectMake(0, 5, 55*autoSizeScaleX-0.5, 30);
            lab1.text = [titleArr objectAtIndex:i];
            lab1.textAlignment = NSTextAlignmentCenter;
            lab1.font = [UIFont systemFontOfSize:13];
            //lab1.userInteractionEnabled = YES;
            lab1.textColor = [ColorUtil colorWithHexString:@"fe8103"];
            [btn addSubview:lab1];
            
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(55*autoSizeScaleX - 0.5, 12.5, 0.5, 15)];
            img.image = [UIImage imageNamed:@"line_iocn"];
            [btn addSubview:img];
        } else if(i == 1){
            btn.frame = CGRectMake(ScreenWidth + 55*autoSizeScaleX, 0, 87.5*autoSizeScaleX, 40);
            lab2 = [[UILabel alloc] init];
            lab2.frame = CGRectMake(0, 5, 87.5*autoSizeScaleX - 0.5, 30);
            lab2.text = [titleArr objectAtIndex:i];
            lab2.font = [UIFont systemFontOfSize:13];
            lab2.textAlignment = NSTextAlignmentCenter;
            lab2.textColor = [ColorUtil colorWithHexString:@"999999"];
            //lab2.userInteractionEnabled = YES;
            lab2.textColor = [UIColor grayColor];
            [btn addSubview:lab2];
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(87.5*autoSizeScaleX -0.5, 12.5, 0.5, 15)];
            img.image = [UIImage imageNamed:@"line_iocn"];
            [btn addSubview:img];
        } else if(i == 2){
            btn.frame = CGRectMake(ScreenWidth + (55 + 87.5)*autoSizeScaleX, 0, 87.5*autoSizeScaleX, 40);
            lab3 = [[UILabel alloc] init];
            lab3.frame = CGRectMake(0, 5, 87.5*autoSizeScaleX - 0.5, 30);
            lab3.text = [titleArr objectAtIndex:i];
            lab3.font = [UIFont systemFontOfSize:13];
            lab3.textAlignment = NSTextAlignmentCenter;
            lab3.textColor = [ColorUtil colorWithHexString:@"999999"];
            //lab3.userInteractionEnabled = YES;
            lab3.textColor = [UIColor grayColor];
            [btn addSubview:lab3];
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(87.5*autoSizeScaleX - 0.5, 12.5, 0.5, 15)];
            img.image = [UIImage imageNamed:@"line_iocn"];
            [btn addSubview:img];
        }else if(i == 3){
            btn.frame = CGRectMake(ScreenWidth + (55 + 175)*autoSizeScaleX, 0, 90*autoSizeScaleX, 40);
            lab4 = [[UILabel alloc] init];
            lab4.frame = CGRectMake(0, 5, 90*autoSizeScaleX, 30);
            lab4.text = [titleArr objectAtIndex:i];
            lab4.font = [UIFont systemFontOfSize:13];
            lab4.textColor = [ColorUtil colorWithHexString:@"999999"];
            lab4.textAlignment = NSTextAlignmentCenter;
            //lab4.userInteractionEnabled = YES;
            lab4.textColor = [UIColor grayColor];
            [btn addSubview:lab4];
            
        }
        
        // btn.titleLabel.font = [UIFont systemFontOfSize:13];
        //btn.titleLabel.textColor = [UIColor redColor];
        
        [btn addTarget:self action:@selector(secelectMenthosd:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
        
    }
    
    
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [[UIButton alloc] init];
        // btn.frame = CGRectMake(ScreenWidth + 80*i, 0, 80, 40);
        btn.tag = i;
        btn.backgroundColor = [UIColor whiteColor];
        //[btn setTitle:[titleArr objectAtIndex:i] forState:UIControlStateNormal];
        //[btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        // [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        if (i == 0) {
            btn.frame = CGRectMake(ScreenWidth*2 + 0, 0, 55*autoSizeScaleX, 40);
            tiplab1 = [[UILabel alloc] init];
            tiplab1.frame = CGRectMake(0, 5, 55*autoSizeScaleX - 0.5, 30);
            tiplab1.text = [titleArr objectAtIndex:i];
            tiplab1.textAlignment = NSTextAlignmentCenter;
            tiplab1.font = [UIFont systemFontOfSize:13];
            //lab1.userInteractionEnabled = YES;
            tiplab1.textColor = [ColorUtil colorWithHexString:@"fe8103"];
            [btn addSubview:tiplab1];
            
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(55*autoSizeScaleX - 0.5, 12.5, 0.5, 15)];
            img.image = [UIImage imageNamed:@"line_iocn"];
            [btn addSubview:img];
        } else if(i == 1){
            btn.frame = CGRectMake(ScreenWidth*2 + 55*autoSizeScaleX, 0, 87.5*autoSizeScaleX, 40);
            tiplab2 = [[UILabel alloc] init];
            tiplab2.frame = CGRectMake(0, 5, 87.5*autoSizeScaleX - 0.5, 30);
            tiplab2.text = [titleArr objectAtIndex:i];
            tiplab2.font = [UIFont systemFontOfSize:13];
            tiplab2.textColor = [ColorUtil colorWithHexString:@"999999"];
            tiplab2.textAlignment = NSTextAlignmentCenter;
            //lab2.userInteractionEnabled = YES;
            tiplab2.textColor = [UIColor grayColor];
            [btn addSubview:tiplab2];
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake( 87.5*autoSizeScaleX - 0.5, 12.5, 0.5, 15)];
            img.image = [UIImage imageNamed:@"line_iocn"];
            [btn addSubview:img];
        } else if(i == 2){
            btn.frame = CGRectMake(ScreenWidth*2 + (55 + 87.5)*autoSizeScaleX, 0, 87.5*autoSizeScaleX, 40);
            tiplab3 = [[UILabel alloc] init];
            tiplab3.frame = CGRectMake(0, 5, 87.5*autoSizeScaleX - 0.5, 30);
            tiplab3.text = [titleArr objectAtIndex:i];
            tiplab3.font = [UIFont systemFontOfSize:13];
            tiplab3.textAlignment = NSTextAlignmentCenter;
            tiplab3.textColor = [ColorUtil colorWithHexString:@"999999"];
            //lab3.userInteractionEnabled = YES;
            tiplab3.textColor = [UIColor grayColor];
            [btn addSubview:tiplab3];
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(87.5*autoSizeScaleX - 0.5, 12.5, 0.5, 15)];
            img.image = [UIImage imageNamed:@"line_iocn"];
            [btn addSubview:img];
        }else if(i == 3){
            btn.frame = CGRectMake(ScreenWidth*2 + (55 + 175)*autoSizeScaleX, 0, 90*autoSizeScaleX, 40);
            tiplab4 = [[UILabel alloc] init];
            tiplab4.frame = CGRectMake(0, 5, 90*autoSizeScaleX, 30);
            tiplab4.text = [titleArr objectAtIndex:i];
            tiplab4.font = [UIFont systemFontOfSize:13];
            tiplab4.textAlignment = NSTextAlignmentCenter;
            tiplab4.textColor = [ColorUtil colorWithHexString:@"999999"];
            //lab4.userInteractionEnabled = YES;
            tiplab4.textColor = [UIColor grayColor];
            [btn addSubview:tiplab4];
            
        }
        
        // btn.titleLabel.font = [UIFont systemFontOfSize:13];
        //btn.titleLabel.textColor = [UIColor redColor];
        
        [btn addTarget:self action:@selector(secelectMenthosd1:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
        
    }
    
    
    //添加tableView
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth, 40, ScreenWidth,ScreenHeight - 60 - 80)];
    [table setDelegate:self];
    [table setDataSource:self];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table setBackgroundColor:[ColorUtil colorWithHexString:@"eeeeee"]];
    table.tableFooterView = [[UIView alloc] init];
    
    [self.scrollView addSubview:table];
    
    //加入下拉刷新
    _slimeView = [[SRRefreshView alloc] init];
    _slimeView.delegate = self;
    _slimeView.upInset = 0;
    _slimeView.slimeMissWhenGoingBack = YES;
    _slimeView.slime.bodyColor = [UIColor blackColor];
    _slimeView.slime.skinColor = [UIColor whiteColor];
    _slimeView.slime.lineWith = 1;
    _slimeView.slime.shadowBlur = 4;
    _slimeView.slime.shadowColor = [UIColor blackColor];
    [table addSubview:_slimeView];
    
    
    
    
    //添加tableView
    
    tablePast = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth*2,40, ScreenWidth, ScreenHeight - 60 - 80)];
    [tablePast setDelegate:self];
    [tablePast setDataSource:self];
    tablePast.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tablePast setBackgroundColor:[ColorUtil colorWithHexString:@"eeeeee"]];
    tablePast.tableFooterView = [[UIView alloc] init];
    
    [self.scrollView addSubview:tablePast];
    
    //加入下拉刷新
    _slimeViewPast = [[SRRefreshView alloc] init];
    _slimeViewPast.delegate = self;
    _slimeViewPast.upInset = 0;
    _slimeViewPast.slimeMissWhenGoingBack = YES;
    _slimeViewPast.slime.bodyColor = [UIColor blackColor];
    _slimeViewPast.slime.skinColor = [UIColor whiteColor];
    _slimeViewPast.slime.lineWith = 1;
    _slimeViewPast.slime.shadowBlur = 4;
    _slimeViewPast.slime.shadowColor = [UIColor blackColor];
    [tablePast addSubview:_slimeViewPast];
    
    
    
    // 定时器 循环
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    
    //[self getUI];
    
    
    backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0 , ScreenWidth,  ScreenHeight - 64  - 40)];
    
    [backScrollView setContentSize:CGSizeMake(ScreenWidth, 455)];
    [self.scrollView addSubview:backScrollView];
    
    
    NSArray *arrName = @[@"免费注册",@"我的收藏",@"添金投公告",@"添金投新闻"];
    NSArray *arrImg = @[@"geren",@"fav",@"gonggao",@"jigou"];
    for (int i = 0; i < 4; i++) {
        UIView *view = [[UIView alloc] init];
        if (i == 0) {
            view.frame = CGRectMake(10,  350, ScreenWidth/2 - 15, 45);
            } else if(i == 1){
             view.frame = CGRectMake(ScreenWidth/2 + 5,  350, ScreenWidth/2 - 15, 45);
                
                
            } else if(i == 2){
            view.frame = CGRectMake(10,  400, ScreenWidth/2 - 15, 45);
                
                
           }else if(i == 3){
               
             view.frame = CGRectMake(ScreenWidth/2 + 5,  400, ScreenWidth/2 - 15, 45);
               
               
                        }
        
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 2;
        view.layer.masksToBounds = YES;
        view.layer.borderWidth = 1;
        view.layer.borderColor = [ColorUtil colorWithHexString:@"e5e5e5"].CGColor;
      
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10,(45 - 32)/2, 32, 32)];
        img.image = [UIImage imageNamed:[arrImg objectAtIndex:i]];
        view.tag = 3 + i;
        [view addSubview:img];
        
        //名称
        UILabel *labName = [[UILabel alloc] initWithFrame:CGRectMake(32 + 15, 15, ScreenWidth/2 - 15 - 57, 15)];
        labName.text = [arrName objectAtIndex:i];
        labName.font = [UIFont systemFontOfSize:15];
        labName.textColor = [ColorUtil colorWithHexString:@"333333"];
        [view addSubview:labName];
        
       
        
        
        UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
        
        singleTap2.numberOfTouchesRequired = 1;
        //点击几次，如果是1就是单击
        singleTap2.numberOfTapsRequired = 1;
        [view addGestureRecognizer:singleTap2];
        
        [backScrollView addSubview:view];
    }
    
    
    
    
    
    
    
    
    
    
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES; //加层阴影
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        //[self requestLogin:kBusinessTagGetJRhotproject];
        [self requestUpdateLinkMan];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    
    
    MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud1.dimBackground = YES; //加层阴影
    hud1.mode = MBProgressHUDModeIndeterminate;
    hud1.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        [self requestLogin:kBusinessTagGetJRhotproject];
        //[self requestUpdateLinkMan];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    
}


-(void)secelectMenthosd1:(UIButton *)btn {
    
    // NSArray *titleArr = @[@"默认",@"预期收益↑",@"投资期限↑",@"起投金额↑"];
    //↓
    
    if (btn.tag == tipcount) {
        tipindext++;
    } else {
        tipcount = btn.tag;
        tipindext = 0;
    }
    
    if (btn.tag == 0) {
        tiplab2.textColor = [ColorUtil colorWithHexString:@"999999"];
        tiplab4.textColor = [ColorUtil colorWithHexString:@"999999"];
        tiplab3.textColor = [ColorUtil colorWithHexString:@"999999"];
        tiplab1.textColor = [ColorUtil colorWithHexString:@"fe8103"];
        sortNamePast = @"FID_WTH";
        sortValPast = @"";
        
    } else if (btn.tag == 1) {
        // lab2.textColor = [UIColor grayColor];
        tiplab4.textColor = [ColorUtil colorWithHexString:@"999999"];
        tiplab3.textColor = [ColorUtil colorWithHexString:@"999999"];
        tiplab1.textColor = [ColorUtil colorWithHexString:@"999999"];
        sortNamePast = @"FID_SYL";
        if (tipindext%2 == 0) {
            tiplab2.textColor = [ColorUtil colorWithHexString:@"fe8103"];
            tiplab2.text = @"预期收益↑";
            sortValPast = @"ASC";
        } else {
            
            tiplab2.textColor = [ColorUtil colorWithHexString:@"fe8103"];
            tiplab2.text = @"预期收益↓";
            sortValPast = @"DESC";
        }
        
        
    } else if (btn.tag == 2){
        tiplab2.textColor = [ColorUtil colorWithHexString:@"999999"];
        tiplab4.textColor = [ColorUtil colorWithHexString:@"999999"];
        //lab3.textColor = [UIColor grayColor];
        tiplab1.textColor = [ColorUtil colorWithHexString:@"999999"];
        sortNamePast = @"FID_SYTS";
        if (tipindext%2 == 0) {
            tiplab3.textColor = [ColorUtil colorWithHexString:@"fe8103"];
            tiplab3.text = @"投资期限↑";
            sortValPast = @"ASC";
        } else {
            
            tiplab3.textColor = [ColorUtil colorWithHexString:@"fe8103"];
            tiplab3.text = @"投资期限↓";
            sortValPast = @"DESC";
        }
        
    } else if (btn.tag == 3) {
        tiplab2.textColor = [ColorUtil colorWithHexString:@"999999"];
        // lab4.textColor = [UIColor grayColor];
        tiplab3.textColor = [ColorUtil colorWithHexString:@"999999"];
        tiplab1.textColor = [ColorUtil colorWithHexString:@"999999"];
        sortNamePast = @"FID_CJJE";
        if (tipindext%2 == 0) {
            tiplab4.textColor = [ColorUtil colorWithHexString:@"fe8103"];
            tiplab4.text = @"起投金额↑";
            sortValPast = @"ASC";
        } else {
            
            tiplab4.textColor = [ColorUtil colorWithHexString:@"fe8103"];
            tiplab4.text = @"起投金额↓";
            sortValPast = @"DESC";
        }
        
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        //[self requestCategoryList:start limit:limit tag:kBusinessTagGetJRwdtzloadDataAgain];
        
        startPast = @"1";
        //转让专区
        [self requestTransferList:startPast limit:limitPast sortName:sortNamePast val:sortValPast tag:kBusinessTagGetJRcpzrwytz1Again];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            
        });
    });
    
    
}


- (void)requestTransferList:(NSString *)_start limit:(NSString *)_limit sortName:(NSString *)_sort val:(NSString *)_val tag:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求品牌列表");
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    
    //获取类别信息
    [paraDic setObject:_sort forKey:@"sortName"];
    [paraDic setObject:_val forKey:@"sortVal"];
    [paraDic setObject:_limit forKey:@"pageSize"];
    [paraDic setObject:_start forKey:@"pageNo"];
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
}





- (void)requestList:(NSString *)_start limit:(NSString *)_limit sortName:(NSString *)_sort val:(NSString *)_val tag:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求品牌列表");
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    
    //获取类别信息
    [paraDic setObject:_sort forKey:@"sortName"];
    [paraDic setObject:_val forKey:@"sortVal"];
    [paraDic setObject:_limit forKey:@"pageSize"];
    [paraDic setObject:_start forKey:@"pageIndex"];
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
}




-(void)secelectMenthosd:(UIButton *)btn {
    
    // NSArray *titleArr = @[@"默认",@"预期收益↑",@"投资期限↑",@"起投金额↑"];
    //↓
    
    
    if (btn.tag == count) {
        indext++;
    } else {
        count = btn.tag;
        indext = 0;
    }
    
    
    if (btn.tag == 0) {
        lab2.textColor = [ColorUtil colorWithHexString:@"999999"];
        lab4.textColor = [ColorUtil colorWithHexString:@"999999"];
        lab3.textColor = [ColorUtil colorWithHexString:@"999999"];
        lab1.textColor = [ColorUtil colorWithHexString:@"fe8103"];
        
        sortName = @"";
        sortVal = @"";
        
    } else if (btn.tag == 1) {
        // lab2.textColor = [UIColor grayColor];
        lab4.textColor = [UIColor grayColor];
        lab3.textColor = [UIColor grayColor];
        lab1.textColor = [UIColor grayColor];
        
        sortName = @"pmll";
        
        if (indext%2 == 0) {
            lab2.textColor = [ColorUtil colorWithHexString:@"fe8103"];
            lab2.text = @"预期收益↑";
            sortVal = @"asc";
            
        } else {
            
            lab2.textColor = [ColorUtil colorWithHexString:@"fe8103"];
            lab2.text = @"预期收益↓";
            sortVal = @"desc";
        }
        
        
        
        
    } else if (btn.tag == 2){
        lab2.textColor = [ColorUtil colorWithHexString:@"999999"];
        lab4.textColor = [ColorUtil colorWithHexString:@"999999"];
        //lab3.textColor = [UIColor grayColor];
        lab1.textColor = [ColorUtil colorWithHexString:@"999999"];
        
        sortName = @"tzqx";
        
        if (indext%2 == 0) {
            lab3.textColor = [ColorUtil colorWithHexString:@"fe8103"];
            lab3.text = @"投资期限↑";
            sortVal = @"asc";
        } else {
            
            lab3.textColor = [ColorUtil colorWithHexString:@"fe8103"];
            lab3.text = @"投资期限↓";
            sortVal = @"desc";
        }
        
    } else if (btn.tag == 3) {
        lab2.textColor = [ColorUtil colorWithHexString:@"999999"];
        // lab4.textColor = [UIColor grayColor];
        lab3.textColor = [ColorUtil colorWithHexString:@"999999"];
        lab1.textColor = [ColorUtil colorWithHexString:@"999999"];
        
        sortName = @"qscpxx";
        if (indext%2 == 0) {
            lab4.textColor = [ColorUtil colorWithHexString:@"fe8103"];
            lab4.text = @"起投金额↑";
            sortVal = @"asc";
        } else {
            
            lab4.textColor = [ColorUtil colorWithHexString:@"fe8103"];
            lab4.text = @"起投金额↓";
            sortVal = @"desc";
        }
        
        
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        //[self requestCategoryList:start limit:limit tag:kBusinessTagGetJRwdtzloadDataAgain];
        
        start = @"1";
        [self requestList:start limit:limit sortName:sortName val:sortVal tag:kBusinessTagGetJRwdtzloadDataAgain];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            
        });
    });
    
    
}

#pragma mark - slimeRefresh delegate
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    if (refreshView == _slimeView) {
        
        lab2.textColor = [ColorUtil colorWithHexString:@"999999"];
        lab4.textColor = [ColorUtil colorWithHexString:@"999999"];
        lab3.textColor = [ColorUtil colorWithHexString:@"999999"];
        lab1.textColor = [ColorUtil colorWithHexString:@"fe8103"];
        
        startBak = [NSString stringWithString:start];
        start = @"1";
        
        sortName = @"";
        sortVal = @"";
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [self requestList:start limit:limit sortName:sortName val:sortVal tag:kBusinessTagGetJRwdtzloadDataAgain];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                
            });
        });
        
    } else if (refreshView == _slimeViewPast){
        
        
        tiplab2.textColor = [ColorUtil colorWithHexString:@"999999"];
        tiplab4.textColor = [ColorUtil colorWithHexString:@"999999"];
        tiplab3.textColor = [ColorUtil colorWithHexString:@"999999"];
        tiplab1.textColor = [ColorUtil colorWithHexString:@"fe8103"];
        
        startBakPast = [NSString stringWithString:startPast];
        startPast = @"1";
        sortNamePast = @"";
        sortValPast = @"";
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            
            [self requestTransferList:startPast limit:limitPast sortName:sortNamePast val:sortValPast tag:kBusinessTagGetJRcpzrwytz1Again];
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
        
        
        
    }
    
    
    
}
#pragma mark - UIScrollView Delegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == table) {
        [_slimeView scrollViewDidScroll];
    } else if(scrollView == tablePast){
        [_slimeViewPast scrollViewDidScroll];
        
    } else {
        CGFloat pagewidth = scrollViewImage.frame.size.width;
        int page = floor((scrollViewImage.contentOffset.x - pagewidth/([imageArray count]+2))/pagewidth)+1;
        page --;  // 默认从第二页开始
        pageControl.currentPage = page;
    
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == table) {
        [_slimeView scrollViewDidEndDraging];
    } else {
        
        [_slimeViewPast scrollViewDidEndDraging];
    }
    
}

- (void)tableView:(UITableView *)tbleView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tbleView == table) {
        
        
        if ([indexPath row] == [dataList count]) {
            if (hasMore) {
                for (UILabel *label in [cell.contentView subviews]) {
                    if ([label.text isEqualToString:@"*****正在加载*****"]) {
                        
                    } else {
                        
                        label.text = @"*****正在加载*****";
                        
                        [self requestList:start limit:limit sortName:sortName val:sortVal tag:kBusinessTagGetJRwdtzloadData];
                        [tbleView deselectRowAtIndexPath:indexPath animated:YES];
                    }
                }
            }
        }
    }else if (tbleView == tablePast){
        if ([indexPath row] == [dataListPast count]) {
            if (hasMorePast) {
                for (UILabel *label in [cell.contentView subviews]) {
                    if ([label.text isEqualToString:@"*****正在加载*****"]) {
                        
                    } else {
                        
                        label.text = @"*****正在加载*****";
                        
                        [self requestTransferList:startPast limit:limitPast sortName:sortNamePast val:sortValPast tag:kBusinessTagGetJRcpzrwytz1];
                        [tbleView deselectRowAtIndexPath:indexPath animated:YES];
                    }
                }
            }
        }
    }
}

#pragma mark - UITableView DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == table) {
        if ([dataList count] == 0) {
            return 1;
        } else if (hasMore) {
            return [dataList count] + 1;
        } else {
            return [dataList count];
        }
    } else {
        
        if ([dataListPast count] == 0) {
            return 1;
        } else if (hasMorePast) {
            return [dataListPast count] + 1;
        } else {
            return [dataListPast count];
        }
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tbleView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView setScrollEnabled:NO]; tableView 不能滑动
    static NSString *RepairCellIdentifier = @"RepairCellIdentifier";
    UITableViewCell *cell;
    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    
    if (tbleView == table) {
        
        if ([dataList count] == 0) {
            if (YES) {
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 50)];
                [backView setBackgroundColor:[ColorUtil colorWithHexString:@"ececec"]];
                //图标
                UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 57)/2, 100, 57, 57)];
                [iconImageView setImage:[UIImage imageNamed:@"icon_none"]];
                [backView addSubview:iconImageView];
                //提示
                UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.frame.origin.y + iconImageView.frame.size.height + 27, ScreenWidth, 15)];
                [tipLabel setFont:[UIFont systemFontOfSize:15]];
                [tipLabel setTextAlignment:NSTextAlignmentCenter];
                [tipLabel setTextColor:[ColorUtil colorWithHexString:@"404040"]];
                tipLabel.backgroundColor = [UIColor clearColor];
                [tipLabel setText:@"没有任何商品哦~"];
                [backView addSubview:tipLabel];
                [cell.contentView addSubview:backView];
                
            }
        } else {
            if ([indexPath row] == [dataList count]) {
                moreCell = [tbleView dequeueReusableCellWithIdentifier:@"loadMoreCell"];
                moreCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loadMoreCell"];
                [moreCell setBackgroundColor:[UIColor clearColor]];
                moreCell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *toastLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 160, 59)];
                [toastLabel setFont:[UIFont systemFontOfSize:12]];
                toastLabel.backgroundColor = [UIColor clearColor];
                [toastLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                toastLabel.numberOfLines = 0;
                toastLabel.text = @"更多...";
                toastLabel.textAlignment = NSTextAlignmentCenter;
                [moreCell.contentView addSubview:toastLabel];
                return moreCell;
            } else {
                cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 105)];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell setBackgroundColor:[ColorUtil colorWithHexString:@"eeeeee"]];
                    //添加背景View
                    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, 95)];
                    [backView setBackgroundColor:[UIColor whiteColor]];
                    backView.layer.cornerRadius = 2;
                    backView.layer.masksToBounds = YES;
                    
                    //品牌
                    UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, ScreenWidth - 40, 15)];
                    brandLabel.font = [UIFont systemFontOfSize:15];
                    [brandLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    [brandLabel setBackgroundColor:[UIColor clearColor]];
                    // brandLabel.numberOfLines = 0;
                    brandLabel.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"cpmc"];
                    [backView addSubview:brandLabel];
                    
                    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 49, ScreenWidth - 20, 1)];
                    lineView.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
                    //[backView addSubview:lineView];
                    
                    /*
                     //预期年华
                     NSArray *titleArr = @[@"预期年化",@"存续期",@"起购金额",@"进度"];
                     for (int i = 0;i < 4;i++) {
                     UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/4 * i, 55, ScreenWidth/4, 15)];
                     lab.text = [titleArr objectAtIndex:i];
                     lab.font = [UIFont systemFontOfSize:15];
                     lab.textColor = [ColorUtil colorWithHexString:@"666666"];
                     lab.textAlignment = NSTextAlignmentCenter;
                     [backView addSubview:lab];
                     }
                     */
                    //数字开始
                    UILabel *numYQH = [[UILabel alloc] init];
                    numYQH.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"gzll"];
                    numYQH.font = [UIFont systemFontOfSize:28];
                    numYQH.textColor = [ColorUtil colorWithHexString:@"fe8103"];
                    CGSize titleSize = [numYQH.text sizeWithFont:numYQH.font constrainedToSize:CGSizeMake(MAXFLOAT, 28)];
                    numYQH.frame = CGRectMake(10, 45, titleSize.width, 28);
                    [backView addSubview:numYQH];
                    
                    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10 + titleSize.width, 71 - 13, 13, 13)];
                    lab.text = @"%";
                    lab.textColor = [ColorUtil colorWithHexString:@"fe8103"];
                    lab.font = [UIFont systemFontOfSize:13];
                    [backView addSubview:lab];
                    
                    
                    //续存期
                    
                    UILabel *dateLabel = [[UILabel alloc] init];
                    dateLabel.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"tzqx"];
                    dateLabel.font = [UIFont systemFontOfSize:12];
                    dateLabel.textColor = [ColorUtil colorWithHexString:@"333333"];
                    titleSize = [dateLabel.text sizeWithFont:dateLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 12)];
                    
                    dateLabel.frame = CGRectMake(ScreenWidth/4 + 20, 43, titleSize.width, 12);
                    
                    
                    [backView addSubview:dateLabel];
                    
                    
                    UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake( ScreenWidth/4 + 20 + titleSize.width, 43, 12, 12)];
                    dayLabel.text = @"天";
                    dayLabel.font = [UIFont systemFontOfSize:12];
                    dayLabel.textColor = [ColorUtil colorWithHexString:@"999999"];
                    [backView addSubview:dayLabel];
                    
                    
                    
                    
                    
                    UILabel *tipdate = [[UILabel alloc] initWithFrame:CGRectMake( ScreenWidth/4 + 55, 43, 115, 12)];
                    tipdate.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"jxfs"];
                    tipdate.font = [UIFont systemFontOfSize:12];
                    tipdate.textColor = [ColorUtil colorWithHexString:@"333333"];
                    // moneyLabel.textAlignment = NSTextAlignmentCenter;
                    [backView addSubview:tipdate];
                    
                    
                    
                    
                    //起购金额
                    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake( ScreenWidth/4 + 20, 63, ScreenWidth/2, 17)];
                    moneyLabel.text = [NSString stringWithFormat:@"%@元起",[[dataList objectAtIndex:indexPath.row] objectForKey:@"tzje"]];
                    moneyLabel.font = [UIFont systemFontOfSize:14];
                    moneyLabel.textColor = [ColorUtil colorWithHexString:@"333333"];
                    // moneyLabel.textAlignment = NSTextAlignmentCenter;
                    [backView addSubview:moneyLabel];
                    //剩余可投金额
                    //投资进度
                    CGRect frame = CGRectMake(ScreenWidth - 70, 35, 44, 44);
                    MDRadialProgressTheme *newTheme12 = [[MDRadialProgressTheme alloc] init];
                    //newTheme12.completedColor = [UIColor colorWithRed:90/255.0 green:212/255.0 blue:39/255.0 alpha:1.0];
                    //newTheme12.incompletedColor = [UIColor colorWithRed:164/255.0 green:231/255.0 blue:134/255.0 alpha:1.0];
                    newTheme12.centerColor = [UIColor clearColor];
                    //newTheme.centerColor = [UIColor colorWithRed:224/255.0 green:248/255.0 blue:216/255.0 alpha:1.0];
                    
                    newTheme12.sliceDividerHidden = NO;
                    newTheme12.labelColor = [UIColor blackColor];
                    newTheme12.labelShadowColor = [UIColor whiteColor];
                    
                    
                    MDRadialProgressView *radialView = [[MDRadialProgressView alloc] initWithFrame:frame andTheme:newTheme12];
                    radialView.progressTotal = 100;
                    radialView.startingSlice = 75;
                    radialView.theme.thickness = 10;
                    radialView.theme.sliceDividerHidden = YES;
                    int kt;
                    if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"jyzt"] isEqualToString:@"0"]||[[[dataList objectAtIndex:indexPath.row] objectForKey:@"cz"] isEqualToString:@"1"]||[[[dataList objectAtIndex:indexPath.row] objectForKey:@"flag"] isEqualToString:@"1"]) {
                        kt = 100;
                        radialView.progressCounter = 100;
                        
                        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 45, 7.5 , 45,35)];
                        imageView.image = [UIImage imageNamed:@"more_icon"];
                        
                        //[backView addSubview:imageView];
                        
                        
                    } else{
                        
                        if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"jyzt"] isEqualToString:@"-2"]&& [[[dataList objectAtIndex:indexPath.row] objectForKey:@"cz"] isEqualToString:@"-1"]&& [[[dataList objectAtIndex:indexPath.row] objectForKey:@"cz"] isEqualToString:@"-1"]) {
                            UIView *prowgressView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth*3/4 + 20, 80, 40, 18)];
                            prowgressView.layer.borderWidth = 1;
                            prowgressView.layer.borderColor = [UIColor redColor].CGColor;
                            
                            kt =  [[[dataList objectAtIndex:indexPath.row] objectForKey:@"tzjd"] intValue];
                            
                            radialView.progressCounter = kt;
                            
                            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 45, 7.5 , 45, 35)];
                            
                            imageView.image = [UIImage imageNamed:@"rengou"];
                            
                            //[backView addSubview:imageView];
                            
                            
                            
                        } else {
                            
                            
                            kt =  [[[dataList objectAtIndex:indexPath.row] objectForKey:@"tzjd"] intValue];
                            
                            radialView.progressCounter = kt;
                            
                            
                            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 45, 7.5 , 45,35)];
                            imageView.image = [UIImage imageNamed:@"jieshu"];
                            
                            //[backView addSubview:imageView];
                            
                            
                        }
                    }
                    
                    radialView.theme.sliceDividerHidden = YES;
                    radialView.theme.incompletedColor = [ColorUtil colorWithHexString:@"eeeeee"];
                    if (kt == 0) {
                        radialView.theme.completedColor = [ColorUtil colorWithHexString:@"eeeeee"];
                    } else{
                        radialView.theme.completedColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
                    }
                    [backView addSubview:radialView];
                    
                    /*
                     NSArray *preasent = @[@"%",@"天",@"元"];
                     
                     for (int i = 0; i< 3; i++) {
                     UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/4 * i, 80 + 17 + 5, ScreenWidth/4, 13)];
                     lab.text = [preasent objectAtIndex:i];
                     lab.font = [UIFont systemFontOfSize:13];
                     if (i == 0) {
                     lab.textColor = [ColorUtil colorWithHexString:@"c41e1e"];
                     } else {
                     lab.textColor = [ColorUtil colorWithHexString:@"666666"];
                     }
                     lab.textAlignment = NSTextAlignmentCenter;
                     [backView addSubview:lab];
                     }
                     */
                    
                    [cell.contentView addSubview:backView];
                }
            }
            return cell;
        }
        return cell;
        
    } else if (tablePast == tbleView){
        if ([dataListPast count] == 0) {
            if (YES) {
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 50)];
                [backView setBackgroundColor:[ColorUtil colorWithHexString:@"ececec"]];
                //图标
                UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 57)/2, 100, 57, 57)];
                [iconImageView setImage:[UIImage imageNamed:@"icon_none"]];
                [backView addSubview:iconImageView];
                //提示
                UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.frame.origin.y + iconImageView.frame.size.height + 27, ScreenWidth, 15)];
                [tipLabel setFont:[UIFont systemFontOfSize:15]];
                [tipLabel setTextAlignment:NSTextAlignmentCenter];
                [tipLabel setTextColor:[ColorUtil colorWithHexString:@"404040"]];
                [tipLabel setText:@"没有任何商品哦~"];
                tipLabel.backgroundColor = [UIColor clearColor];
                [backView addSubview:tipLabel];
                [cell.contentView addSubview:backView];
                
            }
        } else {
            if ([indexPath row] == [dataListPast count]) {
                moreCellPast = [tbleView dequeueReusableCellWithIdentifier:@"loadMoreCell"];
                moreCellPast = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loadMoreCell"];
                [moreCellPast setBackgroundColor:[UIColor clearColor]];
                moreCellPast.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *toastLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 160, 59)];
                [toastLabel setFont:[UIFont systemFontOfSize:12]];
                toastLabel.backgroundColor = [UIColor clearColor];
                [toastLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                toastLabel.numberOfLines = 0;
                toastLabel.text = @"更多...";
                toastLabel.textAlignment = NSTextAlignmentCenter;
                [moreCellPast.contentView addSubview:toastLabel];
                return moreCellPast;
            } else {
                cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 105)];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell setBackgroundColor:[ColorUtil colorWithHexString:@"eeeeee"]];
                    //添加背景View
                    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, 95)];
                    [backView setBackgroundColor:[UIColor whiteColor]];
                    backView.layer.cornerRadius = 2;
                    backView.layer.masksToBounds = YES;
                    
                    //品牌
                    UILabel *brandLabel = [[UILabel alloc] init];
                    brandLabel.font = [UIFont systemFontOfSize:15];
                    [brandLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    [brandLabel setBackgroundColor:[UIColor clearColor]];
                    brandLabel.text = [[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FID_CPMC"];
                    CGSize titleSize = [brandLabel.text sizeWithFont:brandLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 15)];
                    
                    brandLabel.frame = CGRectMake(10, 15, titleSize.width, 15);
                    
                    [backView addSubview:brandLabel];
                    
                    
                    if ([[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FID_KHH"] isEqualToString:[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"khh"]]) {
                        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15 + titleSize.width, 15 , 15, 15)];
                        
                        imageView.image = [UIImage imageNamed:@"icon_my"];
                        [backView addSubview:imageView];
                        
                        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(35 + titleSize.width, 15 , 15, 15)];
                        
                        imageView1.image = [UIImage imageNamed:@"icon_buy"];
                        
                        [backView addSubview:imageView1];
                        
                        
                        
                        
                        
                    } else {
                        
                        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15 + titleSize.width, 15 , 15, 15)];
                        
                        imageView.image = [UIImage imageNamed:@"icon_buy"];
                        
                        [backView addSubview:imageView];
                        
                        
                        
                    }
                    
                    
                    
                    //预期年化收益率
                    UILabel *yuqiLabel = [[UILabel alloc] init];
                    yuqiLabel.font = [UIFont systemFontOfSize:28];
                    [yuqiLabel setTextColor:[ColorUtil colorWithHexString:@"fe8103"]];
                    // yuqiLabel.textAlignment = NSTextAlignmentRight;
                    yuqiLabel.text = [[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FID_SYL"];
                    titleSize = [yuqiLabel.text sizeWithFont:yuqiLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 28)];
                    
                    yuqiLabel.frame = CGRectMake(10, 48, titleSize.width, 28);
                    
                    [backView addSubview:yuqiLabel];
                    
                    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10 + titleSize.width, 74 - 13, 15, 13)];
                    lab.text = @"%";
                    lab.textColor = [ColorUtil colorWithHexString:@"fe8103"];
                    lab.font = [UIFont systemFontOfSize:13];
                    [backView addSubview:lab];
                    
                    
                    
                    
                    // 剩余时间
                    
                    UILabel *syLabel = [[UILabel alloc] initWithFrame:CGRectMake( ScreenWidth/4 + 30, 42, 60, 17)];
                    syLabel.font = [UIFont systemFontOfSize:13];
                    [syLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    // syLabel.textAlignment = NSTextAlignmentRight;
                    syLabel.text = [NSString stringWithFormat:@"%@天",[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FID_SYTS"]];
                    [backView addSubview:syLabel];
                    
                    
                    
                    UILabel *yuqiLabelTip = [[UILabel alloc] initWithFrame:CGRectMake( ScreenWidth/4 + 70, 43, 50, 13)];
                    yuqiLabelTip.textAlignment = NSTextAlignmentRight;
                    yuqiLabelTip.font = [UIFont systemFontOfSize:13];
                    [yuqiLabelTip setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                    
                    yuqiLabelTip.text = @"转让价格";
                    // [backView addSubview:yuqiLabelTip];
                    
                    //项目价值
                    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake( ScreenWidth/4 + 30, 63, 30, 13)];
                    valueLabel.font = [UIFont systemFontOfSize:13];
                    [valueLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                    // valueLabel.textAlignment = NSTextAlignmentRight;
                    if ([[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FID_CJ"] hasPrefix:@"-"]) {
                        valueLabel.text = @"加价";
                    } else {
                        
                        valueLabel.text = @"让利";
                    }
                    
                    [backView addSubview:valueLabel];
                    
                    
                    UILabel *valueLabelTip = [[UILabel alloc] init];
                    valueLabelTip.font = [UIFont boldSystemFontOfSize:13];
                    [valueLabelTip setTextColor:[ColorUtil colorWithHexString:@"fe8103"]];
                    valueLabelTip.textAlignment = NSTextAlignmentLeft;
                    if (![[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FID_CJ"] hasPrefix:@"-"]) {
                        
                        
                        valueLabelTip.text = [[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FID_CJ"];
                    } else {
                        
                        valueLabelTip.text = [NSString stringWithFormat:@"%.2f",0 -[[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FID_CJ"] floatValue]];
                        
                    }
                    // 1.获取宽度，获取字符串不折行单行显示时所需要的长度
                    
                    titleSize = [valueLabelTip.text sizeWithFont:valueLabelTip.font constrainedToSize:CGSizeMake(MAXFLOAT, 13)];
                    valueLabelTip.frame = CGRectMake( ScreenWidth/4 + 60, 63, titleSize.width, 13);
                    // WithFrame:CGRectMake(170, 44, 60, 13)
                    
                    [backView addSubview:valueLabelTip];
                    
                    
                    UILabel *flagLabel = [[UILabel alloc] initWithFrame:CGRectMake(valueLabelTip.frame.size.width + valueLabelTip.frame.origin.x, 63, 120, 13)];
                    flagLabel.font = [UIFont systemFontOfSize:13];
                    [flagLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    flagLabel.textAlignment = NSTextAlignmentLeft;
                    flagLabel.text = [NSString stringWithFormat:@"元(约%@天利息)",[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FID_LXTS"]];
                    [backView addSubview:flagLabel];
                    
                    
                    //转让价格
                    UILabel *giveLabel = [[UILabel alloc] initWithFrame:CGRectMake( ScreenWidth/2- 10, 43, 60, 13)];
                    giveLabel.font = [UIFont systemFontOfSize:13];
                    [giveLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                    giveLabel.textAlignment = NSTextAlignmentRight;
                    giveLabel.text = @"转让价格";
                    [backView addSubview:giveLabel];
                    
                    UILabel *giveLabelTip = [[UILabel alloc] init];
                    giveLabelTip.font = [UIFont systemFontOfSize:13];
                    [giveLabelTip setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    giveLabelTip.textAlignment = NSTextAlignmentLeft;
                    giveLabelTip.text = [NSString stringWithFormat:@"%.2f",[[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FID_WTJE"] floatValue]];
                    // [backView addSubview:giveLabelTip];
                    
                    
                    CGSize titleSize1 = [giveLabelTip.text sizeWithFont:giveLabelTip.font constrainedToSize:CGSizeMake(MAXFLOAT, 13)];
                    giveLabelTip.frame = CGRectMake(ScreenWidth/2 + 50, 43, titleSize1.width, 13);
                    // WithFrame:CGRectMake(170, 67, 60, 13)
                    
                    [backView addSubview:giveLabelTip];
                    
                    
                    UILabel *flagLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(giveLabelTip.frame.size.width + giveLabelTip.frame.origin.x, 43, 60, 13)];
                    flagLabel1.font = [UIFont systemFontOfSize:13];
                    [flagLabel1 setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    flagLabel1.textAlignment = NSTextAlignmentLeft;
                    flagLabel1.text = @"元";
                    [backView addSubview:flagLabel1];
                    
                    [cell.contentView addSubview:backView];
                }
            }
            // return cell;
        }
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == table) {
        if ([indexPath row] == [dataList count]) {
            return 50;
        } else {
            return 105;
        }
        
    } else if (tableView == tablePast){
        if ([indexPath row] == [dataListPast count]) {
            return 50;
        } else {
            return 105;
        }
    }
    
    return 95;
}



- (void)tableView:(UITableView *)tbleView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tbleView == table) {
        
        if (indexPath.row == [dataList count]) {
            for (UILabel *label in [moreCell.contentView subviews]) {
                if ([label.text isEqualToString:@"正在加载中..."]) {
                    
                } else {
                    label.text = @"正在加载中...";
                    [self requestList:start limit:limit sortName:sortName val:sortVal tag:kBusinessTagGetJRwdtzloadData];
                    [tbleView deselectRowAtIndexPath:indexPath animated:YES];
                }
            }
        } else {
            
            DetailViewController *cv = [[DetailViewController alloc] init];
            
            if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"flag"] isEqualToString:@"1"]||[[[dataList objectAtIndex:indexPath.row] objectForKey:@"cz" ] isEqualToString:@"1"]|| [[[dataList objectAtIndex:indexPath.row] objectForKey:@"JYZT" ] isEqualToString:@"0"] ) {
                cv.flagbtn = YES;
            }else {
                cv.flagbtn = NO;
                
            }
            
            
            cv.title = [[dataList objectAtIndex:indexPath.row] objectForKey:@"cpmc"];
            cv.strGqdm = [[dataList objectAtIndex:indexPath.row] objectForKey:@"gqdm"];
            cv.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cv animated:YES];
            
        }
    }else if (tbleView == tablePast){
        if (indexPath.row == [dataListPast count]) {
            for (UILabel *label in [moreCellPast.contentView subviews]) {
                if ([label.text isEqualToString:@"正在加载中..."]) {
                    
                } else {
                    label.text = @"正在加载中...";
                    [self requestTransferList:startPast limit:limitPast sortName:sortNamePast val:sortValPast tag:kBusinessTagGetJRcpzrwytz1];
                    [tbleView deselectRowAtIndexPath:indexPath animated:YES];
                }
            }
        } else {
            
            // [self btnActionForUserSetting:self];
            
            TransferDetailsViewController *cv = [[TransferDetailsViewController alloc] init];
            cv.wth = [[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FID_WTH"];
            cv.gqdm = [[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FID_GQDM"];
            if ([[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FID_KHH"] isEqualToString:[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"khh"]]) {
                cv.flag = YES;
            } else {
                
                cv.flag = NO;
                
            }
            
            
            
            cv.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cv animated:YES];
            
            
            
        }
    }
}


#pragma mark - Recived Methods
//刷新的时候
- (void)recivedPastList:(NSMutableArray *)dataArray
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"处理品牌列表数据");
    if ([dataListPast count] > 0) {
        for (NSDictionary *object in dataArray) {
            [dataListPast addObject:object];
        }
    } else {
        dataListPast = dataArray;
    }
    if ([dataArray count] < 10) {
        hasMorePast = NO;
    } else {
        hasMorePast = YES;
        startPast = [NSString stringWithFormat:@"%d", [startPast intValue] + 1];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [tablePast reloadData];
    [_slimeViewPast endRefresh];
}



#pragma mark - Recived Methods
//刷新的时候
- (void)recivedEndRefreshList:(NSMutableArray *)dataArray
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"处理品牌列表数据");
    if ([dataList count] > 0) {
        for (NSDictionary *object in dataArray) {
            [dataList addObject:object];
        }
    } else {
        dataList = dataArray;
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [table reloadData];
    //[_slimeView endRefresh];
    // hasMore = YES;
}



//处理品牌列表
- (void)recivedCategoryList:(NSMutableArray *)dataArray
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"处理品牌列表数据");
    if ([dataList count] > 0) {
        for (NSDictionary *object in dataArray) {
            [dataList addObject:object];
        }
    } else {
        dataList = dataArray;
    }
    if ([dataArray count] < 10) {
        hasMore = NO;
    } else {
        hasMore = YES;
        start = [NSString stringWithFormat:@"%d", [start intValue] + 1];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [table reloadData];
    [_slimeView endRefresh];
}

- (void)recivedTableList:(NSMutableArray *)dataArray business:(kBusinessTag)tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"处理品牌列表数据");
    
}




- (void)requestUpdateLinkMan
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求修改联系人");
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:@"ios" forKey:@"client"];
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRcarouselImgUrl owner:self];
    
}

- (void)recivedCategoryListFirst:(NSMutableArray *)dataArray
{
    dataListFirst = dataArray;
    
    for (int i = 0; i < 3; i++) {
        UIView *dayview;
        UILabel *numYQH;
        UILabel *lab;
        UILabel *nameLab;
        if (i == 1) {
            dayview = [[UIView alloc] initWithFrame:CGRectMake(10, 160, ScreenWidth/2 - 15, 90)];
            dayview.backgroundColor = [UIColor whiteColor];
            
            dayview.layer.cornerRadius = 2;
            dayview.layer.masksToBounds = YES;
            dayview.layer.borderWidth = 1;
            dayview.layer.borderColor = [ColorUtil colorWithHexString:@"e5e5e5"].CGColor;
            
            dayview.tag = 1;
            numYQH = [[UILabel alloc] init];
            lab = [[UILabel alloc] init];
            //续存期
            nameLab = [[UILabel alloc] initWithFrame:CGRectMake(55, 12, ScreenWidth/2 - 80, 12)];
            
            UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 15 - 50, 59 - 12, 40, 12)];
            dateLabel.text = [NSString stringWithFormat:@"%@天",[[dataListFirst objectAtIndex:i] objectForKey:@"ZRRQ"]];
            dateLabel.font = [UIFont systemFontOfSize:12];
            dateLabel.textColor = [ColorUtil colorWithHexString:@"666666"];
             dateLabel.textAlignment = NSTextAlignmentRight;
            [dayview addSubview:dateLabel];
            
            UILabel *tipdate = [[UILabel alloc] initWithFrame:CGRectMake( 10, 68, ScreenWidth/2 - 25, 12)];
            tipdate.text = [[dataListFirst objectAtIndex:i] objectForKey:@"FXMS"];
            tipdate.font = [UIFont systemFontOfSize:12];
            tipdate.textColor = [ColorUtil colorWithHexString:@"666666"];
            // moneyLabel.textAlignment = NSTextAlignmentCenter;
            [dayview addSubview:tipdate];
            
            //加边框
            UIView *viewBack1 = [[UIView alloc] initWithFrame:CGRectMake(0,dayview.frame.size.height - 0.5, ScreenWidth/2 - 1, 0.5)];
            viewBack1.backgroundColor = [ColorUtil colorWithHexString:@"dedede"];
            [dayview addSubview:viewBack1];
            
        } else if (i == 2) {
            dayview = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2 + 5, 160, ScreenWidth/2 -15, 90)];
            dayview.backgroundColor = [UIColor whiteColor];
            
            dayview.layer.cornerRadius = 2;
            dayview.layer.masksToBounds = YES;
            dayview.layer.borderWidth = 1;
            dayview.layer.borderColor = [ColorUtil colorWithHexString:@"e5e5e5"].CGColor;
            dayview.tag = 2;
            numYQH = [[UILabel alloc] init];
            lab = [[UILabel alloc] init];
            nameLab = [[UILabel alloc] initWithFrame:CGRectMake(55, 12, ScreenWidth/2 - 80, 12)];
            //续存期
            
            UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 15 - 50, 59 - 12, 40, 12)];
            dateLabel.text = [NSString stringWithFormat:@"%@天",[[dataListFirst objectAtIndex:i] objectForKey:@"ZRRQ"]];
            dateLabel.font = [UIFont systemFontOfSize:12];
            dateLabel.textColor = [ColorUtil colorWithHexString:@"666666"];
             dateLabel.textAlignment = NSTextAlignmentRight;
            [dayview addSubview:dateLabel];
            
            UILabel *tipdate = [[UILabel alloc] initWithFrame:CGRectMake( 10, 68, ScreenWidth/2 - 25, 12)];
            tipdate.text = [[dataListFirst objectAtIndex:i] objectForKey:@"FXMS"];
            tipdate.font = [UIFont systemFontOfSize:12];
            tipdate.textColor = [ColorUtil colorWithHexString:@"666666"];
            // moneyLabel.textAlignment = NSTextAlignmentCenter;
            [dayview addSubview:tipdate];
            
            
            //加边框
            UIView *viewBack1 = [[UIView alloc] initWithFrame:CGRectMake(0, dayview.frame.size.height - 0.5, ScreenWidth/2, 0.5)];
            viewBack1.backgroundColor = [ColorUtil colorWithHexString:@"dedede"];
            [dayview addSubview:viewBack1];
            
            
            
            
        } else if (i == 0) {
            dayview =  [[UIView alloc] initWithFrame:CGRectMake(10, 10 +  90 + 160, ScreenWidth - 20, 80)];
            dayview.backgroundColor = [UIColor whiteColor];
            
            dayview.layer.cornerRadius = 2;
            dayview.layer.masksToBounds = YES;
            dayview.layer.borderWidth = 1;
            dayview.layer.borderColor = [ColorUtil colorWithHexString:@"e5e5e5"].CGColor;
            
            dayview.tag = i;
            numYQH = [[UILabel alloc] init];
            lab = [[UILabel alloc] init];
            
            nameLab = [[UILabel alloc] initWithFrame:CGRectMake(55, 12, ScreenWidth - 65, 12)];
            
            UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake( 95, 34, 40, 12)];
            dateLabel.text = [NSString stringWithFormat:@"%@天",[[dataListFirst objectAtIndex:i] objectForKey:@"ZRRQ"]];
            dateLabel.font = [UIFont systemFontOfSize:12];
            dateLabel.textColor = [ColorUtil colorWithHexString:@"666666"];
            // dateLabel.textAlignment = NSTextAlignmentCenter;
            [dayview addSubview:dateLabel];
            
            UILabel *tipdate = [[UILabel alloc] initWithFrame:CGRectMake( 135, 34, 110, 12)];
            tipdate.text = [[dataListFirst objectAtIndex:i] objectForKey:@"FXMS"];
            tipdate.font = [UIFont systemFontOfSize:12];
            tipdate.textColor = [ColorUtil colorWithHexString:@"666666"];
            // moneyLabel.textAlignment = NSTextAlignmentCenter;
            [dayview addSubview:tipdate];
            
            //赠送
            UILabel *giveLabel = [[UILabel alloc] initWithFrame:CGRectMake( 95, 51, ScreenWidth - 120, 13)];
            giveLabel.text = @"赠1万体验金   享7天收益";
            giveLabel.font = [UIFont systemFontOfSize:13];
            giveLabel.textColor = [ColorUtil colorWithHexString:@"666666"];
            // dateLabel.textAlignment = NSTextAlignmentCenter;
            [dayview addSubview:giveLabel];
            
            
            
            
            
            
            CGRect frame = CGRectMake(ScreenWidth - 70, 80 - 54, 44, 44);
            MDRadialProgressTheme *newTheme12 = [[MDRadialProgressTheme alloc] init];
            newTheme12.centerColor = [UIColor clearColor];
            newTheme12.sliceDividerHidden = NO;
            newTheme12.labelColor = [UIColor blackColor];
            newTheme12.labelShadowColor = [UIColor whiteColor];
            
            
            MDRadialProgressView *radialView = [[MDRadialProgressView alloc] initWithFrame:frame andTheme:newTheme12];
            radialView.progressTotal = 100;
            radialView.startingSlice = 75;
            radialView.theme.thickness = 10;
            radialView.theme.sliceDividerHidden = YES;
            
            int kt;
            if ([[[dataListFirst objectAtIndex:i] objectForKey:@"flag"] boolValue]) {
                kt = [[[dataListFirst objectAtIndex:i] objectForKey:@"TZJD"] intValue];
                
            } else {
                kt = 100;
            }
            radialView.progressCounter = kt;
            
            radialView.theme.sliceDividerHidden = YES;
            radialView.theme.incompletedColor = [ColorUtil colorWithHexString:@"eeeeee"];
            
            if (kt == 0) {
                radialView.theme.completedColor = [ColorUtil colorWithHexString:@"eeeeee"];
            } else{
                radialView.theme.completedColor = [ColorUtil colorWithHexString:@"c62b2f"];
            }
            [dayview addSubview:radialView];
            
            
            
        }
        UILabel *labF1 = [[UILabel  alloc] initWithFrame:CGRectMake(10, 9, 15, 15)];
        labF1.font = [UIFont boldSystemFontOfSize:15];
        labF1.text = @"稀";
        labF1.textColor = [ColorUtil colorWithHexString:@"ec3908"];
        [dayview addSubview:labF1];
        
        UILabel *labF2 = [[UILabel  alloc] initWithFrame:CGRectMake(25, 12, 30, 12)];
        labF2.font = [UIFont boldSystemFontOfSize:12];
        labF2.text = @"金保-";
        labF2.textColor = [UIColor blackColor];
        [dayview addSubview:labF2];
        
        
        // NSString *string = [[[dataList objectAtIndex:1] objectForKey:@"GQMC"] substringFromIndex:5];//截取下标7之后的字符串
        // NSString *string = [[dataList objectAtIndex:1] objectForKey:@"GQMC"];
        //名称
        NSString *b;
        if ([[[dataListFirst objectAtIndex:i] objectForKey:@"GQMC"] length] >5 ) {
            b = [[[dataListFirst objectAtIndex:i] objectForKey:@"GQMC"] substringFromIndex:5];
        } else {
            
            b = [[dataListFirst objectAtIndex:i] objectForKey:@"GQMC"];
        }
        
        
        nameLab.text = b;
        nameLab.font = [UIFont systemFontOfSize:12];
        nameLab.textColor = [ColorUtil colorWithHexString:@"333333"];
        [dayview addSubview:nameLab];
        
        
        // numYQH = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 65, 25)];
        numYQH.text = [[dataArray objectAtIndex:i] objectForKey:@"SYL"];
        numYQH.font = [UIFont systemFontOfSize:25];
        numYQH.textColor = [ColorUtil colorWithHexString:@"fe8103"];
        CGSize titleSize = [numYQH.text sizeWithFont:numYQH.font constrainedToSize:CGSizeMake(MAXFLOAT, 25)];
        if (i == 0) {
            numYQH.frame = CGRectMake(10, 9 + 10 + 15, titleSize.width, 25);
            lab.frame = CGRectMake(10 + titleSize.width, 59 - 12, 15, 12);
        } else {
            numYQH.frame = CGRectMake(10, 10 + 9 + 18, titleSize.width, 25);
            lab.frame = CGRectMake(10 + titleSize.width, 62 - 12, 15, 12);
        }
        [dayview addSubview:numYQH];
        
        
        lab.text = @"%";
        lab.textColor = [ColorUtil colorWithHexString:@"fe8103"];
        lab.font = [UIFont systemFontOfSize:12];
        [dayview addSubview:lab];
        
        
        
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
        
        singleTap.numberOfTouchesRequired = 1;
        //点击几次，如果是1就是单击
        singleTap.numberOfTapsRequired = 1;
        [dayview addGestureRecognizer:singleTap];
        
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 10 - 85,10 +  90 + 160 -6, 75 , 25)];
        img.image = [UIImage imageNamed:@"首页03_03"];
        [backScrollView addSubview:img];
        
        [backScrollView addSubview:dayview];
        
        
    }
    
    
    //日金宝
    //名称
    // nameLab.text = [[dataArray objectAtIndex:1] objectForKey:@"GQMC"];
    
    //百分比
    
    //yearLab.text = [[dataArray objectAtIndex:1] objectForKey:@"SYWZ"];
    
    
    // 洗金宝
    //名称
    
    //nameyueLab.text = [[dataArray objectAtIndex:2] objectForKey:@"GQMC"];
    
    
    //百分比
    // yueLab.text = [[dataArray objectAtIndex:2] objectForKey:@"SYWZ"];
    
    
    //名称
    
    // newLab.text = [[dataArray objectAtIndex:0] objectForKey:@"GQMC"];
    
    //百分比
    
    //newlab.text = [[dataArray objectAtIndex:0] objectForKey:@"SYWZ"];
    
    
}


- (IBAction)callPhone:(UITouch *)sender
{
    UIView *view = [sender view];
    
    if (view.tag == 3) {
        RegesterViewController *cv = [[RegesterViewController alloc] init];
        [self.navigationController pushViewController:cv animated:YES];
    } else if (view.tag == 4) {
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (delegate.logingUser.count > 0) {
            if ([[delegate.logingUser objectForKey:@"success"] boolValue] == YES) {
                MessgeCenterViewController *cv = [[MessgeCenterViewController alloc] init];
                [self.navigationController pushViewController:cv animated:YES];

            } else {
                // delegate.strlogin = @"2";
                LoginViewController *VC = [[LoginViewController alloc] init];
               // VC.modalTransitionStyle = UIModalTransitionStyle;
                
               [self.navigationController pushViewController:VC animated:YES];

             // [self.view makeToast:@"您还没登录，请先登录" duration:1 position:@"center"];
                
            }
            
        } else {
            // delegate.strlogin = @"2";
            LoginViewController *VC = [[LoginViewController alloc] init];
            
           // VC.modalTransitionStyle = UIModalTransitionStyle;
            
          [self.navigationController pushViewController:VC animated:YES];
           // [self.view makeToast:@"您还没登录，请先登录" duration:1 position:@"center"];
            
        }
        
    } else if (view.tag == 5) {
        UserBackViewController *cv = [[UserBackViewController alloc] init];
        [self.navigationController pushViewController:cv animated:YES];
    } else if (view.tag == 6) {
        MyUserMangerViewController *cv = [[MyUserMangerViewController alloc] init];
       // cv.modalTransitionStyle = UIModalTransitionStyle;
        
       // [self presentViewController:cv animated:YES completion:nil];
       [self.navigationController pushViewController:cv animated:YES];
        
    } else {
        
        DetailViewController *cv = [[DetailViewController alloc] init];
        
        
        cv.flagStr = [[dataListFirst objectAtIndex:view.tag] objectForKey:@"flag"];
        
        cv.title = [[dataListFirst objectAtIndex:view.tag] objectForKey:@"GQMC"];
        cv.strGqdm = [[dataListFirst objectAtIndex:view.tag] objectForKey:@"GQDM"];
       // cv.hidesBottomBarWhenPushed = YES;
      //  [menuController pushViewController:cv animated:YES];
        
       // cv.modalTransitionStyle = UIModalTransitionStyle;
       
       // [self presentViewController:cv animated:YES completion:nil];
        [self.navigationController pushViewController:cv animated:YES]; 
        
        
    }
    
}

#pragma mark - Recived Methods
//处理修改联系人
- (void)recivedUpdateLinkMan:(NSMutableArray *)dataArray
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"修改联系人");
    
    if ([imageArray count] > 0) {
        [imageArray removeAllObjects];
        for (NSDictionary *object in dataArray) {
            [imageArray addObject:object];
        }
    } else {
        imageArray = dataArray;
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //保存数组的个数
    
    NSNumber *num = [NSNumber numberWithInteger:imageArray.count];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:num forKey:@"arrCount"];
    [userDefault synchronize];
    
    
    //imageArray = @[imageStr1,imageStr2,imageStr3,imageStr4,imageStr5];
    CGRect bound=CGRectMake(0, 0, ScreenWidth, 150);
    
    scrollViewImage = [[UIScrollView alloc] initWithFrame:bound];
    
    //scrollView.bounces = YES;
    scrollViewImage.pagingEnabled = YES;
    scrollViewImage.delegate = self;
    scrollViewImage.userInteractionEnabled = YES;
    //隐藏水平滑动条
    scrollViewImage.showsVerticalScrollIndicator = FALSE;
    scrollViewImage.showsHorizontalScrollIndicator = FALSE;
    [scrollViewImage flashScrollIndicators];
    [backScrollView addSubview:scrollViewImage];
    
    // 初始化 pagecontrol
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(ScreenWidth - 90,150 - 20,80,10)]; // 初始化mypagecontrol
    [pageControl setCurrentPageIndicatorTintColor:[ColorUtil colorWithHexString:@"e3a325"]];
    [pageControl setPageIndicatorTintColor:[UIColor whiteColor]];
    pageControl.numberOfPages = [imageArray count];
    pageControl.currentPage = 0;
    [pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged]; // 触摸mypagecontrol触发change这个方法事件
    [backScrollView addSubview:pageControl];
    for (int i = 0; i < imageArray.count; i++) {
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth * i) + ScreenWidth, 0, ScreenWidth, 150)];
        [imageView1 setTag:i + 10000];
        [imageView1 setImageWithURL:[imageArray objectAtIndex:i]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                            success:^(UIImage *image) {
                                
                                [[SDImageCache sharedImageCache] storeImage:image forKey:[NSString stringWithFormat:@"myCacheKey%d",i]];
                                
                            }
         
                            failure:^(NSError *error) {
                                
                                UIImageView *icon = (UIImageView *)[(UIImageView *)self.view viewWithTag:i + 10000];
                                icon.image = [UIImage imageNamed:@"xd1"];
                                
                            }];
        
        [scrollViewImage addSubview:imageView1];
        
        
    }
    
    
    // 取数组最后一张图片 放在第0页
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    imgView.tag = 4 + 10000;
    [imgView setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:imageArray.count - 1]]
            placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                     success:^(UIImage *image) {
                         
                     }
     
                     failure:^(NSError *error) {
                         
                         UIImageView *icon = (UIImageView *)[(UIImageView *)self.view viewWithTag:4 + 10000];
                         icon.image = [UIImage imageNamed:@"xd1"];
                         
                         
                     }];
    
    [scrollViewImage addSubview:imgView];
    
    // 取数组第一张图片 放在最后1页
    
    UIImageView *imgViewl = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth * ([imageArray count] + 1)) , 0, ScreenWidth, 150)];
    imgViewl.tag = 5 + 10000;
    [imgViewl setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:0]]
             placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                      success:^(UIImage *image) {
                          
                      }
     
                      failure:^(NSError *error) {
                          
                          UIImageView *icon = (UIImageView *)[(UIImageView *)self.view viewWithTag:5 + 10000];
                          icon.image = [UIImage imageNamed:@"xd1"];
                          
                      }];
    
    // 添加第1页在最后 循环
    [scrollViewImage addSubview:imgViewl];
    
    [scrollViewImage setContentSize:CGSizeMake(ScreenWidth * ([imageArray count] + 2), 150)]; //  +上第1页和第4页  原理：4-[1-2-3-4]-1
    [scrollViewImage setContentOffset:CGPointMake(0, 0)];
    [scrollViewImage scrollRectToVisible:CGRectMake(ScreenWidth,0,ScreenWidth,150) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页
    
    
}


#pragma mark - Request Methods
//请求登陆
- (void)requestLogin:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    //[paraDic setObject:_userN forKey:@"username"];
    
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
}

#pragma mark - NetworkModuleDelegate Methods
-(void)beginPost:(kBusinessTag)tag{
    
}
-(void)endPost:(NSString *)result business:(kBusinessTag)tag{
    NSLog(@"%s %d 收到数据:%@", __FUNCTION__, __LINE__, result);
    NSMutableDictionary *jsonDic = [result JSONValue];
    
    if ([[jsonDic objectForKey:@"object"] isKindOfClass:[NSString class]]) {
        
        if ([[jsonDic objectForKey:@"object"] isEqualToString:@"loginTimeout"]) {
            
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.logingUser removeAllObjects];
            [delegate.dictionary removeAllObjects];
            [ASIHTTPRequest setSessionCookies:nil];
            // LogOutViewController *cv = [[LogOutViewController alloc] init];
            // cv.hidesBottomBarWhenPushed = YES;
            //[self.navigationController pushViewController:cv animated:YES];
        }
    }else {
        
        
       
        if (tag== kBusinessTagGetJRhotproject) {
             NSMutableArray *dataArray = [jsonDic objectForKey:@"object"];
            
            if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
                //数据异常处理
                //[MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.view makeToast:[jsonDic objectForKey:@"msg"] duration:2.0 position:@"center"];
                //            subing = NO;
            } else {
                // [MBProgressHUD hideHUDForView:self.view animated:YES];
                //[self.view makeToast:@"登录成功!"];
                flagHub = @"1";
                [self recivedCategoryListFirst:dataArray];
                
            }
        }else if (tag==kBusinessTagGetJRcarouselImgUrl ) {
             NSMutableArray *dataArray = [jsonDic objectForKey:@"object"];
            if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
                //数据异常处理
                // [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.view makeToast:@"下载图片失败"];
                //            subing = NO;
            } else {
                [self recivedUpdateLinkMan:dataArray];
            }
        } else if (tag==kBusinessTagGetJRloadData ) {
            NSMutableDictionary *dataArr = [jsonDic objectForKey:@"object"];
            if ([[jsonDic objectForKey:@"success"] boolValue] == 0) {
                
                //数据异常处理
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                //[self.view makeToast:@"获取品牌失败"];
            } else {
                //[self recivedCategoryList:dataArray];
                
                allGqlb = [dataArr objectForKey:@"allGqlb"];
                
                //添加指示器及遮罩
                
                
                
            }
        }else if (tag == kBusinessTagGetJRwdtzloadDataAgain){
             NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
            [_slimeView endRefresh];
            if ([[jsonDic objectForKey:@"success"] boolValue] == 0) {
                //数据异常处理
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.view makeToast:@"刷新商品失败"];
            } else {
                [dataList removeAllObjects];
                [self recivedCategoryList:[dataArray objectForKey:@"dataList"]];
            }
        } else if (tag == kBusinessTagUserGetEndRefreshList){
             NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
            //[_slimeView endRefresh];
            if ([[jsonDic objectForKey:@"success"] boolValue] == 0) {
                //数据异常处理
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.view makeToast:@"刷新商品失败"];
            } else {
                [dataList removeAllObjects];
                [self recivedEndRefreshList:[dataArray objectForKey:@"dataList"]];
            }
        } else  if (tag==kBusinessTagGetJRwdtzloadData) {
             NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
            if ([[jsonDic objectForKey:@"success"] boolValue] == 0) {
                //数据异常处理
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.view makeToast:@"获取品牌失败"];
            } else {
                [self recivedCategoryList:[dataArray objectForKey:@"dataList"]];
            }
        } else if (tag==kBusinessTagGetJRcpzrwytz1 ) {
             NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
            if ([[jsonDic objectForKey:@"success"] boolValue] == 0) {
                
                //数据异常处理
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                //[self.view makeToast:@"获取品牌失败"];
            } else {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self recivedPastList:[dataArray objectForKey:@"dataList"]];
                
                
            }
        }else if (tag == kBusinessTagGetJRcpzrwytz1Again){
             NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
            [_slimeViewPast endRefresh];
            if ([[jsonDic objectForKey:@"success"] boolValue] == 0) {
                //数据异常处理
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.view makeToast:@"刷新商品失败"];
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [dataListPast removeAllObjects];
                [self recivedPastList:[dataArray objectForKey:@"dataList"]];
            }
        }
    }
    
    
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    // [[NetworkModule sharedNetworkModule] cancel:tag];
}
-(void)errorPost:(NSError *)err business:(kBusinessTag)tag{
    NSLog(@"%s Error:%@", __FUNCTION__, @"连接数据服务器超时");
    
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法连接" message:@"您所在地的网络信号微弱，无法连接到服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //[alert show];
    
    [self.view makeToast:@"您所在地的网络信号微弱，无法连接到服务" duration:1 position:@"center"];
    
    flagHub = @"0";
    if (tag==kBusinessTagGetJRcarouselImgUrl) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (imageArray.count == 0) {
            
            imageArray = [[NSMutableArray alloc] init];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            NSNumber *arr = [userDefault objectForKey:@"arrCount"];
            NSInteger count = [arr integerValue];
            if (count > 0) {
                
                for (int i = 0; i < count; i++) {
                    UIImage *icon = [[SDImageCache sharedImageCache] imageFromKey:[NSString stringWithFormat:@"myCacheKey%d",i]];
                    if (icon == nil) {
                        icon = [UIImage imageNamed:@"xd1"];
                        [imageArray addObject:icon];
                    } else {
                        
                        [imageArray addObject:icon];
                    }
                }
                
                CGRect bound=CGRectMake(0, 0, ScreenWidth, 150);
                
                scrollViewImage = [[UIScrollView alloc] initWithFrame:bound];
                [scrollViewImage setBackgroundColor:[UIColor grayColor]];
                scrollViewImage.bounces = YES;
                scrollViewImage.pagingEnabled = YES;
                scrollViewImage.delegate = self;
                scrollViewImage.userInteractionEnabled = YES;
                scrollViewImage.showsVerticalScrollIndicator = FALSE;
                scrollViewImage.showsHorizontalScrollIndicator = FALSE;
                [backScrollView addSubview:scrollViewImage];
                
                // 初始化 pagecontrol
                //pageControl =  [[UIPageControl alloc]initWithFrame:CGRectMake(ScreenWidth*3/4 ,150 - 20,ScreenWidth/4,10)];
                
                pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(ScreenWidth - 90,150 - 20,80,10)]; // 初始化mypagecontrol
                [pageControl setCurrentPageIndicatorTintColor:[ColorUtil colorWithHexString:@"e3a325"]];
                [pageControl setPageIndicatorTintColor:[UIColor whiteColor]];
                
                
                // 初始化mypagecontrol
                //[pageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];
                //[pageControl setPageIndicatorTintColor:[UIColor blackColor]];
                //[pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
                //[pageControl setPageIndicatorTintColor:[UIColor colorWithWhite:1 alpha:0.38]];
                pageControl.numberOfPages = imageArray.count;
                pageControl.currentPage = 0;
                [pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged]; // 触摸mypagecontrol触发change这个方法事件
                [backScrollView addSubview:pageControl];
                
                
                for (int i = 0; i < imageArray.count; i++) {
                    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth * i) + ScreenWidth, 0, ScreenWidth, 150)];
                    imageView1.image = [imageArray objectAtIndex:i];
                    [scrollViewImage addSubview:imageView1];
                    
                }
                
                
                // 取数组最后一张图片 放在第0页
                
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
                // UIImageView *icon = [slideImages objectAtIndex:slideImages.count -1];
                imgView.image = [imageArray objectAtIndex:imageArray.count -1];
                [scrollViewImage addSubview:imgView];
                
                // 取数组第一张图片 放在最后1页
                
                imgView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth * ([imageArray count] + 1)) , 0, ScreenWidth, 150)];
                
                //icon = [slideImages objectAtIndex:0];
                imgView.image = [imageArray objectAtIndex:0];
                
                // 添加第1页在最后 循环
                [scrollViewImage addSubview:imgView];
                
                [scrollViewImage setContentSize:CGSizeMake(ScreenWidth * ([imageArray count] + 2), 150)]; //  +上第1页和第4页  原理：4-[1-2-3-4]-1
                [scrollViewImage setContentOffset:CGPointMake(0, 0)];
                [scrollViewImage scrollRectToVisible:CGRectMake(ScreenWidth,0,ScreenWidth,150) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页
                
            }
        }
        
    }else if (tag == kBusinessTagUserGetList) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } else if (tag == kBusinessTagUserGetListAgain) {
        start = [NSString stringWithString:startBak];
        [_slimeView endRefresh];
    } else if (tag == kBusinessTagGetStatus) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } else if (tag == kBusinessTagGetIndustry) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }else if (tag == kBusinessTagGetProvince) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } else if (tag == kBusinessTagGetCity) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[NetworkModule sharedNetworkModule] cancel:tag];
}





// scrollview 委托函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollV
{
    
    if (scrollV == _scrollView) {
        CGFloat pageWidth = ScreenWidth;
        NSInteger page = _scrollView.contentOffset.x / pageWidth ;
        
        if (page == 1) {
            
            if (dataList.count > 0) {
                [dataList removeAllObjects];
            }
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.dimBackground = YES;
            hud.delegate = self;
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.labelText = @"加载中...";
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                //[self requestCategoryList:start limit:limit tag:kBusinessTagGetJRwdtzloadData];
                 start = @"1";
                //投资专区
                [self requestList:start limit:limit sortName:sortName val:sortVal tag:kBusinessTagGetJRwdtzloadData];
                
                //转让专区
               // [self requestTransferList:startPast limit:limitPast sortName:sortNamePast val:sortValPast tag:kBusinessTagGetJRcpzrwytz1];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            });
            
            

        } else if (page == 2) {
            
            if (dataListPast.count > 0) {
                [dataListPast removeAllObjects];
            }
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.dimBackground = YES;
            hud.delegate = self;
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.labelText = @"加载中...";
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                //[self requestCategoryList:start limit:limit tag:kBusinessTagGetJRwdtzloadData];
                //投资专区
               // [self requestList:start limit:limit sortName:sortName val:sortVal tag:kBusinessTagGetJRwdtzloadData];
                startPast = @"1";
                //转让专区
                [self requestTransferList:startPast limit:limitPast sortName:sortNamePast val:sortValPast tag:kBusinessTagGetJRcpzrwytz1];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            });
            
            

        
        
        
        }
        
        
        
        
        [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
    } else {
    
    
    CGFloat pagewidth = scrollViewImage.frame.size.width;
    int currentPage = floor((scrollViewImage.contentOffset.x - pagewidth/ ([imageArray count]+2)) / pagewidth) + 1;
    //    int currentPage_ = (int)self.scrollView.contentOffset.x/320; // 和上面两行效果一样
    //    NSLog(@"currentPage_==%d",currentPage_);
    if (currentPage==0)
    {
        [scrollViewImage scrollRectToVisible:CGRectMake(ScreenWidth * [imageArray count],0,ScreenWidth,150) animated:NO]; // 序号0 最后1页
    }
    else if (currentPage==([imageArray count]+1))
    {
        [scrollViewImage scrollRectToVisible:CGRectMake(ScreenWidth,0,ScreenWidth,150) animated:NO]; // 最后+1,循环第1页
    }
  }
}
// pagecontrol 选择器的方法
- (void)turnPage
{
    int page = (int)pageControl.currentPage; // 获取当前的page
    [scrollViewImage scrollRectToVisible:CGRectMake(ScreenWidth*(page+1),0,ScreenWidth,150) animated:NO]; // 触摸pagecontroller那个点点 往后翻一页 +1
}
// 定时器 绑定的方法
- (void)runTimePage
{
    int page = (int)pageControl.currentPage; // 获取当前的page
    page++;
    page = page > (imageArray.count - 1) ? 0 : page ;
    pageControl.currentPage = page;
    [self turnPage];
}




-(void)push {

    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.menuController.delegate = self;
    [delegate.menuController showLeftController:YES];
    /*
    - (void)setRootController:(UIViewController *)controller animated:(BOOL)animated; // used to push a new controller on the stack
    - (void)showRootController:(BOOL)animated; // reset to "home" view controller
    - (void)showRightController:(BOOL)animated;  // show right
    - (void)showLeftController:(BOOL)animated;
    */
    
    
}


- (void)menuController:(DDMenuController*)controller willShowViewController:(UIViewController*)controller{


    NSLog(@"123");
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

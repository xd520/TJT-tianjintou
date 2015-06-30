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
}
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, 320,500)];
    [table setDelegate:self];
    [table setDataSource:self];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
   // [table setBackgroundColor:[ColorUtil colorWithHexString:@"eeeeee"]];
    table.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:table];
 
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
   
    
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"Home";
            break;
            
        case 1:
            cell.textLabel.text = @"Profile";
            break;
            
       
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

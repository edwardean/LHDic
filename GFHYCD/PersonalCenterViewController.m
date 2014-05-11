//
//  PersonalCenterViewController.m
//  GFHYCD
//
//  Created by Ibokan on 13-9-23.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "CollectionViewController.h"
#import "BoutiqueAppViewController.h"
#import "AppGradeViewController.h"
#import "AboutViewController.h"
#import "CustomBrowserController.h"
#import "SharedViewController.h"
#import "DBManager.h"

@interface PersonalCenterViewController ()

@end

@implementation PersonalCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.showNavRightButton = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initSubView];
}
#pragma mark - 初始化子视图
- (void) initSubView
{
    _myDataArray = [NSArray arrayWithObjects:@"我的收藏",@"分享",@"意见反馈",@"在线词典",@"应用打分",@"关于我们", nil];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 20 -44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _myDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentify = @"cellIndentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *dividingView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-272)/2, 44, 272, 1)];
        dividingView.backgroundColor = [UIColor clearColor];
        dividingView.image = [UIImage imageNamed:@"dividing-line.png"];
        [cell.contentView addSubview:dividingView];
        
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, dividingView.top - 25 - 2, 200, 25)];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor blackColor];
        textLabel.font = [UIFont systemFontOfSize:25.0f];
        textLabel.tag = 100;
        [cell.contentView addSubview:textLabel];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 25 - 25, dividingView.top - 26 - 5, 25, 26)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = [UIImage imageNamed:@"continue.png"];
        [cell.contentView addSubview:imageView];
    }
    UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:100];
    textLabel.text = [_myDataArray objectAtIndex:indexPath.row];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        CollectionViewController *collectionCtr = [[CollectionViewController alloc]init];
        collectionCtr.title = @"我的收藏";
        [self.navigationController pushViewController:collectionCtr animated:YES];
    } else if (indexPath.row == 1) {
        SharedViewController *sharedStr = [[SharedViewController alloc]init];
        sharedStr.title = @"分享";
        [self.navigationController pushViewController:sharedStr animated:YES];

    } else if (indexPath.row == 2) {
        
        [[UIApplication sharedApplication]openURL:[NSURL   URLWithString:@"mailto://499785258@qq.com"]];
        
    } else if (indexPath.row == 3) {
//        BoutiqueAppViewController *boutiqueAppController = [[BoutiqueAppViewController alloc] initWithNibName:nil bundle:nil];
//        [self.navigationController pushViewController:boutiqueAppController animated:YES];
        
        CustomBrowserController *browserController = [[CustomBrowserController alloc] initWithNibName:nil bundle:nil];
        browserController.request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://fanyi.baidu.com/#auto/zh/"]];
        [self.navigationController pushViewController:browserController animated:YES];
    } else if (indexPath.row == 4) {
        AppGradeViewController *appGradeController = [[AppGradeViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:appGradeController animated:YES];
    } else if (indexPath.row == 5) {
//        AboutViewController *aboutController = [[AboutViewController alloc] initWithNibName:nil bundle:nil];
//        [self.navigationController pushViewController:aboutController animated:YES];
        CustomBrowserController *browserController = [[CustomBrowserController alloc] initWithNibName:nil bundle:nil];
        browserController.request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.nyist.net"]];
        [self.navigationController pushViewController:browserController animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

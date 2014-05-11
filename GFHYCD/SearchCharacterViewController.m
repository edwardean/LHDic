//
//  SearchCharacterViewController.m
//  GFHYCD
//
//  Created by Ibokan on 13-9-23.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import "SearchCharacterViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface SearchCharacterViewController ()

@end

@implementation SearchCharacterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isPinYin = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initSubView];
    [self initQuickSearchSubView];
}
#pragma mark - 初始化子视图
- (void) initSubView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 20 - 44) style:UITableViewStylePlain];
    UIImage *backImage = [UIImage imageNamed:@"beijing.png"];
    UIImageView *backGroundView = [[UIImageView alloc]initWithImage:backImage];
    _tableView.backgroundView = backGroundView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UILabel *label =  [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth-70)/2, (kScreenHeight - 20 - 44-70)/2, 70, 70)];
    self.displaySelectedLabel = label;
    label.backgroundColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:32.0f];
    label.alpha = 0.0f;
    label.layer.cornerRadius = 4;
    label.layer.masksToBounds = YES;
    [self.view addSubview:label];
    
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth- 27 - 3, (kScreenHeight - 20 - 44-389)/2, 27, 389)];
    myView.backgroundColor = [UIColor clearColor];
    self.quickSearchView = myView;
    [self.view addSubview:myView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:myView.bounds];
    imageView.userInteractionEnabled = YES;//开启用户交互事件
    imageView.image = [UIImage imageNamed:@"Key-frame3.png"];
    [myView addSubview:imageView];
    
    self.myTitleSectionAry = [NSMutableArray arrayWithObjects:@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",nil];
}
#pragma mark -初始化快速搜索view上面的子视图
- (void) initQuickSearchSubView
{
    int titleSectionNum = _titleSectionAry.count;
    float height = 389/titleSectionNum;
    for (int i = 0; i < titleSectionNum; i++) {
        NSString *ziMu = [self.titleSectionAry objectAtIndex:i];
        UIButton *btnZiMu = [UIButton buttonWithType:UIButtonTypeCustom];
        btnZiMu.tag = i;
        [btnZiMu addTarget:self action:@selector(quickSearchAction:) forControlEvents:UIControlEventTouchDown];
        btnZiMu.backgroundColor = [UIColor clearColor];
        [btnZiMu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnZiMu setTitle:ziMu forState:UIControlStateNormal];
        btnZiMu.titleLabel.textAlignment = NSTextAlignmentCenter;
        btnZiMu.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        btnZiMu.frame = CGRectMake(0, height*i+27/2-2, 27,height);
        [self.quickSearchView addSubview:btnZiMu];
    }
}

#pragma mark - 让displaySelectedLabel的alpha值从0渐变到1 然后在从1到0 先显示然后再隐藏
- (void) AppearDisplaySelectedLabel
{
    _displaySelectedLabel.alpha = 1.0f;
    [UIView animateWithDuration:1.35 animations:^{
        _displaySelectedLabel.alpha = 0.0f;
    }];
}

#pragma mark - UITableViewDataSource 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titleSectionAry.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_dataArray objectAtIndex:section] count];
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pinyin.png"]];
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 200, 40)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = [UIFont systemFontOfSize:23.0f];
    textLabel.textColor = [UIColor blackColor];
    NSString *titleSecStr = [_titleSectionAry objectAtIndex:section];
    if (!_isPinYin) {
        NSString *title = [_myTitleSectionAry objectAtIndex:section];
        titleSecStr = [NSString stringWithFormat:@"笔画%@",title];
    }
    textLabel.text = titleSecStr;
    [headerView addSubview:textLabel];
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentify = @"cellIndentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify];
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 200, 40)];
        textLabel.tag = 100;
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.font = [UIFont systemFontOfSize:21.0f];
        textLabel.textColor = [UIColor blackColor];
        [cell.contentView addSubview:textLabel];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    NSArray *array = [_dataArray objectAtIndex:indexPath.section];
    UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:100];
    textLabel.text = [array objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - 根据传入的参数 让tableView重新定位 section是你点击的是哪个部分
- (void) jumpToDestination:(int)section
{
    float totalOffSet = section*40;//所有headerView的高度
    for (int j = 0; j < section; j++) {
        NSArray *sectionData = [_dataArray objectAtIndex:j];
        totalOffSet += 44*sectionData.count;//计算所有row的高度
    }
    CGPoint point = CGPointMake(0, totalOffSet);
    [_tableView setContentOffset:point];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

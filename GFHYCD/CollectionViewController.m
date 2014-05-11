//
//  CollectionViewController.m
//  GFHYCD
//
//  Created by Ibokan on 13-9-24.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import "CollectionViewController.h"
#import "DictionaryCell.h"
#import "DBManager.h"
#import "DisplayDetailCharacterViewController.h"
@interface CollectionViewController ()

@end

@implementation CollectionViewController

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
    [self getDataFromCollectionTable];
	[self initSubView];
}
#pragma mark - 初始化子视图
- (void) initSubView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-20-44)style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentify = @"cellIndentify";
    DictionaryCell *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    if (cell == nil) {
        cell = [[DictionaryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify];
    }
    CharacterModel *characterModel = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.characterModel = characterModel;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pinyin.png"]];
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 200, 40)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = [UIFont systemFontOfSize:20.0f];
    textLabel.textColor = [UIColor blackColor];
    NSString *text = [_titleSectionAry objectAtIndex:section];
    NSDate *date = [NSDate date];
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    [formate setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateStr = [formate stringFromDate:date];
    if ([dateStr isEqualToString:text]) {
        text = @"今天";
    }

    
    textLabel.text = text;
    [headerView addSubview:textLabel];
    return headerView;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CharacterModel *characterModel = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    DetailCharacterModel *detailCharacterModel = [[_detailArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    DisplayDetailCharacterViewController *detailCtr = [[DisplayDetailCharacterViewController alloc]init];
    detailCtr.characterModel = characterModel;
    detailCtr.detailCharacterModel = detailCharacterModel;
    detailCtr.isLoadDataFromNet = NO;
    
    [tableView.getFirstController.navigationController pushViewController:detailCtr animated:YES];
}
- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *time = [[_deleteByTime objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [[DBManager sharedInstance] deleteDetailCharactersFromTableByTime:time tableName:ShouCangTable];
        [self getDataFromCollectionTable];
        [_tableView reloadData];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - 获取数据库中的数据
- (void) getDataFromCollectionTable
{
    NSArray *resultArray = [[DBManager sharedInstance]findDetailCharactersFromTable:ShouCangTable];
    self.dataArray = [[NSMutableArray alloc]init];
    self.titleSectionAry = [[NSMutableArray alloc]init];
    self.detailArray = [[NSMutableArray alloc]init];
    self.deleteByTime = [[NSMutableArray alloc]init];
    NSString *temp = nil;
    //如果当前的时间值与上一个不等的话则把它放入数组中,同时更新上一个时间值
    for (NSArray *item in resultArray) {
        NSString *titleTime = [item objectAtIndex:3];
        if (![temp isEqualToString:titleTime]) {
            [_titleSectionAry addObject:titleTime];
            temp = titleTime;
        }
    }
    
    for (int i = 0; i < _titleSectionAry.count; i++) {
        NSString *temp = [_titleSectionAry objectAtIndex:i];
        NSMutableArray *dataArrayRow = [NSMutableArray array];
        NSMutableArray *detailArrayRow = [NSMutableArray array];
        NSMutableArray *deleteByTimeRow = [NSMutableArray array];
        for (NSArray *itemAry in resultArray) {
            NSString *titleTime = [itemAry objectAtIndex:3];
            if ([temp isEqualToString:titleTime]) {
                CharacterModel *characterModel = [itemAry objectAtIndex:0];
                DetailCharacterModel *detailCharacterModel = [itemAry objectAtIndex:1];
                NSString *time = [itemAry objectAtIndex:2];
                [dataArrayRow addObject:characterModel];
                [detailArrayRow addObject:detailCharacterModel];
                [deleteByTimeRow addObject:time];
            }//else 即可break 因为这个数据类型是有规律的
        }
        
        [_dataArray addObject:dataArrayRow];
        [_detailArray addObject:detailArrayRow];
        [_deleteByTime addObject:deleteByTimeRow];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end

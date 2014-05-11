//
//  BuShouViewController.m
//  GFHYCD
//
//  Created by Ibokan on 13-9-23.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import "BuShouViewController.h"
#import "DBManager.h"
#import "DisplaySearchCharacterController.h"
@interface BuShouViewController ()

@end

@implementation BuShouViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initData];
        self.isPinYin = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super jumpToDestination:_indentify];
     
}
#pragma mark - 初始化数据
- (void) initData
{
    self.buShouId = [[NSMutableArray alloc]init];
    NSArray *resultArray = [[DBManager sharedInstance]findDataFromTableName:BuShouTable];
    NSMutableArray *dataArray = [NSMutableArray array];
    NSMutableArray *titleSectionAry = [NSMutableArray array];
    for (int i = 0; i <17; i++) {
        NSString *biHua = [NSString stringWithFormat:@"%d",i+1];
        [titleSectionAry addObject:biHua];
        NSMutableArray *sectionDataAry = [NSMutableArray array];
        NSMutableArray *sectionBuShouId = [NSMutableArray array];
        for (NSArray *aryItem in resultArray) {
            NSString *biHuaItem = [aryItem objectAtIndex:0];
            NSString *titleItem = [aryItem objectAtIndex:1];
            NSString *idCharacter = [aryItem objectAtIndex:2];
            if ([biHuaItem isEqualToString:biHua]) {
                [sectionDataAry addObject:titleItem];
                [sectionBuShouId addObject:idCharacter];
            }
        }
        [dataArray addObject:sectionDataAry];
        [_buShouId addObject:sectionBuShouId];
    }
    self.titleSectionAry = titleSectionAry;
    self.dataArray = dataArray;
}
#pragma mark - 当点击某一个按钮时 让tableView跳转到相应的位置
- (void) quickSearchAction:(UIButton *)btnZiMu
{
    NSString *btnZiMuTitle = btnZiMu.titleLabel.text;
    self.displaySelectedLabel.text = btnZiMuTitle;
    [super jumpToDestination:btnZiMu.tag];
    [super AppearDisplaySelectedLabel];
}

#pragma mark - UITableViewDelegate 在子类中实现
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *biHua = [[_buShouId objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    NSString *buShouStr = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    DisplaySearchCharacterController *displayCtr = [[DisplaySearchCharacterController alloc]init];
    displayCtr.type = BiHua;
    displayCtr.searchIndentify = biHua;
    displayCtr.title = buShouStr;
    [self.navigationController pushViewController:displayCtr animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

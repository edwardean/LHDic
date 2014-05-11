//
//  PinYinViewController.m
//  GFHYCD
//
//  Created by Ibokan on 13-9-23.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import "PinYinViewController.h"
#import "DBManager.h"
#import "DisplaySearchCharacterController.h"
@interface PinYinViewController ()

@end

@implementation PinYinViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super jumpToDestination:_indentify];
}

#warning 千万不能让子类的方法把父类的方法给覆盖掉,要不然父类的方法不会执行
#pragma mark - 初始化数据
- (void) initData
{
    NSArray *resultArray = [[DBManager sharedInstance]findDataFromTableName:PinYinTable];
    NSMutableArray *titleSectionAry = [NSMutableArray array];//存放26个字母
    NSMutableArray *tempArray = [NSMutableArray array];//存放剩余的拼音
    NSMutableArray *dataArray = [NSMutableArray array];//数据源(所有拼音)里面放的是数组(每个数组里面放的是每一个section的data数据)
//得到26个字母
    for (int i = 0; i < resultArray.count; i++) {
        NSString *ziMuStr = [resultArray objectAtIndex:i];
        if (i < 26) {
            [titleSectionAry addObject:ziMuStr];
        } else {
            [tempArray addObject:ziMuStr];
        }
    }
//得到每个字母对应的拼音 因为tempArray的拼音是无序的,所以要对它进行分组
    for (int j = 0; j <titleSectionAry.count; j++) {
        NSString *ziFuChar = [titleSectionAry objectAtIndex:j];
        NSMutableArray *sectionDataAry = [NSMutableArray array];
        for (int i = 0; i <tempArray.count; i++) {
            NSString *strItem = [tempArray objectAtIndex:i];
            if ([strItem hasPrefix:ziFuChar]) {
                [sectionDataAry addObject:strItem];
            }
        }
        [dataArray addObject:sectionDataAry];
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
    NSString *pinYin = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    DisplaySearchCharacterController *displayCtr = [[DisplaySearchCharacterController alloc]init];
    displayCtr.type = PinYin;
    displayCtr.searchIndentify = pinYin;
    displayCtr.title = pinYin;
    [self.navigationController pushViewController:displayCtr animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

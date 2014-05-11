//
//  SearchCharacterViewController.h
//  GFHYCD
//  拼音搜索和部首搜索的两种不同方式的通用类,通过传入的不同参数值进入展示不同的界面
//  Created by Ibokan on 13-9-23.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import "BaseViewController.h"
#define kSectionTitle @"sectionTitle"
#define kSectionData @"sectionData"
@interface SearchCharacterViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) NSArray *dataArray;//数据源(所有拼音或所有部首)里面放的是数组(每个数组里面放的是没一个section的data数据)
@property (nonatomic,retain) NSArray *titleSectionAry;//说有section的标题来源

@property (nonatomic,retain) UILabel *displaySelectedLabel;//中见的一个用来显示当前你选中的是哪个字符
@property (nonatomic,retain) UIView *quickSearchView;//右边的那一天侧边栏,让快速查找的

@property (nonatomic,assign) BOOL isPinYin;//标示是否是拼音 section的title跟拼音的不一样所以要标示下
@property (nonatomic,retain) NSMutableArray *myTitleSectionAry;//部首的section的title
- (void) AppearDisplaySelectedLabel;//让displaySelectedLabel的alpha值从1渐变到0 先显示然后再隐藏

//根据传入的参数 让tableView重新定位 section是你点击的是哪个部分
- (void) jumpToDestination:(int)section;
//当点击某一个按钮时 让tableView跳转到相应的位置 在子类中实现
- (void) quickSearchAction:(UIButton *)btnZiMu;

@end

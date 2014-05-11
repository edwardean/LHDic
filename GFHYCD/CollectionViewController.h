//
//  CollectionViewController.h
//  GFHYCD
//
//  Created by Ibokan on 13-9-24.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import "BaseViewController.h"
#import "DictionaryTableView.h"
@interface CollectionViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@property (nonatomic,retain) NSMutableArray *dataArray;//数据源里面全部放的是characterModel给cell填充数据[[characterModel,characterModel,characterModel,,,],[characterModel,characterModel],[],,,,]
@property (nonatomic,retain) NSMutableArray *titleSectionAry;//section的标题来源
@property (nonatomic,retain) NSMutableArray *detailArray;//当跳转到详细界面时,需要给那个类传递的参数 数据存储格式跟dataArray一样
@property (nonatomic,retain) NSMutableArray *deleteByTime;//根据每一个汉字存入数据库时间来删除某个汉字,time是主键
@end

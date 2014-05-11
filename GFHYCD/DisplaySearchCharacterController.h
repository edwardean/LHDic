//
//  DisplaySearchCharacterController.h
//  GFHYCD
//  一个通用的搜索结果展示类 根据传入的搜索类型和索引进行请求并展示数据
//  Created by Ibokan on 13-9-18.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import "BaseViewController.h"
#import "DictionaryTableView.h"

#define PageSize @"10"
typedef enum {
    PinYin=0,
    BiHua
}SearchType;

@interface DisplaySearchCharacterController : BaseViewController<UITableViewUpDownEvent>
{
    DictionaryTableView *_tableView;
}

@property (nonatomic,retain) NSArray *characterArray;//临时数组 用来存放每次请求下来的数据 供下一次相应的操作使用
@property (nonatomic,copy) NSString *searchIndentify;//搜索汉字时的关键索引值
@property (nonatomic,assign) SearchType type;//以哪种方式进行搜索汉字
@property (nonatomic,copy) NSString *pagenum;//总的数据页数
@property (nonatomic,copy) NSString *curpage;//当前是第几页
@end

//
//  DictionaryTableView.h
//  GFHYCD
//  展示搜索数据的表 实现了上拉刷新
//  Created by Ibokan on 13-9-16.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DictionaryCell.h"

@protocol UITableViewUpDownEvent <NSObject>
@optional
- (void)pullUp:(UITableView *)tableView;
@end

@interface DictionaryTableView : UITableView <UITableViewDataSource,UITableViewDelegate>
{
    UIButton *_loadMoreButton;
}
@property (nonatomic,retain) NSArray *dataArray;//放的是CharacterModel对象

@property (nonatomic,assign) BOOL isMore;
@property (nonatomic,assign) id <UITableViewUpDownEvent> eventDelegate;
@end

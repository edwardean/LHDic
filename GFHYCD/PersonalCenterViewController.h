//
//  PersonalCenterViewController.h
//  GFHYCD
//
//  Created by Ibokan on 13-9-23.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import "BaseViewController.h"

@interface PersonalCenterViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_myDataArray;
}

@end





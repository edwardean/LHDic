//
//  BuShouViewController.h
//  GFHYCD
//
//  Created by Ibokan on 13-9-23.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import "SearchCharacterViewController.h"

@interface BuShouViewController : SearchCharacterViewController
@property (nonatomic,assign) int indentify;//传入的表示符通过它搜索相关项
@property (nonatomic,retain) NSMutableArray *buShouId;
@end

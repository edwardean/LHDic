//
//  DBManager.h
//  GFHYCD
//
//  Created by Ibokan on 13-9-22.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import "BaseDB.h"
#import "CharacterModel.h"
#import "DetailCharacterModel.h"
#define BuShouTable @"ol_bushou"
#define PinYinTable @"ol_pinyins"
#define ShouCangTable @"shouCang"
#define LatestSearchTable @"latestSearch"
@interface DBManager : BaseDB
//类方法 得到共享变量
+ (id) sharedInstance;

//创建一个表
- (BOOL) createTable:(NSString *)tableName;

//往表中添加CharacterModel和DetailCharacterModel和date日期对象
- (BOOL) addDetailCharacterToTable:(NSArray *)params tableName:(NSString *)tableName;

//从表中搜索已经存储到其中的数据
- (NSArray *)findDetailCharactersFromTable:(NSString *)tableName;
//根据时间这个主键 删除该数据
- (BOOL) deleteDetailCharactersFromTableByTime:(NSString *)time tableName:(NSString *)tableName;
//从ol_bushou.sqlite中读取用户所需的不同表的数据
- (NSArray *)findDataFromTableName:(NSString *)tableName;

@end

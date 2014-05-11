//
//  BaseDB.h
//  GFHYCD
//
//  Created by Ibokan on 13-9-22.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#define kFileName @"collection.sqlite"
@interface BaseDB : NSObject

/**
 *功能:创建一个数据库的表
 *参数:创建表的SQL语句
 *返回值:布尔类型的标示是否创建表成功
 */
- (BOOL) createTable:(NSString *)sql;

/**
 *功能:完成增 删 改操作
 *参数:所需要的SQL语句和执行的参数(占位符对应的值)
 *返回:布尔类型的标示是否操作成功
 */
- (BOOL) dealWithData:(NSString *)sql params:(NSArray *)params;

/**
 *功能:查询表中的数据
 *参数:SQL语句和你要查询的列数
 *返回值:把每一行的结果放到一个数组中,然后把存放每一行数据的这个数组放到一个大数组中返回(读取沙盒中表的数据)
 */
- (NSArray *) selectDataFromTable:(NSString *)sql colums:(int)number;

//从ol_bushou.sqlite中读取用户所需的数据(本地读取)
- (NSArray *)selectDataFromTable:(NSString *)fileName sql:(NSString *)sql colums:(int)number;
@end

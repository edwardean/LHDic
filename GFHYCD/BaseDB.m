//
//  BaseDB.m
//  GFHYCD
//
//  Created by Ibokan on 13-9-22.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import "BaseDB.h"

@implementation BaseDB
- (NSString *)getFilePath
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",kFileName];
    return filePath;
}
/**
 *功能:创建一个数据库的表
 *参数:创建表的SQL语句
 *返回值:布尔类型的标示是否创建表成功
 */
- (BOOL)createTable:(NSString *)sql
{
    sqlite3 *sqlite = nil;
    //打开数据库
    if (sqlite3_open([self.getFilePath UTF8String], &sqlite) != SQLITE_OK){
        NSLog(@"创建数据库失败");
        sqlite3_close(sqlite);
        return NO;
    }
    //执行SQL语句
    char *error = NULL;
    if (sqlite3_exec(sqlite, [sql UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        NSLog(@"创建表失败:%s",error);
        sqlite3_close(sqlite);
        return NO;
    }
    sqlite3_close(sqlite);
    return YES;
}

/**
 *功能:完成增 删 改操作
 *参数:所需要的SQL语句和执行的参数(占位符对应的值)
 *返回:布尔类型的标示是否操作成功
 */
- (BOOL) dealWithData:(NSString *)sql params:(NSArray *)params
{
    sqlite3 *sqlite = nil;
    //打开数据库表
    if (sqlite3_open([self.getFilePath UTF8String], &sqlite) != SQLITE_OK) {
        NSLog(@"打开数据库失败");
        sqlite3_close(sqlite);
        return NO;
    }
    //编译SQL语句
    sqlite3_stmt *stmt = nil;
    if (sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL) != SQLITE_OK) {
        NSLog(@"编译出错");
        sqlite3_finalize(stmt);
        sqlite3_close(sqlite);
        return NO;
    }
    //绑定数据
    for (int i = 0; i < params.count; i++) {
        NSString *value = [params objectAtIndex:i];
        sqlite3_bind_text(stmt, i+1,[value UTF8String] , -1, NULL);
    }
    //执行SQL语句
    if (sqlite3_step(stmt) == SQLITE_ERROR) {
        NSLog(@"执行SQL语句失败");
        sqlite3_finalize(stmt);
        sqlite3_close(sqlite);
        return NO;
    }
    sqlite3_finalize(stmt);
    sqlite3_close(sqlite);
    return YES;
}

/**
 *功能:查询表中的数据
 *参数:SQL语句和你要查询的列数
 *返回值:把每一行的结果放到一个数组中,然后把存放每一行数据的这个数组放到一个大数组中返回
 */
- (NSArray *) selectDataFromTable:(NSString *)sql colums:(int)number;
{
    sqlite3 *sqlite = nil;
    //打开数据库
    if (sqlite3_open([self.getFilePath UTF8String], &sqlite) != SQLITE_OK) {
        NSLog(@"打开数据库失败");
        sqlite3_close(sqlite);
        return nil;
    }
    //编译SQL语句
    sqlite3_stmt *stmt = nil;
    if (sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL) != SQLITE_OK) {
        NSLog(@"编译出错");
        sqlite3_finalize(stmt);
        sqlite3_close(sqlite);
        return nil;
    }
    int result = sqlite3_step(stmt);
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    while (result == SQLITE_ROW) {
        NSMutableArray *rowArray = [NSMutableArray arrayWithCapacity:number];
        for (int i = 0; i < number;i++) {
            char *resultChar = (char *)sqlite3_column_text(stmt, i);
            NSString *resultStr = [NSString stringWithCString:resultChar encoding:NSUTF8StringEncoding];
            [rowArray addObject:resultStr];
        }
        [resultArray addObject:rowArray];
        result = sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
    sqlite3_close(sqlite);
    return resultArray;
}

//从ol_bushou.sqlite中读取用户所需的数据(本地读取)
- (NSArray *)selectDataFromTable:(NSString *)fileName sql:(NSString *)sql colums:(int)number
{
    sqlite3 *sqlite = nil;
    //打开数据库
    if (sqlite3_open([fileName UTF8String], &sqlite) != SQLITE_OK) {
        NSLog(@"打开数据库失败");
        sqlite3_close(sqlite);
        return nil;
    }
    //编译SQL语句
    sqlite3_stmt *stmt = nil;
    if (sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &stmt, NULL) != SQLITE_OK) {
        NSLog(@"编译出错");
        sqlite3_finalize(stmt);
        sqlite3_close(sqlite);
        return nil;
    }
    
    int result = sqlite3_step(stmt);
    NSMutableArray *resultArray = [NSMutableArray array];
    while (result == SQLITE_ROW) {
        NSMutableArray *rowArray = [NSMutableArray arrayWithCapacity:number];
        for (int i = 0; i < number; i++) {
            char *resultChar = (char *)sqlite3_column_text(stmt, i);
            NSString *resultStr = [NSString stringWithCString:resultChar encoding:NSUTF8StringEncoding];
            [rowArray addObject:resultStr];
        }
        [resultArray addObject:rowArray];
        result = sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
    sqlite3_close(sqlite);
    return resultArray;
}
@end












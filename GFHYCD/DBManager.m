//
//  DBManager.m
//  GFHYCD
//
//  Created by Ibokan on 13-9-22.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager
#pragma mark - 类方法 得到共享变量
+ (id) sharedInstance
{
    static DBManager *instance = nil;
    if (instance == nil) {
        instance = [[[self class]alloc]init];
    }
    return instance;
}

#pragma mark - 创建一个表
- (BOOL) createTable:(NSString *)tableName;
{
    NSString *sql = nil;
    if ([tableName isEqualToString:@"shouCang"]) {
        sql = @"CREATE TABLE shouCang (time TEXT PRIMARY KEY  NOT NULL ,jianTi TEXT,pinYin TEXT,zhuYin TEXT,fanTi TEXT,jieGou TEXT,buShou TEXT,biHua TEXT,buShouBiHua TEXT,biShun TEXT, hanYu TEXT, base TEXT, english TEXT, idiom TEXT)";
    } else if ([tableName isEqualToString:@"latestSearch"]) {
        sql = @"CREATE TABLE latestSearch (time TEXT PRIMARY KEY  NOT NULL ,jianTi TEXT,pinYin TEXT,zhuYin TEXT,fanTi TEXT,jieGou TEXT,buShou TEXT,biHua TEXT,buShouBiHua TEXT,biShun TEXT, hanYu TEXT, base TEXT, english TEXT, idiom TEXT)";
    }
    
    return [super createTable:sql];
}

//往表中添加CharacterModel和DetailCharacterModel数据和date日期对象
/*
 INSERT OR REPLACE INTO ol_shouchang  ("id" ,"hanzi","pinyin","fanti","bushou","bishun" ,"jiegou" ,"bsNum" ,"bihuaNum" ,"zhuyin" ,"time" , "hanYu" , "base" , "english" , "idiom" ) VALUES(1,'AA','AA','AA','AA','AA','AA','AA','AA','AA','AA','AA','AA','AA','AA')
 */

/*
 params = [CharacterModel,DetailCharacterModel,NSString]
 */
#pragma mark - 往表中添加数据
- (BOOL) addDetailCharacterToTable:(NSArray *)params tableName:(NSString *)tableName;
{
    NSString *sql = nil;
    if ([tableName isEqualToString:@"shouCang"]) {
        sql = @"INSERT OR REPLACE INTO shouCang (time,jianTi,pinYin,zhuYin,fanTi,jieGou,buShou,biHua,buShouBiHua,biShun,hanYu,base,english,idiom) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    } else if ([tableName isEqualToString:@"latestSearch"]) {
        sql = @"INSERT OR REPLACE INTO latestSearch (time,jianTi,pinYin,zhuYin,fanTi,jieGou,buShou,biHua,buShouBiHua,biShun,hanYu,base,english,idiom) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    }
    
    CharacterModel *characterModel = [params objectAtIndex:0];
    NSString *jianTi = nil;
    NSString *pinYin = nil;
    NSString *zhuYin = nil;
    NSString *fanTi = nil;
    NSString *jieGou = nil;
    NSString *buShou = nil;
    NSString *biHua = nil;
    NSString *buShouBiHua = nil;
    NSString *biShun = nil;
    if ([characterModel isKindOfClass:[CharacterModel class]]) {
        jianTi = characterModel.jianTi;
        pinYin = characterModel.pinYin;
        zhuYin = characterModel.zhuYin;
        fanTi = characterModel.fanTi;
        jieGou = characterModel.jieGou;
        buShou = characterModel.buShou;
        biHua = characterModel.biHua;
        buShouBiHua = characterModel.buShouBiHua;
        biShun = characterModel.biShun;
    }
    DetailCharacterModel *detailCharacterModel = [params objectAtIndex:1];
    NSString *hanYu = nil;
    NSString *base = nil;
    NSString *english = nil;
    NSString *idiom = nil;
    if ([detailCharacterModel isKindOfClass:[DetailCharacterModel class]]) {
        hanYu = detailCharacterModel.hanYu;
        base = detailCharacterModel.base;
        english = detailCharacterModel.english;
        idiom = detailCharacterModel.idiom;
    }
    
    NSString *time = nil;
    NSString *resultTime = [params objectAtIndex:2];
    if ([resultTime isKindOfClass:[NSString class]]) {
        time = resultTime;
    }
    NSArray *array = [NSArray arrayWithObjects:time,jianTi,pinYin,zhuYin,fanTi,jieGou,buShou,biHua,buShouBiHua,biShun,hanYu,base,english,idiom,nil];
    return [super dealWithData:sql params:array];
}
//从表中搜索已经存储到其中的数据
#pragma mark - returnResultArray存放的是array对象 而array中依次存放的是CharacterModel对象 DetailCharacterModel对象
/*
 returnResultArray = [CharacterModel,CharacterModel,titleDate]
 */
- (NSArray *)findDetailCharactersFromTable:(NSString *)tableName;
{
    NSString *sql = nil;
    if ([tableName isEqualToString:@"shouCang"]) {
        sql = @"SELECT jianTi,pinYin,zhuYin,fanTi,jieGou,buShou,biHua,buShouBiHua,biShun,hanYu,base,english,idiom,time FROM shouCang";
    } else if ([tableName isEqualToString:@"latestSearch"]) {
        sql = @"SELECT jianTi,pinYin,zhuYin,fanTi,jieGou,buShou,biHua,buShouBiHua,biShun,hanYu,base,english,idiom,time FROM latestSearch";
    }
    
    NSArray *resultArray = [super selectDataFromTable:sql colums:14];
    int num = resultArray.count;
    NSMutableArray *returnResultArray = [[NSMutableArray alloc]initWithCapacity:num];
    for (NSArray *itemArray in resultArray) {
        NSMutableArray *myReslutArray = [NSMutableArray arrayWithCapacity:4];
        CharacterModel *characterModel = [[CharacterModel alloc]init];
        DetailCharacterModel *detailCharacterModel = [[DetailCharacterModel alloc]init];
        NSString *time = nil;
        NSString *titleDate = nil;
        characterModel.jianTi = [itemArray objectAtIndex:0];
        characterModel.pinYin = [itemArray objectAtIndex:1];
        characterModel.zhuYin = [itemArray objectAtIndex:2];
        characterModel.fanTi = [itemArray objectAtIndex:3];
        characterModel.jieGou = [itemArray objectAtIndex:4];
        characterModel.buShou = [itemArray objectAtIndex:5];
        characterModel.biHua = [itemArray objectAtIndex:6];
        characterModel.buShouBiHua = [itemArray objectAtIndex:7];
        characterModel.biShun = [itemArray objectAtIndex:8];
        
        detailCharacterModel.hanYu = [itemArray objectAtIndex:9];
        detailCharacterModel.base = [itemArray objectAtIndex:10];
        detailCharacterModel.english = [itemArray objectAtIndex:11];
        detailCharacterModel.idiom = [itemArray objectAtIndex:12];
        
        time = [itemArray objectAtIndex:13];
        //tableView的section的标题
        NSArray *timeArray = [time componentsSeparatedByString:@"-"];
        NSString *nianStr = [timeArray objectAtIndex:0];
        NSString *yueStr = [timeArray objectAtIndex:1];
        NSString *riStr = [timeArray objectAtIndex:2];
        titleDate = [NSString stringWithFormat:@"%@年%@月%@日",nianStr,yueStr,riStr];
        [myReslutArray addObject:characterModel];
        [myReslutArray addObject:detailCharacterModel];
        [myReslutArray addObject:time];
        [myReslutArray addObject:titleDate];
        
        [returnResultArray insertObject:myReslutArray atIndex:0];
        
    }
    return returnResultArray;
}

#pragma mark - 根据时间这个主键 删除该数据
- (BOOL) deleteDetailCharactersFromTableByTime:(NSString *)time tableName:(NSString *)tableName
{
    NSString *sql = nil;
    if ([tableName isEqualToString:@"shouCang"]) {
        sql = @"delete from shouCang where time = ?";
    }else if ([tableName isEqualToString:@"latestSearch"]) {
        sql = @"delete from latestSearch where time = ?";
    }
    NSArray *param = [NSArray arrayWithObject:time];
    return [super dealWithData:sql params:param];
}

//从ol_bushou.sqlite中读取用户所需的不同表的数据 当从ol_bushou表中返回值是一个数组 数组中放着字典,字典中放着key和vaule 当从ol_pinyins返回时 返回的是一个数组 里面放着NSString对象
/*
 
 */
#pragma mark - 在本地查找数据库中表的数据
- (NSArray *)findDataFromTableName:(NSString *)tableName;
{
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"ol_bushou" ofType:@"sqlite"];
    NSString *sql = nil;//SQL语句
    int num = 0;//要搜索表的列数
    if ([tableName isEqualToString:BuShouTable]) {
        sql = @"SELECT bihua,title,id FROM ol_bushou";
        num = 3;
    } else if ([tableName isEqualToString:PinYinTable]) {
        sql = @"SELECT pinyin FROM ol_pinyins";
        num = 1;
    }
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    NSArray *array = [super selectDataFromTable:fileName sql:sql colums:num];
    if ([tableName isEqualToString:BuShouTable]) {
        for (NSArray *itemArray in array) {
            NSMutableArray *arrayItem = [NSMutableArray array];
            NSString *biHua = [itemArray objectAtIndex:0];
            NSString *title = [itemArray objectAtIndex:1];
            NSString *buShouId = [itemArray objectAtIndex:2];
            [arrayItem addObject:biHua];
            [arrayItem addObject:title];
            [arrayItem addObject:buShouId];
            [resultArray addObject:arrayItem];
        }
    } else if ([tableName isEqualToString:PinYinTable]) {
        for (NSArray *itemArray in array) {
            NSString *pinyin = [itemArray objectAtIndex:0];
            [resultArray addObject:pinyin];
        }
        
    }
    return resultArray;
}

@end







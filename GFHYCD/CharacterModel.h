//
//  CharacterModel.h
//  GFHYCD
//
//  Created by Ibokan on 13-9-17.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CharacterModel : NSObject
@property (nonatomic,copy) NSString *jianTi;//简体
@property (nonatomic,copy) NSString *pinYin;//拼音
@property (nonatomic,copy) NSString *zhuYin;//注音
@property (nonatomic,copy) NSString *fanTi;//繁体
@property (nonatomic,copy) NSString *jieGou;//结构
@property (nonatomic,copy) NSString *buShou;//部首
@property (nonatomic,copy) NSString *biHua;//笔画
@property (nonatomic,copy) NSString *buShouBiHua;//部首笔画
@property (nonatomic,copy) NSString *biShun;//笔顺
@property (nonatomic,copy) NSString *shengYin;//声音

@end

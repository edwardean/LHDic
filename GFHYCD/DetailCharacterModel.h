//
//  DetailCharacterModel.h
//  GFHYCD
//
//  Created by Ibokan on 13-9-17.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailCharacterModel : NSObject

@property (nonatomic,copy) NSString *hanYu;//基本信息
@property (nonatomic,copy) NSString *base;//汉语词典
@property (nonatomic,copy) NSString *english;//英文翻译
@property (nonatomic,copy) NSString *idiom;//组词成语

@end

//
//  GFHttpRequest.h
//  GFHYCD
//  网络请求的类
//  Created by Ibokan on 13-9-17.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^MyRequestBlock)(id result);
@interface GFHttpRequest : NSObject

+ (void)getRequestWithURL:(NSString *)urlString params:(NSMutableArray *)params completeBlock:(MyRequestBlock)myRequestBlock;

@end

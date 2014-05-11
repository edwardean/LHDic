//
//  GFHttpRequest.m
//  GFHYCD
//
//  Created by Ibokan on 13-9-17.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import "GFHttpRequest.h"
#define BaseUrl @"http://www.chazidian.com/service/"
@implementation GFHttpRequest
/*
 http://www.chazidian.com/service/pinyin/ban/0/2
 http://www.chazidian.com/service/bushou/12/0/2
 http://www.chazidian.com/service/word/办
 "pagenum":23,"curpage":1,"pagesize":2}}}
 */
+ (void)getRequestWithURL:(NSString *)urlString params:(NSMutableArray *)params completeBlock:(MyRequestBlock)myRequestBlock;
{
    urlString = [BaseUrl stringByAppendingFormat:@"%@",urlString];
    if (params != nil) {
        NSMutableString *paramStr = [[NSMutableString alloc]init];
        for (NSString *item  in params) {
            [paramStr appendFormat:@"%@/",item];
        }
        [paramStr deleteCharactersInRange:NSMakeRange(paramStr.length-1, 1)];
        urlString = [urlString stringByAppendingFormat:@"/%@",paramStr];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
    
        if (error != nil) {
            myRequestBlock(nil);
        }
        
        if (data == nil) {
            myRequestBlock(nil);
        }else {
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString *resultType = [[result objectForKey:@"type"] stringValue];
            if ([resultType isEqualToString:@"100"]) {
                myRequestBlock(result);
            } else {
                myRequestBlock(nil);
            }
        }
    }];
}

@end










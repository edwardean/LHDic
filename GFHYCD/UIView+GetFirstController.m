//
//  UIView+GetFirstController.m
//  GFHYCD
//
//  Created by Ibokan on 13-9-20.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import "UIView+GetFirstController.h"

@implementation UIView (GetFirstController)
#pragma mark - 得到view的第一个UIViewController
- (UIViewController *)getFirstController
{
    UIResponder *nextResponder = self.nextResponder;
    do {
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
        nextResponder = nextResponder.nextResponder;
    } while (nextResponder != nil);
    return nil;
}
@end

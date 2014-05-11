//
//  RootViewController.h
//  GFHYCD
//
//  Created by Ibokan on 13-9-16.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "DictionaryTableView.h"
#define kLatestSearchWordCount 9
@interface RootViewController : BaseViewController<UITextFieldDelegate>
{
    NSArray *_pinYinArray;
    NSArray *_biShunArray;
    NSArray *_latestSearchArray;
    
    NSMutableArray *_myPinYinAry1;//存放汉字的所有拼音
    NSMutableArray *_myShuZiAry;//存放合法的1-17数字的数组
    NSMutableArray *_myZiMuAry;//存放26个英文字母
}
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentCtr;
@property (retain, nonatomic) IBOutlet UITextField *textField;
@property (retain, nonatomic) IBOutlet UIView *latestSearchView;
@property (retain, nonatomic) IBOutlet UIView *searchTypeView;
@property (nonatomic,retain) UIAlertView *alertView;//警告提示view
@property (retain, nonatomic) IBOutlet UILabel *searchTypeLabel;
@end

//
//  DetailCharacterView.h
//  GFHYCD
//
//  Created by Ibokan on 13-9-20.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailCharacterModel.h"
typedef void (^ MyDetailCharacterBlock)(NSString *selectStr);
@interface DetailCharacterView : UIView
{
    UISegmentedControl *_segmentedControl;
    UIImageView *_imageView;
    UILabel *_nameLabel;
    UITextView *_textView;
}
@property (nonatomic,retain) DetailCharacterModel *detailCharacterModel;
@property (nonatomic,copy) MyDetailCharacterBlock myDetailCharacterBlock;
@end

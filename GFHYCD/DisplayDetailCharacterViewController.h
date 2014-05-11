//
//  DisplayDetailCharacterViewController.h
//  GFHYCD
//  展示每一个汉字的详细信息
//  Created by Ibokan on 13-9-20.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import "BaseViewController.h"
#import "CharacterView.h"
#import "DetailCharacterView.h"
#define kLatestSearchCharacter @"LatestSearchCharacter"
#define kLatestSearchWordCount 9
@interface DisplayDetailCharacterViewController : BaseViewController
{
    CharacterView *_characterView;
    DetailCharacterView *_detailCharacterView;
    UIView *_tabBarView;
    UIView *_buttonView;//工具栏上面的"按钮"
    UIImageView *_selectedImageView;//选中后的背景图片
    NSString *_selectStr;//选择不同段落的内容
}
@property (nonatomic,retain) CharacterModel *characterModel;
@property (nonatomic,retain) DetailCharacterModel *detailCharacterModel;
@property (nonatomic,assign) BOOL isLoadDataFromNet;
@end

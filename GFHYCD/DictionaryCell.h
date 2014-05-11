//
//  DictionaryCell.h
//  GFHYCD
//  自定义的cell类
//  Created by Ibokan on 13-9-18.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CharacterModel.h"
//#import <AVFoundation/AVFoundation.h>
@interface DictionaryCell : UITableViewCell

@property (nonatomic,retain) CharacterModel *characterModel;
@property (retain, nonatomic) IBOutlet UIButton *jianTi;
@property (retain, nonatomic) IBOutlet UILabel *pinYin;
@property (retain, nonatomic) IBOutlet UILabel *buShou;
@property (retain, nonatomic) IBOutlet UIImageView *shengYin;
@property (retain, nonatomic) IBOutlet UILabel *biHua;
//@property (nonatomic,retain) AVAudioPlayer *player;
@end

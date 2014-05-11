//
//  CharacterView.h
//  GFHYCD
//
//  Created by Ibokan on 13-9-20.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CharacterModel.h"
@interface CharacterView : UIView

@property (nonatomic,retain) CharacterModel *characterModel;

@property (retain, nonatomic) IBOutlet UIButton *jianTi;
@property (retain, nonatomic) IBOutlet UILabel *pinYin;
@property (retain, nonatomic) IBOutlet UILabel *fanTi;
@property (retain, nonatomic) IBOutlet UILabel *buShou;
@property (retain, nonatomic) IBOutlet UILabel *biShun;
@property (retain, nonatomic) IBOutlet UILabel *zhuYin;
@property (retain, nonatomic) IBOutlet UILabel *jieGou;
@property (retain, nonatomic) IBOutlet UILabel *biHua;
@property (retain, nonatomic) IBOutlet UILabel *buShouBiHua;

- (IBAction)soundAction:(id)sender;

@end

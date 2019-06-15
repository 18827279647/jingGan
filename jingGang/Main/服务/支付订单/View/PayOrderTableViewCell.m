//
//  PayOrderTableViewCell.m
//  jingGang
//
//  Created by thinker on 15/8/13.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "PayOrderTableViewCell.h"
#import "Masonry.h"
#import "UIButton+Design.h"
#import "GlobeObject.h"
@interface PayOrderTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *thirdPaySelectBgBtn;
@end


@implementation PayOrderTableViewCell


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self setAppearence];
}

#pragma mark - set UI content

- (IBAction)thirdPaySelectBtnAction:(id)sender {
    
    [self selectPayWay:self.selectBtn];
    
}

- (IBAction)selectPayWay:(UIButton *)sender {
    if (sender.isSelected) {
        [sender setSelected:NO];
        
    } else {
        [sender setSelected:YES];
        if (self.selectPayBlock) {
            self.selectPayBlock(self.selectBtn);
        }
    }

}


#pragma mark - event response


#pragma mark - set UI init

- (void)setAppearence
{
    [self.selectBtn setEnlargeEdgeWithTop:20 right:0 bottom:20 left:0];
}


@end

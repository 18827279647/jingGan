//
//  JGBindOnAccountTableViewCell.m
//  jingGang
//
//  Created by Ai song on 16/2/25.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "JGBindOnAccountTableViewCell.h"
#import "YSLoginManager.h"
#import "GlobeObject.h"
@interface JGBindOnAccountTableViewCell ()
//第三方昵称label
@property (weak, nonatomic) IBOutlet UILabel *labelThirdNickName;
//第三方名称label距离顶部的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdTitleSpaceTop;


@end
@implementation JGBindOnAccountTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.bindButton setTitleColor:[YSThemeManager buttonBgColor] forState:UIControlStateNormal];
}

- (void)setStrThirdNickName:(NSString *)strThirdNickName
{
    _strThirdNickName = strThirdNickName;
    
    if (strThirdNickName.length > 0 && ![strThirdNickName isEqualToString:@"(null)"]) {
        //如果有值就是绑定了
        self.labelThirdNickName.text = strThirdNickName;
        self.labelThirdNickName.hidden = NO;
        self.thirdTitleSpaceTop.constant = 12.0;
    }
}

- (void)setBindStatuWithArray:(NSArray *)array indexPath:(NSIndexPath *)indexPath
{
    for (NSInteger i = 0; i < array.count; i++) {
        NSDictionary *dictBindInfo = [NSDictionary dictionaryWithDictionary:array[i]];
        NSString *accountType = [NSString stringWithFormat:@"%@",dictBindInfo[@"accountType"]];
        if(indexPath.row == 1){
            //微信平台
            if([accountType isEqualToString:@"4"]){
                
                self.bindButton.selected = YES;
                self.imageViewLeftArr.hidden = YES;
                self.bindButton.userInteractionEnabled = NO;
                self.strThirdNickName = [NSString stringWithFormat:@"%@",dictBindInfo[@"loginName"]];
            }
            
        }else if (indexPath.row == 2){
            //新浪微博平台
            if([accountType isEqualToString:@"5"]){
                
                self.bindButton.selected = YES;
                self.imageViewLeftArr.hidden = YES;
                self.bindButton.userInteractionEnabled = NO;
                self.strThirdNickName = [NSString stringWithFormat:@"%@",dictBindInfo[@"loginName"]];
            }
            
        }else if (indexPath.row == 3){
            //QQ平台
            if([accountType isEqualToString:@"3"]){
                
                self.bindButton.selected = YES;
                self.imageViewLeftArr.hidden = YES;
                self.bindButton.userInteractionEnabled = NO;
                self.strThirdNickName = [NSString stringWithFormat:@"%@",dictBindInfo[@"loginName"]];
            }
        }else if (indexPath.row == 0){
            //手机账号
            if ([accountType isEqualToString:@"2"]) {
                
                self.bindButton.selected = YES;
                self.imageViewLeftArr.hidden = YES;
                self.bindButton.userInteractionEnabled = NO;
                self.strThirdNickName = [NSString stringWithFormat:@"%@",dictBindInfo[@"loginName"]];
            }
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

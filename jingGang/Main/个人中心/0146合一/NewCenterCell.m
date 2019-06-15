//
//  NewCenterCell.m
//  jingGang
//
//  Created by wangying on 15/5/29.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "NewCenterCell.h"

@interface NewCenterCell ()
@property (retain, nonatomic) IBOutlet UIImageView *IconImg;
@property (retain, nonatomic) IBOutlet UILabel *titleText;


@end
@implementation NewCenterCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.countText.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)getIndexRow:(NSInteger)index index:(NSInteger)indexs
{
    
    if (indexs == 0) {

        
        self.countText.layer.cornerRadius = 10.5;
        self.countText.clipsToBounds = YES;
             if (index == 0) {
                 
               self.IconImg.image = [UIImage imageNamed:@"per_notice"];
              self.titleText.text = @"公告";
//              self.countText.text = @"27";
              
              }else if(index == 1){
     
              self.IconImg.image = [UIImage imageNamed:@"per_consult"];
             self.titleText.text = @"咨询";
//             self.countText.text = @"99";
              }else if (index == 2){
                  self.IconImg.image = [UIImage imageNamed:@"AnswerIcon"];
                  self.titleText.text = @"系统消息";
                  self.countText.text = @"99";
              }
    }
   else if (indexs == 6) {
//       self.red_img.hidden = YES;
       switch (index)
       {
           case 0:
           {
               self.IconImg.image = [UIImage imageNamed:@"per_ic_post"];
               self.titleText.text = @"收藏的文章";
               self.countText.text = @"";
           }
               break;
           case 1:
           {
               self.IconImg.image = [UIImage imageNamed:@"gouwu"];
               self.titleText.text = @"收藏的商品";
               self.countText.text = @"";
           }
               break;
           case 2:
           {
               self.IconImg.image = [UIImage imageNamed:@"shop-5s"];
               self.titleText.text = @"收藏的店铺";
               self.countText.text = @"";
           }
               break;
           case 3:
           {
               self.IconImg.image = [UIImage imageNamed:@"icon_service"];
               self.titleText.text = @"收藏的服务";
               self.countText.text = @"";
           }
               break;
           case 4:
           {
               self.IconImg.image = [UIImage imageNamed:@"icon_merchant"];
               self.titleText.text = @"收藏的商户";
               self.countText.text = @"";
           }
               break;

           default:
               break;
       }
    }
   else  if (indexs == 4)
     {
         if (index == 0) {
             self.IconImg.image = [UIImage imageNamed:@"ys_personal_aio_icon"];
             self.titleText.text = @"健康数据";
             UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ys_personal_newicon"]];
             rightImageView.width = 35.;
             rightImageView.height = 15.;
             rightImageView.x = ScreenWidth - rightImageView.width - 12.;
             rightImageView.y = (60 - rightImageView.height) / 2;
             rightImageView.tag = 100;
             [self.contentView addSubview:rightImageView];
             BOOL ret = [[self achieve:@"kDidClickAIOFuctionKey"] boolValue];
             rightImageView.hidden = ret;
         }else if (index == 1) {
            self.IconImg.image = [UIImage imageNamed:@"per_record_test"];
            self.titleText.text = @"自测记录";
         }else if(index == 2){
            self.IconImg.image = [UIImage imageNamed:@"per_record_med"];
            self.titleText.text = @"体检报告";
         }
         self.titleText.font = [UIFont systemFontOfSize:18.0];
         self.countText.text = @"";
    }
}
@end

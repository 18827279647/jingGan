//
//  MyCenterViewCell.m
//  jingGang
//
//  Created by 李海 on 2018/8/12.
//  Copyright © 2018年 dengxf_dev. All rights reserved.
//

#import "MyCenterViewCell.h"
@interface MyCenterViewCell(){
    UILabel *mainTitle;
    NSMutableArray *datas;
    UIView *line1;
    UIView *line2;
}
@end
@implementation MyCenterViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}
- (void)setUpUI{
    CGFloat screenwidth=[UIScreen mainScreen].bounds.size.width;
    mainTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, screenwidth-20, 40)];
    mainTitle.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:mainTitle];
    UIView *container=[[UIView alloc]initWithFrame:CGRectMake(10, 0, screenwidth-20, 100)];
    
}
-(UIView *)genItemTitle:(NSString *)title imageName:(NSString *)imageName{
    CGFloat screenwidth=[UIScreen mainScreen].bounds.size.width;
    UIView *item=[[UIView alloc]initWithFrame:CGRectMake(0, 0, (screenwidth-20-15)/3, 80)];
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (screenwidth-20-15)/3, 60)];
    img.image=[UIImage imageNamed:imageName];
    img.centerX=item.centerX;
    [item addSubview:img];
    UILabel *titleLabel=[[UILabel new]initWithFrame:CGRectMake(0, 70, (screenwidth-20-15)/3, 60)];
    titleLabel.text=title;
    titleLabel.centerX=item.centerX;
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [item addSubview:titleLabel];
    return item;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setModels:(NSDictionary *)dict{
  
}


@end

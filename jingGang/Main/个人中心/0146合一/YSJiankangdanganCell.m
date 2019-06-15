//
//  YSJiankangdanganCell.m
//  jingGang
//
//  Created by 李海 on 2018/9/12.
//  Copyright © 2018年 dengxf_dev. All rights reserved.
//

#import "YSJiankangdanganCell.h"

#import "Masonry.h"
#import "WebDayVC.h"
#import "YSImageConfig.h"
#import "YSThumbnailManager.h"
#define kHealthyMessageCellHeight 100
static NSString *cellId = @"cellId";

@interface YSJiankangdanganCell ()
@property (nonatomic, strong)UIImageView *iconView;
@property (nonatomic, strong)UIImageView *bgView;
@property (nonatomic, strong)UIImageView *inView;
@property (nonatomic, strong)UILabel *title;
@end

@implementation YSJiankangdanganCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}
- (void)setUpUI{
    CGFloat w=ScreenWidth;
    CGFloat h=ScreenWidth/3;
    _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, w-20, h-10)];
    self.contentView.backgroundColor = JGColor(249, 249, 249, 1);
    [self.contentView addSubview:_bgView];
    
    _inView =[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 48, 61)];
    _inView.centerX=_bgView.centerX;
    _inView.y=20;
    [self.contentView addSubview:_inView];
    _title= [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 90, 30)];
    _title.centerX=_bgView.centerX;
    _title.textAlignment=NSTextAlignmentCenter;
    _title.textColor=[UIColor whiteColor];
    _title.y=CGRectGetMaxY(_inView.frame)+5;
    [self.contentView addSubview:_title];
    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, w-20, h-10)];
    _iconView.centerX=_title.centerX;
    _iconView.y=CGRectGetMaxY(_title.frame)+5;
    _iconView.hidden=YES;
    _iconView.image=[UIImage imageNamed:@"ys_personal_newicon"];
    [self.contentView addSubview:_iconView];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setModels:(NSDictionary *)dict{
    if([@"健康数据" isEqualToString:dict[@"title"]]){
        BOOL ret = [[self achieve:@"kDidClickAIOFuctionKey"] boolValue];
        _iconView.hidden = ret;
    }
    _inView.image=[UIImage imageNamed:dict[@"in"]];
    _bgView.image=[UIImage imageNamed:dict[@"bg"]];
    _title.text=dict[@"title"];
}

@end

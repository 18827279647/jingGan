//
//  YQNumberTableViewCell.m
//  jingGang
//
//  Created by whlx on 2019/3/14.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "YQNumberTableViewCell.h"
#import "YSImageConfig.h"
#import "GlobeObject.h"
#import "Masonry.h"

@interface  YQNumberTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *PhotoImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *isXDLaebl;
@property (weak, nonatomic) IBOutlet UILabel *DZLabel;
@property (weak, nonatomic) IBOutlet UILabel *YDLalebl;

@end
@implementation YQNumberTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [super awakeFromNib];
    // Initialization code
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.PhotoImage.mas_right).offset(8);
        make.top.equalTo(self.PhotoImage);
        make.right.equalTo(self.contentView.mas_right).offset(-K_ScaleWidth(400));
    }];
    
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.mas_bottom).offset(8);
        make.left.equalTo(self.name);
        make.size.mas_equalTo(CGSizeMake(300, 15));
    }];
    
    [self.DZLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name.mas_right).offset(10);
        make.top.equalTo(self.name.mas_top);
        //make.size.mas_equalTo(CGSizeMake(K_ScaleWidth(350), 15));
        make.right.equalTo(self.contentView.mas_right).offset(-K_ScaleWidth(40));
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) setUsersModels:(YQNumberModes *)UsersModels
{
    _UsersModels  = UsersModels;
    
   [YSImageConfig sd_view:self.PhotoImage setimageWithURL:[NSURL URLWithString:UsersModels.headImgPath] placeholderImage:[UIImage imageNamed:@"moren.png"]];
    _name.text = UsersModels.nickName;
    _time.text = [NSString stringWithFormat:@"邀请时间:%@",UsersModels.createTime];
    _time.textColor = [UIColor colorWithHexString:@"999999"];
    
    self.isXDLaebl.text = UsersModels.content1;

    if (UsersModels.content2) {
        _YDLalebl.text = [NSString stringWithFormat:@"%@ >",UsersModels.content2];
    }
    
}
- (IBAction)HeadImageClick:(UIButton *)sender {
    
    
    NSString * appid = [NSString stringWithFormat:@"%zd",self.UsersModels.uid];
    [self.deletage YQNumberTableViewCell:self AndNSSrtring:appid];
    
}

@end

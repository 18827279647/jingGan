//
//  PDNumTableViewCell.m
//  jingGang
//
//  Created by whlx on 2019/3/8.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "PDNumTableViewCell.h"
#import "YSImageConfig.h"
#import "YSLoginManager.h"

@implementation PDNumTableViewCell

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
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModels:(PDNumberListModels *)models{
    _models = models;
    NSLog(@"%@",models);
    NSString  * url = [NSString stringWithFormat:@"%@",models.headImgPath];
    [YSImageConfig sd_view:_touxiangOne setimageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"moren"]];

    [self setcountDownCancellabelWithSecond: [models.leftTime integerValue]];
    _orderId = [NSString stringWithFormat:@"%@",models.orderId];
   // _name.text = [NSString stringWithFormat:@"%@",models.nickName];
    
    if (models.nickName.length>5) {

        NSMutableString *String2 = [[NSMutableString alloc] initWithString:models.nickName];
        [String2 replaceCharactersInRange:NSMakeRange(2, 4) withString:@"**"];
        NSLog(@"String1:%@",String2);
        _name.text = String2;
    }else if (models.name.length<5){
        NSMutableString *String1 = [[NSMutableString alloc] initWithString:models.nickName];
        [String1 insertString:@"**" atIndex:1];
        _name.text = String1;
    
    }

    _useid =  [NSString stringWithFormat:@"%@",models.userId];
    
}
- (void)setcountDownCancellabelWithSecond:(NSInteger)second{
    
    self.dateConutDown = [[YSDateConutDown alloc]init];
    [self.dateConutDown beginCountdownWithTotle2:second being2:^(NSString *msg) {
        
        
        if(_istime == YES){
            NSMutableAttributedString *attStrConutDown = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"还差1人 距结束仅剩%@",msg]];
            _time.attributedText = attStrConutDown;
            
        }else{
            NSMutableAttributedString *attStrConutDown = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"剩余%@",msg]];
            _time.attributedText = attStrConutDown;
            
        }
     
 
        
        
    } end2:^{
        
        
    }];
}

- (IBAction)blockOrlid:(UIButton *)sender {
    if (self.change_controllerA_labelTitleBlock) {
        
        self.change_controllerA_labelTitleBlock(_orderId,_useid);
    }
 
}
//TODO: Block Set方法(必写)
- (void)setChange_controllerA_labelTitleBlock:(void (^)(NSString *,NSString *))change_controllerA_labelTitleBlock {
    _change_controllerA_labelTitleBlock = change_controllerA_labelTitleBlock;
}




@end

//
//  RXMotionTableViewCell.m
//  jingGang
//
//  Created by 荣旭 on 2019/6/18.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXMotionTableViewCell.h"
#import "CircleLoader.h"

@interface  RXMotionTableViewCell()
@property (copy , nonatomic) void (^buttonClickCallback)(NSInteger index);
@property (copy , nonatomic)id_block_t clickCallback;

@end

@implementation RXMotionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}
- (void)setFrame:(CGRect)frame{
    frame.origin.x+=20;
    frame.size.width -= 40;
    [super setFrame:frame];
}
-(void)setup;{
        //今日任务步数模块
        @weakify(self);
        if (!weak_self.jrrwView) {
            RXJirirenwubushuView*jrrwView=[[[NSBundle mainBundle]loadNibNamed:@"RXJirirenwubushuView" owner:self options:nil]firstObject];
            jrrwView.frame=CGRectMake(0,0,self.frame.size.width, self.frame.size.height);
            [jrrwView.zhouButton setTitleColor:JGColor(245, 166, 35, 1) forState:UIControlStateNormal];
             [jrrwView.yueButton setTitleColor:JGColor(245, 166, 35, 1) forState:UIControlStateNormal];
             [jrrwView.lishiButton setTitleColor:JGColor(245, 166, 35, 1) forState:UIControlStateNormal];
            [jrrwView.zhouButton setTitleColor:JGColor(245, 166, 35, 1) forState:UIControlStateSelected];
            [jrrwView.yueButton setTitleColor:JGColor(245, 166, 35, 1) forState:UIControlStateSelected];
            [jrrwView.lishiButton setTitleColor:JGColor(245, 166, 35, 1) forState:UIControlStateSelected];
            jrrwView.zhouButton.layer.masksToBounds=YES;
            jrrwView.yueButton.layer.masksToBounds=YES;
            jrrwView.lishiButton.layer.masksToBounds=YES;
            jrrwView.zhouButton.layer.cornerRadius=10;
            jrrwView.yueButton.layer.cornerRadius=10;
            jrrwView.lishiButton.layer.cornerRadius=10;
            
            jrrwView.zhouButton.layer.borderWidth=1;
            jrrwView.yueButton.layer.borderWidth=1;
            jrrwView.lishiButton.layer.borderWidth=1;
            
            jrrwView.zhouButton.layer.borderColor=JGColor(245, 166, 35, 1).CGColor;
            jrrwView.yueButton.layer.borderColor=JGColor(245, 166, 35, 1).CGColor;
            jrrwView.lishiButton.layer.borderColor=JGColor(245, 166, 35, 1).CGColor;
            
            //设置视图大小
            CircleLoader *view=[[CircleLoader alloc]initWithFrame:CGRectMake(jrrwView.naImage.width/2+20,jrrwView.naImage.origin.y,jrrwView.naImage.size.width,jrrwView.naImage.size.height)];
            //设置轨道颜色
            view.trackTintColor=JGColor(204, 240, 236, 1);
            //设置进度条颜色
            view.progressTintColor=JGColor(74, 205, 190, 1);
            //设置轨道宽度
            view.lineWidth=8.0;
            //设置进度
            view.progressValue=0.7;
            //设置是否转到 YES进度不用设置
            view.animationing=NO;
            
            [jrrwView addSubview:view];
            self.jrrwView=jrrwView;
        }else{
            self.jrrwView.frame=CGRectMake(0,0,self.frame.size.width, self.frame.size.height);
        }
        [self addSubview:self.jrrwView];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

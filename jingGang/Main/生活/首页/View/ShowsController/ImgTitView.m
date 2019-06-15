//
//  ImgTitView.h
//  jingGang
//
//  Created by HanZhongchou on 16/8/25.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "ImgTitView.h"
#import "GlobeObject.h"
#import "YSImageConfig.h"

@interface ImgTitView ()

@end

@implementation ImgTitView

- (void)dealloc
{
    self.dictClassInfo = nil;
    
}

- (instancetype)initImageAndTitleViewWith:(CGRect)frame AndClassInfo:(NSDictionary *)dictClassInfo
{
    if (self = [super initWithFrame:frame]) {
        self.dictClassInfo = dictClassInfo;
        [self initImageTitleView];
    }
    return self;
}


- (void)initImageTitleView
{

    CGFloat imageXScale = 375.0 / 27;
    
    
    CGRect Fr = CGRectMake(kScreenWidth/imageXScale , 5, 40, 40);
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:Fr];
    imageV.layer.masksToBounds = YES;
    NSString *strUrl = [NSString stringWithFormat:@"%@",self.dictClassInfo[@"mobileIcon"]];
    [YSImageConfig sd_view:imageV setimageWithURL:[NSURL URLWithString:strUrl] placeholderImage:DEFAULTIMG];
//    imageV.backgroundColor = randomColor;
    CGRect Lfr = CGRectMake(0, CGRectGetMaxY(imageV.frame) + 5, self.width, 18);
    
    UILabel *labelT = [[UILabel alloc]initWithFrame:Lfr];
    labelT.textAlignment = NSTextAlignmentCenter;
    labelT.textColor = UIColorFromRGB(0x4a4a4a);
    labelT.centerX = imageV.centerX;
//    labelT.backgroundColor = randomColor;
    labelT.font = [UIFont systemFontOfSize:13.0];
    labelT.text = [NSString stringWithFormat:@"%@",self.dictClassInfo[@"className"]];
    
    [self addSubview:imageV];
    [self addSubview:labelT];
//    self.backgroundColor = randomColor;
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

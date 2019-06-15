//
//  XRHeandeView.m
//  jingGang
//
//  Created by whlx on 2019/3/15.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "XRHeandeView.h"
@interface XRHeandeView()
@property (strong, nonatomic) IBOutlet XRHeandeView *XRView;

@end
@implementation XRHeandeView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
   
        [[NSBundle mainBundle] loadNibNamed:@"XRHeandeView" owner:self options:nil];
        self.XRView.frame = self.bounds;
        [self addSubview:self.XRView];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
   
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

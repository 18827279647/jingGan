//
//  
//
//
//
//
//

#import "YSCustScrollViewButtonView.h"

#import "GlobeObject.h"

@interface YSCustScrollViewButtonView()
//底部滑动线条
@property (nonatomic, strong) UIView * LineView;
//临时赋值按钮
@property (nonatomic, weak) UIButton * TempButton;

@property (nonatomic, weak) UIView * UpView;
//按钮显示文字数组
@property (nonatomic, strong) NSArray * TitleArray;
//默认按钮颜色
@property (nonatomic, assign) CGFloat FontFloat;

@end



@implementation YSCustScrollViewButtonView

- (instancetype)initWithFrame:(CGRect)frame AndTitleArray:(NSArray *)TitleArray AndFont:(CGFloat)font AndNumber:(NSInteger)number{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.TitleArray = [NSArray array];
        self.TitleArray = TitleArray;
        self.FontFloat = font;
        #pragma 创建多个按钮
        [self GreatButtons];
        #pragma 滑动view
        [self ScrollButtonViewTag:number];
    }
    return self;
}

#pragma 创建多个按钮
- (void)GreatButtons{
    CGFloat width = 0;
    if (self.TitleArray.count >= 5) {
        width =  ScreenWidth / 5;
    }else {
        width =  ScreenWidth / self.TitleArray.count ;
       
    }
    
    
    for (NSInteger i = 0; i < self.TitleArray.count; i++) {
        NSInteger index = i % 5;
        NSInteger page = i / 5;
        
        
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(index * width,page * K_ScaleWidth(87),width,K_ScaleWidth(87))];
        [button setTitle:self.TitleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"65BBB1"] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:self.FontFloat];
        button.tag = i;
        [button addTarget:self action:@selector(Action:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

#pragma 滑动view
- (void)ScrollButtonViewTag:(NSInteger)tag{
    UIButton * button = self.subviews[tag];
    
    UIView * view = [[UIView alloc]init];
    self.LineView = view;
    view.height = 2;
    
    view.backgroundColor = [button titleColorForState: UIControlStateSelected];
    [self addSubview:view];
    
    button.selected = YES;
    self.TempButton = button;
    //计算按钮上的文字自适应大小
    [button.titleLabel sizeToFit];
    self.LineView.width = button.titleLabel.width;
    self.LineView.centerX = button.centerX;
    self.LineView.y = K_ScaleWidth(87);
}


#pragma  按钮滑动事件
- (void)Action:(UIButton *)sender{
    
    self.TempButton.selected = NO;
    sender.selected = YES;
    self.TempButton = sender;
    
    //滑动动画
    [UIView animateWithDuration:0.25 animations:^{
        self.LineView.width = sender.titleLabel.width;
        self.LineView.centerX = sender.centerX;
        if (sender.tag / 5 == 1 ) {
          self.LineView.y = self.height;
        }else {
            self.LineView.y = K_ScaleWidth(87);
        }
        
        
    }];
    
    [self.delegate YSCustScrollViewSelectButton:sender];
}




@end

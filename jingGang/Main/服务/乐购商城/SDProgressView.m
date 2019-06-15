//
//  SDProcessView.m
//  process
//
//  Created by xialan on 2018/12/24.
//  Copyright © 2018 HARAM. All rights reserved.
//

#import "SDProgressView.h"

//默认宽度
#define KWidth 140
//默认高度
#define KHeight 14


@interface SDProgressView()

/** 进度条 */
@property (nonatomic, strong) UIView *progressView;





@end

@implementation SDProgressView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, KWidth, KHeight);
        
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1.0f;
         self.layer.cornerRadius = 8;
        self.backgroundColor = [UIColor clearColor];
        
        _progressView = [[UIView alloc] init];
        _progressView.backgroundColor = [UIColor whiteColor];
        
            _progressView.layer.cornerRadius = 8;
        [self addSubview:_progressView];
        
        //分割线
        _sepLabel = [[UILabel alloc] init];
        _sepLabel.font = [UIFont systemFontOfSize:9];
        _sepLabel.textColor = [UIColor whiteColor];
        _sepLabel.text = @"/";
        [_sepLabel sizeToFit];
        [self addSubview:_sepLabel];
        
        
        //当前数字
        _currentLabel = [[UILabel alloc] init];
        _currentLabel.font = [UIFont systemFontOfSize:9];
        _currentLabel.textColor = [UIColor whiteColor];
        _currentLabel.textAlignment = NSTextAlignmentCenter;
        _currentLabel.text = @"0";
        [self addSubview:_currentLabel];
        
        //总数
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.font = [UIFont systemFontOfSize:9];
        _totalLabel.textColor = [UIColor whiteColor];
        _totalLabel.text = @"0";
        [self addSubview:_totalLabel];
        
        
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat sep_w = [self getWidthWithText:_sepLabel.text font:_sepLabel.font];
    CGFloat sep_h = [self getHeightWithText:_sepLabel.text width:sep_w font:_sepLabel.font];
    CGFloat sep_x = (self.frame.size.width - sep_w) * 0.5;
    CGFloat sep_y = (self.frame.size.height - sep_h) * 0.5;
    _sepLabel.frame = CGRectMake(sep_x, sep_y, sep_w, sep_h);
    
    CGFloat current_w = self.width - 20;
    CGFloat current_h = [self getHeightWithText:_currentLabel.text width:current_w font:_currentLabel.font];
    CGFloat current_x = self.sepLabel.frame.origin.x - current_w;
    CGFloat current_y = (self.frame.size.height - current_h) * 0.5;
    _currentLabel.frame = CGRectMake(current_x, current_y, current_w, current_h);
    [_currentLabel centerHorizontally];
    
    CGFloat total_w = [self getWidthWithText:_totalLabel.text font:_totalLabel.font];
    CGFloat total_h = [self getHeightWithText:_totalLabel.text width:total_w font:_totalLabel.font];
    CGFloat total_x = CGRectGetMaxX(self.sepLabel.frame);
    CGFloat total_y = (self.frame.size.height - total_h) * 0.5;
    _totalLabel.frame = CGRectMake(total_x, total_y, total_w, total_h);
    
    self.progressView.frame = CGRectMake(0, 0, self.frame.size.width*self.progress, self.frame.size.height);
    
}


#pragma mark - 外部调用

/**
 更新界面
 @param currentNumber 当前进度
 @param totalNumber 总量
 */
-(void)updateWithCurrentNumber:(CGFloat)currentNumber total:(CGFloat)totalNumber{
    
    if (currentNumber > totalNumber) {
        currentNumber = totalNumber;
       
        NSException *exception = [[NSException alloc] initWithName:@"当前进度越界" reason:@"当前进度数量大于总数,请核对!" userInfo:nil];
        NSLog(@"当前进度数量大于总数,请核对!");
         @throw exception;
        
    }
    
    if (currentNumber < 0) {
        currentNumber = 0;
        NSLog(@"当前进度小于0");
    }
    
    
    _progress = currentNumber / totalNumber;
    
    _currentLabel.text = @(currentNumber).description;
    _totalLabel.text = @(totalNumber).description;
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.progressView.frame = CGRectMake(0, 0, self.frame.size.width * weakSelf.progress, self.frame.size.height);
    } completion:^(BOOL finished) {
        
        CGFloat x = self.frame.size.width * weakSelf.progress;
        if (x > weakSelf.currentLabel.frame.origin.x && x <= CGRectGetMaxX(weakSelf.currentLabel.frame)) {
            
            weakSelf.currentLabel.textColor = [UIColor blackColor];
        }else if(x > weakSelf.sepLabel.frame.origin.x && x <= CGRectGetMaxX(weakSelf.sepLabel.frame)){
            
            weakSelf.currentLabel.textColor = [UIColor blackColor];
            weakSelf.sepLabel.textColor = [UIColor blackColor];
            
        }else if(x > weakSelf.totalLabel.frame.origin.x && CGRectGetMaxX(weakSelf.totalLabel.frame)){
            
            weakSelf.currentLabel.textColor = [UIColor blackColor];
            weakSelf.sepLabel.textColor = [UIColor blackColor];
            weakSelf.totalLabel.textColor = [UIColor blackColor];
        }
        
        
    }];
    
    [self layoutSubviews];
}


#pragma mark - 内部方法
//计算宽度
-(CGFloat)getWidthWithText:(NSString *)text font:(UIFont *)font{
    
   return [text sizeWithAttributes:@{NSFontAttributeName:font}].width;
}
//计算高度
-(CGFloat)getHeightWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font{
    
    return [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.height;
    
}

#pragma mark - 赋值
-(void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    
    self.layer.borderColor = borderColor.CGColor;
    
}
-(void)setBorderWidth:(CGFloat)borderWidth{
    _borderWidth = borderWidth;
    
    self.layer.borderWidth = borderWidth;
}
-(void)setProcessColor:(UIColor *)processColor{
    _processColor = processColor;
    self.progressView.backgroundColor = processColor;
}

@end

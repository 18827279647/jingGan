//
//  
//
//
//
//
//

#import <UIKit/UIKit.h>

@class YSCustScrollViewButtonView;

@protocol YSCustScrollViewButtonViewDelegate <NSObject>

//选中的按钮
- (void)YSCustScrollViewSelectButton:(UIButton *)sender;

@end

@interface YSCustScrollViewButtonView : UIView

/*
 * 设置代理人
 */
@property (nonatomic, weak) id<YSCustScrollViewButtonViewDelegate> delegate;

/*
 * 初始化view
 */
- (instancetype)initWithFrame:(CGRect)frame AndTitleArray:(NSArray *)TitleArray AndFont:(CGFloat)font AndNumber:(NSInteger)number;



@end

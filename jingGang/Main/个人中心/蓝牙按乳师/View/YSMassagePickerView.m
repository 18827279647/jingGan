//
//  YSMassagePickerView.m
//  jingGang
//
//  Created by dengxf on 17/6/28.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSMassagePickerView.h"
#import "AKPickerView.h"
#import "MDFAnimation.h"

@interface YSMassagePickerView ()<AKPickerViewDataSource, AKPickerViewDelegate>

@property (strong,nonatomic) UILabel *titleLab;
@property (strong,nonatomic) UILabel *selectedTitleLab;
@property (strong,nonatomic) AKPickerView *pickerView;
@property (nonatomic, strong) NSArray *titles;
@property (strong,nonatomic) UIView *currentSelectedView;
@property (assign, nonatomic) NSInteger currenItemIndex;


@end

@implementation YSMassagePickerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self buildTitleLab];
    [self buildSelectedTitleLab];
    [self buildPickerView];
    [self buildPickerView];
    [self buildCurrentSelectedView];
}

- (void)buildCurrentSelectedView {
    CGFloat selectedViewW = 2.6;
    CGFloat selectedViewH = self.pickerView.height * 0.5;
    CGFloat selectedX = (self.width - selectedViewW) / 2 + 1.2;
    CGFloat selectedY = self.pickerView.y;
    if (self.currentSelectedView) {
        self.currentSelectedView.frame = CGRectMake(selectedX, selectedY, selectedViewW, selectedViewH);
    }else {
        UIView *currentSelectedView = [UIView new];
        currentSelectedView.backgroundColor = JGColor(253, 184, 43, 1);
        currentSelectedView.frame = CGRectMake(selectedX, selectedY, selectedViewW, selectedViewH);
        currentSelectedView.layer.cornerRadius = 0.8;
        [self addSubview:currentSelectedView];
        self.currentSelectedView = currentSelectedView;
    }
}

- (void)buildTitleLab {
    CGFloat titleLabx = 0;
    CGFloat titleLabw = self.width;
    CGFloat titleLabh = 17;
    CGFloat titleLaby = 0.;
    if (self.titleLab) {
        self.titleLab.frame = CGRectMake(titleLabx, titleLaby, titleLabw, titleLabh);
    }else {
        UILabel *titleLab = [self buildLabWithFrame:CGRectMake(titleLabx, titleLaby, titleLabw, titleLabh) text:@"" textColor:[UIColor colorWithHexString:@"#ffffff" alpha:0.65] font:JGRegularFont(14) textAlignment:NSTextAlignmentCenter];
        [self addSubview:titleLab];
        self.titleLab = titleLab;
    }
    self.titleLab.text = self.titleText;
}

- (void)buildSelectedTitleLab {
    CGFloat selectedTitleLabx = 0;
    CGFloat selectedTitleLaby = MaxY(self.titleLab) + 6;
    CGFloat selectedTitleLabw = self.width;
    CGFloat selectedTitleLabh = 24.;
    if (self.selectedTitleLab) {
        self.selectedTitleLab.frame = CGRectMake(selectedTitleLabx, selectedTitleLaby, selectedTitleLabw, selectedTitleLabh);
    }else {
        UILabel *selectedTitleLab = [self buildLabWithFrame:CGRectMake(selectedTitleLabx, selectedTitleLaby, selectedTitleLabw, selectedTitleLabh) text:@"" textColor:[UIColor colorWithHexString:@"#ffffff" alpha:1] font:JGRegularFont(24) textAlignment:NSTextAlignmentCenter];
        [self addSubview:selectedTitleLab];
        self.selectedTitleLab = selectedTitleLab;
    }
    self.selectedTitleLab.text = [NSString stringWithFormat:@"%@%@",self.selectedTitleText,self.unit];
}

- (void)buildPickerView {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSInteger i = 0; i < self.dialCount; i ++) {
        [tempArray addObject:@"qwertyuio"];
    }
    self.titles = [tempArray copy];
    CGFloat pickerViewx = [YSAdaptiveFrameConfig width:18.];
    CGFloat pickerViewy = MaxY(self.selectedTitleLab) + 12;
    CGFloat pickerVieww = self.width - pickerViewx * 2;
    CGFloat pickerViewh = 78.;
    if (self.pickerView) {
        self.pickerView.frame = CGRectMake(pickerViewx, pickerViewy, pickerVieww, pickerViewh);
    }else {
        AKPickerView *pickerView = [[AKPickerView alloc] initWithFrame:CGRectMake(pickerViewx, pickerViewy, pickerVieww, pickerViewh)];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        pickerView.interitemSpacing = -0.1;
        pickerView.pickerViewStyle = AKPickerViewStyleFlat;
        pickerView.maskDisabled = NO;
        pickerView.markCount = 7;
        pickerView.shouldAutoScrollAnimate = self.shouldAutoScrollAnimate;
        if (self.defaultItem) {
            [pickerView selectItem:(self.defaultItem - 1) animated:NO];
        }
        [self addSubview:pickerView];
        self.pickerView = pickerView;
    }
    [self.pickerView reloadData];
}

- (UILabel *)buildLabWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment
{
    UILabel *label = [UILabel new];
    label.frame = frame;
    label.text = text;
    label.textColor = textColor;
    label.font = font;
    label.textAlignment = textAlignment;
    return label;
}

#pragma mark - AKPickerViewDataSource

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
{
    return [self.titles count];
}

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item
{
    return self.titles[item];
}

#pragma mark - AKPickerViewDelegate
- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"" object:nil];
    self.currenItemIndex = item + 1;
    if ([self.delegate respondsToSelector:@selector(pickerView:selectedItem:)]) {
        [self.delegate pickerView:self selectedItem:item];
    }
    self.selectedTitleLab.text = [NSString stringWithFormat:@"%ld%@",item + 1,self.unit];
    if (!self.currentSelectedView.alpha) {
        CAAnimation *showAnimation = [MDFAnimation mdf_animationWithAppearType:MDFAnimationTypePop];
        [self.currentSelectedView.layer addAnimation:showAnimation forKey:@"showA"];
    }
}

- (void)pickerViewDidScroll:(AKPickerView *)pickerView {
    if (self.currentSelectedView.alpha == 0) {
        return;
    }else {
        CAAnimation *hiddenAnimation = [MDFAnimation mdf_animationWithDisappearType:MDFAnimationTypeFadeOut];
        [self.currentSelectedView.layer addAnimation:hiddenAnimation forKey:@"hiddenA"];
    }
}


@end

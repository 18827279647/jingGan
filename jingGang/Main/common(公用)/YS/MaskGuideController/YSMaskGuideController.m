//
//  YSMaskGuideController.m
//  jingGang
//
//  Created by dengxf on 16/9/10.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "YSMaskGuideController.h"
#import "GlobeObject.h"

@interface YSMaskGuideController ()

@property (strong,nonatomic) UIImageView *imageView;
@property (assign, nonatomic) NSInteger currentImageIndex;

@end

@implementation YSMaskGuideController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"ys_maskguide_01"];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    self.imageView = imageView;
    self.currentImageIndex = 1;
    @weakify(self);
    [self.imageView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        @strongify(self);
        self.currentImageIndex += 1;
        if (self.currentImageIndex == 6) {
            BLOCK_EXEC(self.dismiss);
        }
        NSString *imageName;
        if (iPhone4 || iPhone5) {
            imageName = [NSString stringWithFormat:@"ys_maskguide_samll_0%zd",self.currentImageIndex];
            if (self.currentImageIndex == 5) {
                imageName = [NSString stringWithFormat:@"ys_maskguide_0%zd",self.currentImageIndex];
            }
        }else {
            imageName = [NSString stringWithFormat:@"ys_maskguide_0%zd",self.currentImageIndex];
        }
        self.imageView.image = [UIImage imageNamed:imageName];
    }];
}

@end

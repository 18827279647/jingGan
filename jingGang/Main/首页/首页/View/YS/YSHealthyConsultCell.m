//
//  YSHealthyConsultCell.m
//  jingGang
//
//  Created by dengxf on 17/5/10.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSHealthyConsultCell.h"
#import "XFLayerCornerRadiusTools.h"

#define kHealthyConsultCacheHeightKey @"kHealthyConsultCacheHeightKey"

@interface YSHealthyConsultCell ()

@property (copy , nonatomic) voidCallback consultCallback;
@property (strong,nonatomic) UIImageView *consultImageView;

@end

@implementation YSHealthyConsultCell

+ (instancetype)setupWithTableView:(UITableView *)tableView consultCallback:(voidCallback)consullt
{
    static NSString *identifierCell = @"YSHealthyConsultCell";
    YSHealthyConsultCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    if (!cell) {
        cell = [[YSHealthyConsultCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifierCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.consultCallback = consullt;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setConsultImage:(UIImage *)consultImage {
    _consultImage = consultImage;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.consultImageView.height = ((ScreenWidth * consultImage.size.height ) / consultImage.size.width);
        self.consultImageView.image = consultImage;
        [self save:[NSNumber numberWithFloat:self.consultImageView.height] key:kHealthyConsultCacheHeightKey];
    });
}

- (void)setup {
    CGFloat imageMargin = 12.0;
    UIImageView *consultImageView = [UIImageView new];
    consultImageView.x = imageMargin;
    consultImageView.y = imageMargin;
    consultImageView.width = ScreenWidth - consultImageView.x * 2;
    if ([self achieve:kHealthyConsultCacheHeightKey]) {
        consultImageView.height = [[self achieve:kHealthyConsultCacheHeightKey] floatValue] - consultImageView.y * 2;
    }else {
        consultImageView.height = self.height - consultImageView.y * 2;
    }
    [consultImageView setImage:[UIImage imageNamed:@"ys_healthymanager_counsult_default"]];
    consultImageView.userInteractionEnabled = YES;
    consultImageView.layer.cornerRadius = 4.;
    consultImageView.contentMode = UIViewContentModeScaleAspectFit;
    @weakify(self);
    [consultImageView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        @strongify(self);
        BLOCK_EXEC(self.consultCallback);
    }];
    consultImageView.clipsToBounds = YES;
    [self.contentView addSubview:consultImageView];
    self.consultImageView = consultImageView;
}

- (void)consultButtonClick:(UIButton *)button {
    BLOCK_EXEC(self.consultCallback);
}

@end

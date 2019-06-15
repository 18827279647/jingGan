//
//  YSSharePreviewView.m
//  jingGang
//
//  Created by Eric Wu on 2019/6/5.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "YSSharePreviewView.h"

@implementation YSSharePreviewView

+ (instancetype)sharePreviewView
{
    NSArray *nib = [CRBundle loadNibNamed:@"YSSharePreviewView" owner:self options:nil];
    UIView *tmpCustomView = [nib objectAtIndex:0];
    return (YSSharePreviewView *)tmpCustomView;
}
- (void)setModel:(GoodsDetailsModel *)model
{
    _model = model;
    NSString *imageUrl = model.goodsMainPhotoPath;
    if (CRIsNullOrEmpty(imageUrl)) {
        imageUrl = model.goodsPhotosList.firstObject;
    }
    //解决sdwebimage 不能加载Http图片问题
//    NSString *userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
//
//    if (userAgent) {
//
//        if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
//            NSMutableString *mutableUserAgent = [userAgent mutableCopy];
//            if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
//                userAgent = mutableUserAgent;
//            }
//        }
//        [[SDWebImageDownloader sharedDownloader] setValue:userAgent forHTTPHeaderField:@"User-Agent"];
//
//    }
    [self.commodityImage sd_setImageWithURL:CRURL(imageUrl) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    self.lblName.text = model.goodsName;
//    self.couponView.hidden = model.
    NSMutableAttributedString *priceAttr = [[NSMutableAttributedString alloc] initWithString:@"¥"
                                                                                  attributes:@{NSFontAttributeName: kPingFang_Regular(18),
                                                                                               NSForegroundColorAttributeName: UIColorHex(65BBB1)}];
    [priceAttr appendAttributedString:[[NSAttributedString alloc] initWithString:CRString(@"%.02f", [model.goodsCurrentPrice floatValue])
                                                                      attributes:@{NSFontAttributeName: kPingFang_Medium(33),
                                                                                   NSForegroundColorAttributeName: UIColorHex(65BBB1)}]];
    NSMutableAttributedString *goodsPrice = [[NSMutableAttributedString alloc] initWithString:CRString(@"¥%.02f", [model.goodsPrice floatValue]) attributes:@{NSFontAttributeName: kPingFang_Regular(12),
                                                                                                                               NSForegroundColorAttributeName: UIColorHex(999999)}];
    goodsPrice.strikethroughStyle = NSUnderlineStyleSingle;
    goodsPrice.strikethroughColor = UIColorHex(999999);
    [priceAttr appendAttributedString:goodsPrice];
    self.lblPrice.attributedText = priceAttr;
    self.couponView.hidden = model.couponList.count == 0;
    if (!self.couponView.hidden) {
        NSDictionary *coupon = model.couponList.firstObject;
        self.lblCoupon.text = CRString(@"满%ld减%ld", (long)[coupon[@"couponOrderAmount"] integerValue], (long)[coupon[@"couponAmount"] integerValue]);
    }
//    NSString *url = kGoodsShareUrlWithID(self.goodsId,dictUserInfo[@"invitationCode"]);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}
@end

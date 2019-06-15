//
//  HappyShoppingCollectionView.m
//  jingGang
//
//  Created by 张康健 on 15/11/21.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import "HappyShoppingCollectionView.h"
#import "HappyShoppingSecondSectionHeaderView.h"
#import "HasyouLikeCollecionCell.h"
#import "AdRecommendModel.h"
#import "GlobeObject.h"
#import "SHKJGuessyouLikeCollectionCell.h"
#import "YSLoginManager.h"
#import "YSImageConfig.h"
#import "YSThumbnailManager.h"
#import "GlobeObject.h"
#import "YSAdaptiveFrameConfig.h"
#import "PublicInfo.h"
#import "YSAdContentItem.h"
@interface HappyShoppingCollectionView(){

    NSDictionary *_sectionHeaderDataDic;

}

@property (assign, nonatomic) BOOL showAdertView;
@property (assign, nonatomic) BOOL showAdLiquorDomainView;

@end

@implementation HappyShoppingCollectionView

static NSString *HappyShoppingFirstSectionHeaderID = @"HappyShoppingFirstSectionHeaderID";
static NSString *HasyouLikeCollecionCellID = @"HasyouLikeCollecionCellID";
static NSString *GuessyouLikeCollectionCellID= @"GuessyouLikeCollectionCellID";
static NSString *HappyShoppingSecondSectionHeaderID = @"HappyShoppingSecondSectionHeaderID";

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _init];
    }
    return self;
}

-(void)_init{
    //更换商城图片
    
    self.dataSource = self;
    self.delegate = self;
    _sectionHeaderDataDic = @{kPerfictGoodsRecommendKey:@{@"firstImgName":@"has_you_like",@"itemName":@"为你推荐",@"secondImgName":@"youKown",@"itemColor":UIColorFromRGB(0x4a4a4a)},
                              kHasYoulikeGoodsKey:@{@"firstImgName":@"KEAIDE",@"itemName":@"猜你喜欢",@"secondImgName":@"新发现---Assistor",@"itemColor":UIColorFromRGB(0x4a4a4a)}};


//    self.dataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    self.dataDic = [NSMutableDictionary dictionaryWithDictionary:@{kPerfictGoodsRecommendKey:@[],kHasYoulikeGoodsKey:@[]}];
//    NSArray *deafaultArr = [NSArray array];
//    [self.dataDic setObject:deafaultArr forKey:kHeaderKey];
    [self registerNib:[UINib nibWithNibName:@"HappyShoppingFirstSectionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HappyShoppingFirstSectionHeaderID];
    
    [self registerNib:[UINib nibWithNibName:@"HasyouLikeCollecionCell" bundle:nil] forCellWithReuseIdentifier:HasyouLikeCollecionCellID];
    [self registerNib:[UINib nibWithNibName:@"SHKJGuessyouLikeCollectionCell" bundle:nil] forCellWithReuseIdentifier:GuessyouLikeCollectionCellID];
    
    [self registerNib:[UINib nibWithNibName:@"HappyShoppingSecondSectionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HappyShoppingSecondSectionHeaderID];
}

- (void)backtoTop {

    [UIView animateWithDuration:0.37 animations:^{

        [self setContentOffset:CGPointMake(0, 0)];

    }];
}

- (void)reloadCollectionViewShouldShowAdvertView:(BOOL)show {
    self.showAdertView = show;
    [self reloadData];
}

#pragma mark ----------------------- data source -----------------------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.dataDic.allKeys.count + 1 ;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else{
        NSString *key = self.dataDic.allKeys[section-1];
        NSArray *arr = self.dataDic[key];
        return arr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section >=1 ) {
        NSString *key = self.dataDic.allKeys[indexPath.section-1];
        NSArray *arr = self.dataDic[key];
        if ([key isEqualToString:kPerfictGoodsRecommendKey]) {//精选商品对应的数据源key
            HasyouLikeCollecionCell *cell = [self dequeueReusableCellWithReuseIdentifier:HasyouLikeCollecionCellID forIndexPath:indexPath];
            AdRecommendModel *model = arr[indexPath.row];
            
            NSInteger hasMobilePrice = [model.hasMobilePrice integerValue];
            NSString *strPrice = @"¥";
            if (hasMobilePrice == 0) {
                strPrice = [NSString stringWithFormat:@"¥%.2f",[model.goodsCurrentPrice floatValue]];
            }else{
                strPrice = [NSString stringWithFormat:@"¥%.2f",[model.goodsMobilePrice floatValue]];
            }
            
            cell.labelGoodsName.text = [NSString stringWithFormat:@"%@",model.adTitle];
            cell.indexPath = indexPath;
            
            //是卷皮商品同时也是团购商品才要显示拼省图标
            if (model.isJuanpi.boolValue && model.isTuangou.boolValue) {
                cell.juanPiGroupLabelWidth.constant = 24.0;
                cell.juanPiGroupLabelWithPriceLabelSpace.constant = 5.0;
                strPrice = [NSString stringWithFormat:@"¥%.2f",[model.tuanCprice floatValue]];
            }else{
                cell.juanPiGroupLabelWidth.constant = 0.0;
                cell.juanPiGroupLabelWithPriceLabelSpace.constant = 0.0;
            }
            NSMutableAttributedString *attrStrPrice = [[NSMutableAttributedString alloc]initWithString:strPrice];
            
            [attrStrPrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 1)];
            
            cell.labelPrice.attributedText = attrStrPrice;
            
            NSString *newStr = model.adImgPath;
            if (!model.isJuanpi.boolValue) {
                newStr = [YSThumbnailManager shopCompetitiveRecommondPicUrlString:newStr];
            }
            [YSImageConfig sd_view:cell.hasYouLikeImgView setimageWithURL:[NSURL URLWithString:newStr] placeholderImage:DEFAULTIMG];
            
            
            return cell;
        }else if ([key isEqualToString:kHasYoulikeGoodsKey]){//有您喜欢对应的key
            SHKJGuessyouLikeCollectionCell *cell = [self dequeueReusableCellWithReuseIdentifier:GuessyouLikeCollectionCellID forIndexPath:indexPath];
            cell.indexPath = indexPath;
            NSDictionary *dict = arr[indexPath.row];
            [cell setGuessYouLikeData:dict];
            return cell;
        }

    }
    
    
    return nil;
}

#pragma mark ----------------------- header reuse Method -----------------------
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        if (indexPath.section == 0) {
            HappyShoppingFirstSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HappyShoppingFirstSectionHeaderID forIndexPath:indexPath];
            reusableview = headerView;
            reusableview.height = [self sectionOneHeight];
            headerView.nav = self.inputViewController.navigationController;
            self.headerView = headerView;
            
        }else{
        
            HappyShoppingSecondSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HappyShoppingSecondSectionHeaderID forIndexPath:indexPath];
            NSString *key = self.dataDic.allKeys[indexPath.section-1];
            NSDictionary *dic = _sectionHeaderDataDic[key];
//            UIImage *image = [UIImage imageNamed:dic[@"firstImgName"]];
////            headerView.sectionIconImgView.image = image;
//            if (image.size.width == 0 ||image.size.height ) {
//
//            }else {
//
//            }
            headerView.sectionTitlLabel.text = dic[@"itemName"];
            headerView.sectionTitlLabel.textColor =kGetColor(93,187,177);
            headerView.indexPath = indexPath;
            
            reusableview = headerView;
            
            
        }
    }
    
    
      return reusableview;
}

- (CGFloat)getBannerClassViewHeightWithHeight:(CGFloat)height{
    if (self.headerView.isNoNeedPagination) {
        //小于等于8个分类的情况下
        if (iPhone6 || iPhone5) {
            height = height - 15.0;
        }else if (iPhone6p){
            height = height - 16.0;
        }
        //4个分的情况下
        if (self.headerView.isFourClass) {
            if (iPhone6p) {
                height = height - 75;
            }else if(iPhone6 || iPhone5){
                height = height - 76;
            }
        }
    }
    return height;
}

- (CGFloat)getCloudBuyMoneyViewHeightWithHeight:(CGFloat)height{
    //是登陆状态下要显示出云购币专区入口，同时要把这个collectionView的高度下移
    CGFloat cloudBuyMoneyHeight = 0.0;
    if (!IsEmpty([YSLoginManager queryAccessToken])) {
        cloudBuyMoneyHeight = kScreenWidth/(375.0/180.0);
        cloudBuyMoneyHeight = cloudBuyMoneyHeight + 1;
    }else{
        if (iPhone6p || iPhone6) {
            cloudBuyMoneyHeight = 1.0;
        }
    }
    height = height + cloudBuyMoneyHeight;
    return height;
}

- (CGFloat)getAdertViewHeightWithHeight:(CGFloat)height{
    if (self.showAdertView) {
        height = height + self.headerView.adContentItem.adTotleHeight;
        if (iPhone6) {
            height = height - 3;
        }else if (iPhone5){
            height = height - 2;
        }else if (iPhone6p){
            height = height - 5;
        }
    }else{
        if (iPhone6) {
            height = height - 9;
        }else if (iPhone5){
            height = height - 7;
        }else if (iPhone6p){
            height = height - 11;
        }
    }
    return height;
}


- (CGFloat)sectionOneHeight {
    //默认6的高度
    CGFloat height = 101;
    if (iPhone5) {
        height = 76;
    }else if (iPhone6p){
        height = 123;
    }else if(iPhone6){
        height = 128;
    }
    
    height = [self getBannerClassViewHeightWithHeight:height];
   
//    height = [self getCloudBuyMoneyViewHeightWithHeight:height];
    
    height = [self getAdertViewHeightWithHeight:height];
    
    height = height + 4;
    
    return (height + kScreenWidth/5 + kScreenWidth/2);
}

#pragma mark ----------------------- 布局的 -----------------------
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {

        return  CGSizeMake(375,[self sectionOneHeight]);
    }else if (section == 1){
        return CGSizeMake(kScreenWidth, 48);
    }
    return CGSizeMake(kScreenWidth, 54);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat scaleHeight = 375.0/248.0;

    return CGSizeMake(kScreenWidth / 2, kScreenWidth/scaleHeight);

}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
        return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *key = self.dataDic.allKeys[indexPath.section-1];
    NSArray *arr = self.dataDic[key];
    NSNumber *clickID = nil;
    NSNumber *isJuanPiGood = nil;
    NSString *strJuanPiUrl = nil;
    if (indexPath.section == 1) {//精品推荐点击
        AdRecommendModel *model = arr[indexPath.row];
        
        clickID = @(model.itemId.integerValue);
        isJuanPiGood = model.isJuanpi;
        strJuanPiUrl = model.targetUrlM;
    }else if (indexPath.section == 2){//有您喜欢点击
        NSDictionary *dict = arr[indexPath.row];
        clickID = (NSNumber *)dict[@"id"];
        isJuanPiGood = (NSNumber *)dict[@"isJuanpi"];
        strJuanPiUrl =  [NSString stringWithFormat:@"%@",dict[@"targetUrlM"]];
    }
    if (self.clickItemBlcok) {
        self.clickItemBlcok(clickID,indexPath,isJuanPiGood,strJuanPiUrl);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [kNotification postNotificationName:@"kCollectionViewContentOffset" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:self.contentOffset.y],@"contentOffsetY", nil]];
}






@end

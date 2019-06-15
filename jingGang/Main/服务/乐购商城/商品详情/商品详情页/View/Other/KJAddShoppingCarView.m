//
//  KJAddShoppingCarView.m
//  jingGang
//
//  Created by 张康健 on 15/8/9.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "KJAddShoppingCarView.h"
#import "GlobeObject.h"
#import "KJShoppingAlertView.h"
#import "Masonry.h"
#import "GoodsSquModel.h"
#import "Util.h"
#import "YSImageConfig.h"
#import "YSThumbnailManager.h"
#import "KYPhotoBrowserController.h"
#import "CKPhoteViewController.h"

typedef enum : NSUInteger {
    MakeSureType,
    AddshopingCartType,
    BuyNowType,
} ActionType;

@implementation KJAddShoppingCarView
-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self _init];
    
    //选择属性通知
    [kNotification addObserver:self selector:@selector(observeGoodsPropertySelect:) name:selectGoodsCationPropertyNotification object:nil];
    
    //改变数量通知
    [kNotification addObserver:self selector:@selector(observeGoodsCount:) name:changeGoodsCountNotification object:nil];
    
}

+(id)showCartViewInContentView:(UIView *)contentView
{
    
    KJAddShoppingCarView *addShoppingCarView = BoundNibView(@"KJAddShoppingCarView", KJAddShoppingCarView);
    [contentView addSubview:addShoppingCarView];
    
    [addShoppingCarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(contentView);
    }];
    
    return addShoppingCarView;
}

-(void)startShow {
    
    [self performSelector:@selector(beginAnimation) withObject:nil afterDelay:0.1];
}

-(void)endShowAfterSeconds:(NSInteger)seconds {
    
  [self performSelector:@selector(endAnimation) withObject:nil afterDelay:seconds];
}

-(void)beginAnimation {
    
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.shoppingCarViewToBottonContraint.constant = 0;
        [self layoutIfNeeded];

    }];
}


-(void)endAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        self.shoppingCarViewToBottonContraint.constant = -self.addShoppingCarViewHeightConstraint.constant-50;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self endAnimation];
    
}


-(void)_init{
    _buyCount = 1;
    self.goodsKindSelectTableView.tableFooterView = [UIView new];
  
    if (_pdZhuangtai == 1) {
         self.goodsKindSelectTableView.isPD = 1;
    }else{
        self.goodsKindSelectTableView.isPD = 0;
    }
    NSLog(@"self.goodsKindSelectTableView.isPD%d",_pdZhuangtai);
    self.addShoppingCarViewHeightConstraint.constant = (430.0/iPhone6_Height) * kScreenHeight;
//    self.goodsImgView.layer.masksToBounds = YES;

    self.priceLabel.textColor = kGetColor(101,197,177);
//    self.onlyQueDingButton.backgroundColor = UIColorFromRGB(0xFF7A00);
    //初始化底部约束
    self.shoppingCarViewToBottonContraint.constant = -self.addShoppingCarViewHeightConstraint.constant - 50;
    
    if (self.ispresentedBySelectedGoodsCation) {//从选择商品属性进来
        self.addShoppingCartButton.hidden = NO;
        self.buyNowButton.hidden = NO;
    }
}

-(void)setIspresentedBySelectedGoodsCation:(BOOL)ispresentedBySelectedGoodsCation{
    _ispresentedBySelectedGoodsCation = ispresentedBySelectedGoodsCation;
    if (_ispresentedBySelectedGoodsCation) {//从选择商品属性进来
        self.addShoppingCartButton.hidden = NO;
        self.buyNowButton.hidden = NO;
    }else{
        self.addShoppingCartButton.hidden = YES;
        self.buyNowButton.hidden = YES;
    }
}


#pragma mark - setter Method
/*
-(void)setGoodsCationPropertyDic:(NSDictionary *)goodsCationPropertyDic{
    //初始化字典
    _goodsCationPropertyDic = goodsCationPropertyDic;
    self.goodsKindSelectTableView.cationPropertyDic = _goodsCationPropertyDic;
    [self.goodsKindSelectTableView reloadData];
    
    //初始化选择字典
    _selectGoodsCationPropertyDic = [NSMutableDictionary dictionaryWithCapacity:_goodsCationPropertyDic.count];
    for (NSString *key in _goodsCationPropertyDic.allKeys) {
        
        if (!_selectGoodsCationPropertyDic[key]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic setObject:@0 forKey:@"open"];
            [_selectGoodsCationPropertyDic setObject:dic forKey:key];
        }
        
    }
    
    
}
*/
#pragma mark - MD
-(void)setDataHander:(AddShoppingCartViewDataInoutHander *)dataHander{
    _dataHander = dataHander;
    
    //初始化字典
    _goodsCationPropertyDic = dataHander.cationPropertyMutableDic;
    self.goodsKindSelectTableView.cationPropertyDic = _goodsCationPropertyDic;
    [self.goodsKindSelectTableView reloadData];
    
    //给UI赋值
    CGFloat actualPrice = 0.0;
    if ([dataHander.goodsDetailModel.hasMobilePrice integerValue]== 1) {
        actualPrice = [dataHander.goodsDetailModel.mobilePrice floatValue];
    }else{
        actualPrice = [dataHander.goodsDetailModel.goodsShowPrice floatValue];
    }
    NSMutableAttributedString *attPriceStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %.2f",actualPrice]];
    [attPriceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 1)];
    self.priceLabel.attributedText = attPriceStr;
    
    NSString *goodsImageUrl = [YSThumbnailManager shopGoodsDetailAddShoppingCarViewGoodPicUrlString:dataHander.goodsDetailModel.goodsMainPhotoPath];
    
    [YSImageConfig yy_view:self.goodsImgView setImageWithURL:[NSURL URLWithString:goodsImageUrl] placeholderImage:DEFAULTIMG];
    
    
    
    self.goodsImgView .userInteractionEnabled = YES;//打开用户交互
    //初始化一个手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.goodsImgView addGestureRecognizer:singleTap];


    
    //goodsInventory
    self.goodsStockLabel.text = [NSString stringWithFormat:@"库存：%ld",dataHander.goodsDetailModel.goodsInventory.integerValue];
    //发送库存通知
//    [kNotification postNotificationName:goodsStockChangeNotification object:dataHander.goodsDetailModel.goodsInventory];
    self.goodsKindSelectTableView.goodsStockCount = dataHander.goodsDetailModel.goodsInventory.integerValue;
    NSString *cationNameStr = self.dataHander.goodsDetailModel.cationNameStr;
    if (![cationNameStr isEqualToString:@""]) {
        self.displaySelectedPropertyLabel.text = [NSString stringWithFormat:@"请选择 %@",cationNameStr];
    }
    
    /***************************0元购*********************************/
    
    self.goodsKindSelectTableView.isZeroBuyGoods = self.isZeroBuyGoods;
  
    if (_pdZhuangtai == 1) {
        self.goodsKindSelectTableView.isPD = 1;
    }else{
        self.goodsKindSelectTableView.isPD = 0;
    }
    
    if (self.isZeroBuyGoods) {
        //是0元购
        self.zeroBuyButton.hidden = NO;
        //判断用户是否购买过0元购商品
        if (self.isBoughtZeroBuyGoods) {
            self.zeroBuyButton.backgroundColor = [UIColor lightGrayColor];
        }
        
        
        
    }else{
        self.zeroBuyButton.hidden = YES;
    }
    
    /****************************************************************/
    //初始化选择字典
    _selectGoodsCationPropertyDic = [NSMutableDictionary dictionaryWithCapacity:_goodsCationPropertyDic.count];
    for (NSString *key in _goodsCationPropertyDic.allKeys) {
        
        if (!_selectGoodsCationPropertyDic[key]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic setObject:@0 forKey:@"open"];
            [_selectGoodsCationPropertyDic setObject:dic forKey:key];
        }
        
    }
}
//给image 添加点击事件
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer{
    //do something....
    
//    CKPhoteViewController * view = [[CKPhoteViewController alloc] init];
//    [self.nav pushViewController:view animated:YES];
    
       NSString *goodsImageUrl = _dataHander.goodsDetailModel.goodsMainPhotoPath;
    if(self.strGoodsSpecImageUrl.length == 0 || [self.strGoodsSpecImageUrl isEqualToString:@"null"]){
            [KYPhotoBrowserController showPhotoBrowserWithImages:@[goodsImageUrl] currentImageIndex:0 delegate:self];
    }else{
            [KYPhotoBrowserController showPhotoBrowserWithImages:@[self.strGoodsSpecImageUrl] currentImageIndex:0 delegate:self];
    }
    
    

}

#pragma mark - Notification Observer
-(void)observeGoodsPropertySelect:(NSNotification *)notiInfo{
    
    NSDictionary *dic = (NSDictionary *)notiInfo.object;
    //取出规格名字
    NSString *cationName = [dic[@"spec"] objectForKey:@"name"];
    
    
    
    //取出是否点击或者取消
    if ([dic[@"open"] integerValue]) {//点击
        NSMutableDictionary *mutableDic = self.selectGoodsCationPropertyDic[cationName];
        [mutableDic setObject:@1 forKey:@"open"];
        [mutableDic setObject:dic forKey:cationName];
        
        self.strGoodsSpecImageUrl = dic[@"specImageId"];
        
        //回调block商品详情顶部视图修改成选中规格的图片
        BLOCK_EXEC(self.changeGoodsImageBlock,self.strGoodsSpecImageUrl);
        if (self.strGoodsSpecImageUrl) {
            NSString *newStr = [YSThumbnailManager shopGoodsDetailAddShoppingCarViewGoodPicUrlString:self.strGoodsSpecImageUrl];
            [YSImageConfig yy_view:self.goodsImgView setImageWithURL:[NSURL URLWithString:newStr] placeholderImage:DEFAULTIMG];
   

        }
       
    }else{//取消点击
        [self.selectGoodsCationPropertyDic[cationName] setObject:@0 forKey:@"open"];
        [YSImageConfig yy_view:self.goodsImgView setImageWithURL:[NSURL URLWithString:_dataHander.goodsDetailModel.goodsMainPhotoPath] placeholderImage:DEFAULTIMG];
        //回调block商品详情顶部视图修改成选中规格的图片,点击取消就传个nil回去
     BLOCK_EXEC(self.changeGoodsImageBlock,nil);
    }
    //寻找没有选中的规格
    NSString *unselecteStr = [self _findUnselectedCation];
    JGLog(@"unselected str %@",unselecteStr);
    if (unselecteStr) {
        self.displaySelectedPropertyLabel.text = [NSString stringWithFormat:@"请选择 %@",unselecteStr];
    }else{
        //属性选完之后的一些处理
        self.selectedPropertyStr= [self _findAllselectedCationValue];
        self.displaySelectedPropertyLabel.text = [NSString stringWithFormat:@"已选择 %@",_selectedPropertyStr];
        //给数据处理者赋值
        _dataHander.selectedPropertyIdArr = [self _getSelectedPropertyIdArr];
        //变化squ价格
        NSMutableAttributedString *attPriceStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %.2f",_dataHander.squPrice]];
        [attPriceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 1)];
        self.priceLabel.attributedText = attPriceStr;
        //变化squ库存
        NSInteger goodsStoreCount = _dataHander.goodsSquModel.count.integerValue;
        self.goodsStockLabel.text = [NSString stringWithFormat:@"库存：%ld",goodsStoreCount];
        _dataHander.selectedPropertyStr = self.selectedPropertyStr;
        _dataHander.goodsSquModel.selectGoodsSquStr = self.selectedPropertyStr;
        
        //给控制器发送squ改变通知，传squ模型
        [kNotification postNotificationName:changeGoodsSquNotification object:_dataHander.goodsSquModel];
        
        //发送库存改变的通知
        NSNumber* stockCount = _dataHander.goodsSquModel.count;
        [kNotification postNotificationName:goodsStockChangeNotification object:stockCount];
    }
}


-(void)observeGoodsCount:(NSNotification *)notInfo{
    NSInteger count = [notInfo.object integerValue];
    JGLog(@"数量----%d",count);

    _buyCount = count;
  
    

}



#pragma mark - 找到没有选择的规格
-(NSString *)_findUnselectedCation{
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    for (NSString *key in self.selectGoodsCationPropertyDic.allKeys) {
        NSInteger isSelected = [self.selectGoodsCationPropertyDic[key][@"open"] integerValue];
        if (!isSelected) {
            [arr addObject:key];
        }
    }
    
    JGLog(@"规格keys %@",self.selectGoodsCationPropertyDic.allKeys);
    JGLog(@"未选的规格 %@",arr);
    
    if (arr.count > 0) {
        NSString *unselectedStr = [arr componentsJoinedByString:@" "];
        JGLog(@"%@",unselectedStr);
        return unselectedStr;
    }else{
        return nil;
    }
}



#pragma mark - 找到选择的规格值
-(NSString *)_findAllselectedCationValue{
    
    NSLog(@"diccc ------ %@",self.selectGoodsCationPropertyDic);
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    for (NSString *key in self.selectGoodsCationPropertyDic.allKeys) {
        NSInteger isSelected = [self.selectGoodsCationPropertyDic[key][@"open"] integerValue];
        if (isSelected) {
            NSString *cationValue =  self.selectGoodsCationPropertyDic[key][key][@"value"];
            [arr addObject:cationValue];
        }
    }
    
    NSString *selectedValueStr = [arr componentsJoinedByString:@" "];
    return selectedValueStr;
}

- (IBAction)cancelAction:(id)sender {
    
    [self endAnimation];
    
}//取消

#pragma mark - 确定
- (IBAction)makeSureAction:(id)sender {
//    if ([self _hasGoodsStock]) {//有库存
        [self _dealWithActionType:MakeSureType];
//    }
}




-(NSArray *)_getSelectedPropertyIdArr{
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    for (NSString *key in self.selectGoodsCationPropertyDic.allKeys) {
        NSInteger isSelected = [self.selectGoodsCationPropertyDic[key][@"open"] integerValue];
        if (isSelected) {
            NSNumber *selectedPropertyID =  self.selectGoodsCationPropertyDic[key][key][@"id"];
            [arr addObject:selectedPropertyID];
        }
    }
    
    return (NSArray *)arr;
}


#pragma mark - 加入购物车
- (IBAction)addShoppingCartAction:(id)sender {
//    if ([self _hasGoodsStock]) {//有库存
        [self _dealWithActionType:AddshopingCartType];
//    }
    
}


#pragma mark - 立即购买
- (IBAction)buyNowAction:(id)sender {
//    if ([self _hasGoodsStock]) {
        [self _dealWithActionType:BuyNowType];
//    }
}

#pragma mark - 判断squ对应的有没有库存
-(BOOL)_hasGoodsStock{

    if (!_buyCount) {//购买数量为0，说明，库存为0,购买数量不会超过库存
        [KJShoppingAlertView showAlertTitle:@"商品库存不足" inContentView:self];
        return NO;
    }
    return YES;
}

-(void)_dealWithActionType:(ActionType)type{
    
    NSString *checkSelectResultStr = [self _findUnselectedCation];
    NSString *alertStr = [NSString stringWithFormat:@"请选择%@",checkSelectResultStr];
    if (checkSelectResultStr) {//还有没选的
        [KJShoppingAlertView showAlertTitle:alertStr inContentView:self];
    }else{//选完了,回调
        //检查库存
        if (![self _hasGoodsStock]) {
            return;
        }
        
        //得到选中的规格属性ID数组
        NSArray *propertyIdArr = [self _getSelectedPropertyIdArr];
        switch (type) {
            case MakeSureType:
                if (self.makeSureBlock) {
                    self.makeSureBlock(@(_buyCount),propertyIdArr,self.dataHander.selectedPropertyStr,self.dataHander.squPrice);
                }
                break;
            case AddshopingCartType:
                if (self.AddShopingCartOrBuyNowBlock) {
                    self.AddShopingCartOrBuyNowBlock(@(_buyCount),propertyIdArr,NO);
                }
                break;
            case BuyNowType:
                if (self.AddShopingCartOrBuyNowBlock) {
                    self.AddShopingCartOrBuyNowBlock(@(_buyCount),propertyIdArr,YES);
                }
                break;
                
            default:
                break;
        }
    }
    
}
//0元购立刻购买
- (IBAction)zeroBuyImmediatelyBuyButtonClick:(id)sender {
    
    if (self.isBoughtZeroBuyGoods) {
        [UIAlertView xf_showWithTitle:@"您已购买过，限购一件" message:nil delay:1.2 onDismiss:NULL];
        return;
    }
    
    [self _dealWithActionType:BuyNowType];
}

- (void)dealloc
{
    [kNotification removeObserver:self];
}


@end

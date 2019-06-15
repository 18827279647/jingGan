//
//  KJOrderDetailGoodsTableView.m
//  jingGang
//
//  Created by 张康健 on 15/8/12.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "KJOrderDetailGoodsTableView.h"
#import "KJOrderDetailGoodsCell.h"
#import "OrderDetailPayWayCell.h"
#import "GlobeObject.h"
#import "GoodsInfoModel.h"
#import "OderDetailModel.h"
#import "UIButton+Block.h"
#import "UIView+firstResponseController.h"
#import "QueryLogisticsViewController.h"
#import "UIView+BlockGesture.h"
#import "YSLoginManager.h"

@implementation KJOrderDetailGoodsTableView

static NSString *KJOrderDetailGoodsCellID = @"KJOrderDetailGoodsCellID";
static NSString *OrderDetailPayWayCellID = @"OrderDetailPayWayCellID";

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"KJOrderDetailGoodsCell" bundle:nil]  forCellReuseIdentifier:KJOrderDetailGoodsCellID];
        [self registerNib:[UINib nibWithNibName:@"OrderDetailPayWayCell" bundle:nil]  forCellReuseIdentifier:OrderDetailPayWayCellID];
        
    }
    
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    NSInteger orsderStatus = self.orderDetailModel.orderStatus.integerValue;
    JGLog(@"订单状态 数字 %ld",(long)self.orderDetailModel.orderStatus.integerValue);
    if (orsderStatus == 10 || orsderStatus == 0 || orsderStatus == 18) {
        if ([self.orderDetailModel.payTypeFlag integerValue] == 1 || [self.orderDetailModel.payTypeFlag integerValue] == 2) {
            return self.orderListArr.count + 1;
        }else{
            return self.orderListArr.count;
        }
        
    }else {//非待付款和取消状态，才有付款方式
        return self.orderListArr.count + 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSDictionary *dic = self.orderListArr[section];
    if (section == self.orderListArr.count) {
        return 1;
    }else{
        OderDetailModel *model = (OderDetailModel *)self.orderListArr[section];
        return model.goodsInfos.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.orderListArr.count) {//返回最后一个cell
        OrderDetailPayWayCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderDetailPayWayCellID forIndexPath:indexPath];
        cell.payWayLabel.text = self.payWay;
        return cell;
        
    }else{
        KJOrderDetailGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:KJOrderDetailGoodsCellID forIndexPath:indexPath];
        OderDetailModel *orderDetailModel = self.orderListArr[indexPath.section];
        GoodsInfoModel *goodsInfoModel = orderDetailModel.goodsInfos[indexPath.row];
        cell.goodsInfoModel = goodsInfoModel;
        cell.goodsOrderID = orderDetailModel.OderDetailModelID;
        cell.bgView.userInteractionEnabled = YES;

        //精品专区商品信息显示
        if (goodsInfoModel.payTypeFlag.integerValue > 0) {
            //商品名称只显示一行
            cell.od_goodsNameLabel.numberOfLines = 1;
            if (goodsInfoModel.payTypeFlag.integerValue == 1) {
                //重消展示
                cell.yunGouBiICon.hidden       = YES;
                cell.labelYunGouBiValue.hidden = YES;
                cell.labelCxbValue.hidden      = NO;
                cell.labelCxbValue.text = [NSString stringWithFormat:@"  重消 %.0f  ",[goodsInfoModel.needYgb floatValue]];
                
            }else if (goodsInfoModel.payTypeFlag.integerValue == 2 || goodsInfoModel.payTypeFlag.integerValue == 3){
                
                cell.yunGouBiICon.hidden       = NO;
                cell.labelYunGouBiValue.hidden = NO;
                cell.labelCxbValue.hidden      = YES;
                //积分+现金
                NSString *strNeedIntegreal = [NSString stringWithFormat:@"%ld",(long)[goodsInfoModel.needIntegral integerValue]];
                NSString *strIntegralAppendCash = [NSString stringWithFormat:@"%@ + %.2f元",strNeedIntegreal,[goodsInfoModel.needMoney floatValue]];
                NSMutableAttributedString *attrStrIntegralAppendCash = [[NSMutableAttributedString alloc]initWithString:strIntegralAppendCash];
                [attrStrIntegralAppendCash addAttribute:NSForegroundColorAttributeName value:[YSThemeManager buttonBgColor] range:NSMakeRange(0, strNeedIntegreal.length)];
                cell.labelYunGouBiValue.attributedText = attrStrIntegralAppendCash;
            }
        }else{
            cell.yunGouBiICon.hidden  = YES;
            cell.labelYunGouBiValue.hidden = YES;
            cell.labelCxbValue.hidden     = YES;
            
            
            
            
            if ([goodsInfoModel.needIntegral integerValue] != 0) {
                cell.yunGouBiICon.hidden       = NO;
                cell.labelYunGouBiValue.hidden = NO;
                cell.labelCxbValue.hidden      = YES;
                
                //积分+现金
                NSString *strNeedIntegreal = [NSString stringWithFormat:@"%ld",(long)[goodsInfoModel.needIntegral integerValue]];
                NSString *strIntegralAppendCash = [NSString stringWithFormat:@"%@ + %.2f元",strNeedIntegreal,[goodsInfoModel.needMoney floatValue]];
                NSMutableAttributedString *attrStrIntegralAppendCash = [[NSMutableAttributedString alloc]initWithString:strIntegralAppendCash];
                [attrStrIntegralAppendCash addAttribute:NSForegroundColorAttributeName value:[YSThemeManager buttonBgColor] range:NSMakeRange(0, strNeedIntegreal.length)];
                cell.labelYunGouBiValue.attributedText = attrStrIntegralAppendCash;
            }
            
            
        }
        
        //是否隐藏申请退货按钮
        if (orderDetailModel.orderStatus.integerValue == 40 || orderDetailModel.orderStatus.integerValue == 50) {//已收货，待申请退货
            if (goodsInfoModel.hasReturn.boolValue) {//是否过期或者申请过退货退款,是否允许退货
                if (goodsInfoModel.payTypeFlag.integerValue > 0) {//精选商品订单不显示退货按钮
                    cell.applyReturnGoodsButton.hidden = YES;
                }else{
                    cell.applyReturnGoodsButton.hidden = NO;
                }
            }else{
                cell.applyReturnGoodsButton.hidden = YES;
            }
        }else{
            cell.applyReturnGoodsButton.hidden = YES;
        }
        
        [cell.bgView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            if (self.clickOrderDetailBlock) {
                self.clickOrderDetailBlock(indexPath,@(goodsInfoModel.goodsId.integerValue));
            }
        }];
        return cell;
    }     
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.orderListArr.count) {
        
        return 43;
        
    }else{
        OderDetailModel *orderDetailModel = self.orderListArr[indexPath.section];
        if (orderDetailModel.goodsInfos.count - 1 == indexPath.row) {
            return 108;
        }else{
            return 113;
        }
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == self.orderListArr.count) {//最后一组,
        return nil;
    }else{
        UIView *headerView = BoundNibView(@"KJOrderDetailGoodsSectionHeaderView", UIView);
        UILabel *storeNamelabel = (UILabel *)[headerView viewWithTag:1];
         OderDetailModel *orderDetailModel = self.orderListArr[section];
        if (orderDetailModel.storeName.length == 0 || !orderDetailModel.storeName) {
            storeNamelabel.text = @"平台自营";
        }else{
            storeNamelabel.text = orderDetailModel.storeName;
        }
        return headerView;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (section == self.orderListArr.count) {//最后一组,
        return nil;
    }else{
        UIView *footerView = BoundNibView(@"KJOrderDetailGoodsFooterView", UIView);
        //状态button
        UIButton *orderStatusButton = (UIButton *)[footerView viewWithTag:1];
        OderDetailModel *orderDetailModel = self.orderListArr[section];
        [orderStatusButton setTitle:orderDetailModel.orderStatusStr forState:UIControlStateNormal];
        //查看物流button
        UIButton *lookDeliveryButton = (UIButton *)[footerView viewWithTag:2];
        WEAK_SELF
        [lookDeliveryButton addActionHandler:^(NSInteger tag) {
            QueryLogisticsViewController *quertVC = [[QueryLogisticsViewController alloc] initWithNibName:@"QueryLogisticsViewController" bundle:nil];
            
            JGLog(@" 快递号 %@, 快递公司id %@",orderDetailModel.shipCode,orderDetailModel.expressCompanyId.stringValue);
            quertVC.expressCode = orderDetailModel.shipCode;
            quertVC.expressCompanyId = orderDetailModel.expressCompanyId;
            [weak_self.firstResponseController.navigationController pushViewController:quertVC animated:YES];
            
        }];
        
        
        
        return footerView;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section != self.orderListArr.count) {
        OderDetailModel *orderDetailModel = self.orderListArr[indexPath.section];
        GoodsInfoModel *goodsInfoModel = orderDetailModel.goodsInfos[indexPath.row];
        if (self.clickOrderDetailBlock) {
            self.clickOrderDetailBlock(indexPath,@(goodsInfoModel.goodsId.integerValue));
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == self.orderListArr.count) {//最后一组，无组头，组尾
        return 0;
    }else{
        return 47;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.orderListArr.count) {//最后一组，无组头，组尾
        return 0;
    }else{
        //判断是否可查看物流
        OderDetailModel *orderDetailModel = self.orderListArr[section];
        CGFloat heght = orderDetailModel.canLookGoodsDelivery ? 43 : 0;
        return heght;
    }
}







@end

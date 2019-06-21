//
//  RXTabViewHeightObjject.m
//  jingGang
//
//  Created by 荣旭 on 2019/6/19.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXTabViewHeightObjject.h"
#import "Unit.h"
@implementation RXTabViewHeightObjject
+(CGFloat)getTabViewHeight:(NSMutableDictionary*)dic;{
    if ([Unit JSONBool:dic key:@"myZhankaiType"]) {
        return 80;
    }else{
        if ([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"运动步数"]) {
            return 290;
        }else if([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"血压"]){
            return 340;
        }else if([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"血糖"]||[[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"体重"]){
            return 280;
        }else if([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"血氧"]){
            return 290;
        }else if([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"血脂"]){
            return 500;
        }
        return 0;
    }
}

+(UITableViewCell*)getTabViewCell:(NSMutableDictionary*)dic;{
    if ([Unit JSONBool:dic key:@"myZhankaiType"]) {
        return [[RXZhangKaiTableViewCell alloc]init];
    }else{
        if ([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"运动步数"]) {
            return [[RXMotionTableViewCell alloc]init];
        }else if([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"血压"]||[[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"血糖"]||[[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"体重"]){
            return [[RXBloodPressureTableViewCell alloc]init];
        }else if([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"血氧"]){
            return [[RXMotionTableViewCell alloc]init];
        }else if([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"血脂"]){
            return [[RXBloodPressureTableViewCell alloc]init];
        }
    }
    return [[UITableViewCell alloc]init];
}

+(NSInteger)getTabviewNumber:(NSMutableDictionary*)dic with:(RXParamDetailResponse*)response;{
    int index=0;
    if ([Unit JSONBool:dic key:@"myZhankaiType"]) {
        return 1;
    }else{
        //默认隐藏
        if (![Unit JSONBool:dic key:@"mySelectType"]) {
            return index;
        }
        if ([RXTabViewHeightObjject getType:dic]) {
            index=index+1;
            if (response) {
                if (response.keywordGoodsList.count>0) {
                    index=index+1;
                }
                if (response.invitationList.count>0) {
                    index=index+1;
                }
            }
        }
    }
    return index;
}
+(bool)getType:(NSMutableDictionary*)dic;{
    if ([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"运动步数"]) {
         return true;
    }else if([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"血压"]){
         return true;
    }else if([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"体重"]){
         return true;
    }else if([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"血糖"]){
         return true;
    }else if([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"体脂率"]){
         return true;
    }else if([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"血脂"]){
         return true;
    }else if([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"血尿酸"]){
         return true;
    }else if([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"血氧"]){
        return true;
    }
    return false;
}
//根据itemCode判断，是那一个,app本身判断名字可以写死，只有17个。
+(NSString*)getItemCodeNumber:(NSMutableDictionary*)dic;{
    switch ([Unit JSONInt:dic key:@"itemCode"]) {
        case 0:
            return @"呼吸";
            break;
        case 1:
            return @"体脂";
            break;
        case 2:
            return @"血脂";
            break;
        case 3:
            return @"血氧";
            break;
        case 4:
            return @"血压";
            break;
        case 5:
            return @"总胆固醇";
            break;
        case 6:
            return @"听力";
            break;
        case 7:
            return @"心电图";
            break;
        case 8:
            return @"肺活量";
            break;
        case 9:
            return @"血糖";
            break;
        case 10:
            return @"心率";
            break;
        case 11:
            return @"睡眠";
            break;
        case 12:
            return @"运动步数";
            break;
        case 13:
            return @"体温";
            break;
        case 14:
            return @"尿酸";
            break;
        case 15:
            return @"视力";
            break;
        case 16:
            return @"体重";
            break;
        case 17:
            return @"腰臀比";
            break;
            
        default:
            return @"";
            break;
    }
    return @"";
}
@end

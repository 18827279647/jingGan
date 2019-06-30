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
        if ([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"运动"]) {
            return 270;
        }else if([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"血压"]){
            return 340;
        }else if([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"血糖"]||[[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"体重"]){
            return 280;
        }else if([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"血氧"]){
            return 250;
        }else if([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"血脂"]){
            return 500;
        }else if([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"体脂"]){
            return 250;
        }else if([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"尿酸"]){
            return 280;
        }
        return 0;
    }
}

+(UITableViewCell*)getTabViewCell:(NSMutableDictionary*)dic;{
    if ([Unit JSONBool:dic key:@"myZhankaiType"]) {
        return [[RXZhangKaiTableViewCell alloc]init];
    }else{
        if ([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"运动"]) {
            return [[RXMotionTableViewCell alloc]init];
        }else if([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"血压"]||[[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"血糖"]||[[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"体重"]||[[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"尿酸"]){
            return [[RXBloodPressureTableViewCell alloc]init];
        }else if([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"血氧"]){
            return [[RXMotionTableViewCell alloc]init];
        }else if([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"血脂"]){
            return [[RXBloodPressureTableViewCell alloc]init];
        }else if ([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"体脂"]) {
            return [[RXMotionTableViewCell alloc]init];
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
    if ([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"运动"]) {
         return true;
    }else if([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"血压"]){
         return true;
    }else if([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"体重"]){
         return true;
    }else if([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"血糖"]){
         return true;
    }else if([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"体脂"]){
         return true;
    }else if([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"血脂"]){
         return true;
    }else if([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"尿酸"]){
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
            return @"运动";
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

+(NSMutableArray*)getMorenArray;{
    NSMutableArray*array=[[NSMutableArray alloc]init];
    [array addObject:@{@"itemCode":@"12",@"itemName":@"运动"}];
    [array addObject:@{@"itemCode":@"4",@"itemName":@"血压"}];
    [array addObject:@{@"itemCode":@"9",@"itemName":@"血糖"}];
    [array addObject:@{@"itemCode":@"16",@"itemName":@"体重"}];
    [array addObject:@{@"itemCode":@"1",@"itemName":@"体脂率"}];
    [array addObject:@{@"itemCode":@"2",@"itemName":@"血脂"}];
    [array addObject:@{@"itemCode":@"14",@"itemName":@"血尿酸"}];
    [array addObject:@{@"itemCode":@"3",@"itemName":@"血氧"}];
    [array addObject:@{@"itemCode":@"10",@"itemName":@"心率"}];
    [array addObject:@{@"itemCode":@"13",@"itemName":@"体温"}];
    [array addObject:@{@"itemCode":@"0",@"itemName":@"呼吸率"}];
    [array addObject:@{@"itemCode":@"17",@"itemName":@"腰臀比"}];    
    return array;
}
//返回button的个数
+(NSInteger)getRXZhangKaiTableViewCell:(NSMutableDictionary*)dic;{
    NSInteger index=0;
     //一体机
    if ([[Unit JSONString:dic key:@"isContaionMachine"] isEqualToString:@"1"]) {
        index++;
    }
    //硬件
    if ([[Unit JSONString:dic key:@"isContainHardware"] isEqualToString:@"1"]) {
        index++;
    }
    //手机检测
    if ([[Unit JSONString:dic key:@"isContaionCellPhone"] isEqualToString:@"1"]) {
         index++;
    }
    //手录
    if ([[Unit JSONString:dic key:@"isContaionHand"] isEqualToString:@"1"]) {
       index++;
    }
    if (index==0) {
        index=1;
    }
    return index;
}

+(NSMutableArray*)getRXZhangKaiTablelViewTitleArray:(NSMutableDictionary*)dic;{
    NSMutableArray*array=[[NSMutableArray alloc]init];
    //一体机
    if ([[Unit JSONString:dic key:@"isContaionMachine"] isEqualToString:@"1"]) {
        [array addObject:@"0"];
    }
    //硬件
    if ([[Unit JSONString:dic key:@"isContainHardware"] isEqualToString:@"1"]) {
        [array addObject:@"1"];
    }
    //手机检测
    if ([[Unit JSONString:dic key:@"isContaionCellPhone"] isEqualToString:@"1"]) {
        [array addObject:@"2"];
    }
    //手录
    if ([[Unit JSONString:dic key:@"isContaionHand"] isEqualToString:@"1"]) {
        [array addObject:@"3"];
    }
    if (array.count==0) {
        [array addObject:@"3"];
    }
    return array;
}
//返回button的图片数据
+(NSMutableArray*)getRXZhangKaiTablelViewImageArray:(NSMutableDictionary*)dic;{
    NSMutableArray*array=[[NSMutableArray alloc]init];
    //一体机
    if ([[Unit JSONString:dic key:@"isContaionMachine"] isEqualToString:@"1"]) {
        [array addObject:@"健康一体机"];
    }
    //硬件
    if ([[Unit JSONString:dic key:@"isContainHardware"] isEqualToString:@"1"]) {
         [array addObject:@"智能设备"];
    }
    //手机检测
    if ([[Unit JSONString:dic key:@"isContaionCellPhone"] isEqualToString:@"1"]) {
         [array addObject:@"手机检测"];
    }
    //手录
    if ([[Unit JSONString:dic key:@"isContaionHand"] isEqualToString:@"1"]) {
         [array addObject:@"手动输入"];
    }
    if (array.count==0) {
        [array addObject:@"手动输入"];
    }
    return array;
}
//返回button的图片数据
+(NSMutableArray*)getRXLISHITablelViewImageArray:(NSMutableDictionary*)dic;{
    NSMutableArray*array=[[NSMutableArray alloc]init];
    //一体机
    if ([[Unit JSONString:dic key:@"isContaionMachine"] isEqualToString:@"1"]) {
        [array addObject:@"智能硬件_3"];
    }
    //硬件
    if ([[Unit JSONString:dic key:@"isContainHardware"] isEqualToString:@"1"]) {
        [array addObject:@"智能硬件_1"];
    }
    //手机检测
    if ([[Unit JSONString:dic key:@"isContaionCellPhone"] isEqualToString:@"1"]) {
        [array addObject:@"智能硬件_2"];
    }
    //手录
    if ([[Unit JSONString:dic key:@"isContaionHand"] isEqualToString:@"1"]) {
        [array addObject:@"智能硬件_4"];
    }
    if (array.count==0) {
        [array addObject:@"智能硬件_4"];
    }
    return array;
}
//根据不同的东西显示
+(void)getButtonShowCell:(RXZhangKaiTableViewCell*)cell with:(NSMutableDictionary*)dic;{
    NSMutableArray*array=[RXTabViewHeightObjject getRXZhangKaiTablelViewImageArray:dic];
    if (array.count==4) {
        //1
        [cell.oneOneButton setImage:[UIImage imageNamed:array[0]] forState:UIControlStateSelected];
        [cell.oneOneButton setImage:[UIImage imageNamed:array[0]] forState:UIControlStateNormal];
        
        //2
        [cell.oneTwoButton setImage:[UIImage imageNamed:array[1]] forState:UIControlStateSelected];
        [cell.oneTwoButton setImage:[UIImage imageNamed:array[1]] forState:UIControlStateNormal];
        //3
        [cell.oneFreeButton setImage:[UIImage imageNamed:array[2]] forState:UIControlStateSelected];
        [cell.oneFreeButton setImage:[UIImage imageNamed:array[2]] forState:UIControlStateNormal];
        //4
        [cell.oneFiveButton setImage:[UIImage imageNamed:array[3]] forState:UIControlStateSelected];
        [cell.oneFiveButton setImage:[UIImage imageNamed:array[3]] forState:UIControlStateNormal];
        
    }else if(array.count==3){
        //1
        [cell.twoOneButon setImage:[UIImage imageNamed:array[0]] forState:UIControlStateSelected];
        [cell.twoOneButon setImage:[UIImage imageNamed:array[0]] forState:UIControlStateNormal];
        //2
        [cell.twoTwoButton setImage:[UIImage imageNamed:array[1]] forState:UIControlStateSelected];
        [cell.twoTwoButton setImage:[UIImage imageNamed:array[1]] forState:UIControlStateNormal];
        //3
        [cell.twoFreeButton setImage:[UIImage imageNamed:array[2]] forState:UIControlStateSelected];
        [cell.twoFreeButton setImage:[UIImage imageNamed:array[2]] forState:UIControlStateNormal];
    }else if(array.count==2){
        //1
        [cell.freeOneButton setImage:[UIImage imageNamed:array[0]] forState:UIControlStateSelected];
        [cell.freeOneButton setImage:[UIImage imageNamed:array[0]] forState:UIControlStateNormal];
        //2
        [cell.freeTwoButton setImage:[UIImage imageNamed:array[1]] forState:UIControlStateSelected];
        [cell.freeTwoButton setImage:[UIImage imageNamed:array[1]] forState:UIControlStateNormal];
    }else if(array.count==1){
        //1
        [cell.fiveOneButton setImage:[UIImage imageNamed:array[0]] forState:UIControlStateSelected];
        [cell.fiveOneButton setImage:[UIImage imageNamed:array[0]] forState:UIControlStateNormal];
    }
}
@end

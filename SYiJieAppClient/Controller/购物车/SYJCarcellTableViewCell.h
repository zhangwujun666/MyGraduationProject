//
//  SYJCarcellTableViewCell.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/4.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@protocol SYjCelldeleate<NSObject>
//-(void)Getprice;
-(void)selectBox:(NSIndexPath *)path;//选中CheckBox时
-(void)deselectBox:(NSIndexPath *)path;//取消选中CheckBox
-(void)addCount:(NSIndexPath *)path;//添加一个数量
-(void)deleteCount:(NSIndexPath *)path;//减少一个数量
@end
@interface SYJCarcellTableViewCell : UITableViewCell
@property (weak,nonatomic) id<SYjCelldeleate>deleate;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UIButton *delectButton;
@property (weak, nonatomic) IBOutlet UILabel *priceLable;//价格
@property (weak, nonatomic) IBOutlet UILabel *babynamelable;//宝贝名称
@property (weak, nonatomic) IBOutlet UIImageView *babyimg;//宝贝图片

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *Numberlable;//宝贝数量
@property (weak, nonatomic) IBOutlet UILabel *SIzeLble;//宝贝尺寸

@property (weak, nonatomic) IBOutlet UILabel *ColourLable;//宝贝颜色


@property(assign,nonatomic)BOOL selectState;//选中状态
@property(assign,nonatomic)BOOL State1;//判断用户是否有勾选宝贝，没有的话，给他提示
@property(nonatomic) int count;
@property(nonatomic) int a;
@property(nonatomic) NSString * idd;
@property (strong, nonatomic)NSIndexPath *path;//当前cell的路径
@end


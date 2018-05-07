//
//  view.h
//  kongjian
//
//  Created by administrator on 15/8/18.
//  Copyright (c) 2015年 尚衣街. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Pickview;
@protocol Pickdelegate<NSObject>

-(void)pick:(Pickview *)pickVc sheng:(NSString *)sheng andcity:(NSString *)city andqu:(NSString *)qu;

@end
@interface Pickview : UIView
@property (weak, nonatomic) IBOutlet UIPickerView *one;
@property NSString *sheng;
@property NSString *city;
@property NSString *qu;
@property (weak, nonatomic)id<Pickdelegate>delegate;
-(void)changanima;
-(void)cityy;
@end

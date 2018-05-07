//
//  ZHPickView.h
//  ZHpickView
//
//  Created by liudianling on 14-11-18.
//  Copyright (c) 2014年 赵恒志. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SYJDataPickView;

@protocol ZHPickViewDelegate <NSObject>

@optional
-(void)toobarDonBtnHaveClick:(SYJDataPickView *)pickView resultString:(NSString *)resultString;
-(void)removebarckcolour;
@end

@interface ZHPickView : UIView

@property(nonatomic,weak) id<ZHPickViewDelegate> delegate;



-(instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode isHaveNavControler:(BOOL)isHaveNavControler;



-(void)show;


@end



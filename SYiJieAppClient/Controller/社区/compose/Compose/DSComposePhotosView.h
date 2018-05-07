//
//  DSComposePhotosView.h
//  DSLolita
//
//  Created by 赛 丁 on 15/5/28.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol presentToImageSelectDelegate <NSObject>
-(void)presentToImageViewCotroller;
@end

@interface DSComposePhotosView : UIView
@property (nonatomic , retain) UICollectionView *collectionView;
@property (nonatomic , strong) NSMutableArray *assetsArray;
@property (nonatomic , strong) UIButton *addButton;
@property (nonatomic , strong) NSArray *selectedPhotos;
@property (nonatomic, assign) id<presentToImageSelectDelegate> delegate;//实现了presentToImageSelectDelegate的代理类型
@end

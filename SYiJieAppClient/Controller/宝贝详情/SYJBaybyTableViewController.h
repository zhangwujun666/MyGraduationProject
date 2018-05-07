//
//  SYJBaybyTableViewController.h
//  SYiJieAppClient
//
//  Created by administrator on 15/8/7.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^changBlock)(NSString *);
@interface SYJBaybyTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIScrollView *ShowScrollView;
@property (weak, nonatomic) IBOutlet UILabel *BabyName;
@property (weak, nonatomic) IBOutlet UILabel *StoreAddress;

@property (weak, nonatomic) IBOutlet UILabel *babyPrice;
@property (weak, nonatomic) IBOutlet UIScrollView *detailimage;

@property (weak, nonatomic) IBOutlet UIImageView *userheadimg;

@property (weak, nonatomic) IBOutlet UILabel *usercontent;
@property (weak, nonatomic) IBOutlet UILabel *username;

@property (weak, nonatomic) IBOutlet UILabel *Commentnuber;
@property (weak, nonatomic) IBOutlet UIImageView *xing;
@property (weak, nonatomic) IBOutlet UILabel *babySales;
@property(assign,nonatomic)BOOL SizeState;
@property (weak, nonatomic) IBOutlet UICollectionView *CollectionShowimage;

@property(assign,nonatomic)BOOL ColourctState;
@property(assign,nonatomic)BOOL Stateone;
@property NSString *idd;
@property (copy,nonatomic)changBlock commentbabyid;
@end

//
//  MySelectionView.h
//  innmall
//
//  Created by yanqizhou on 11/13/14.
//  Copyright (c) 2014 yanqizhou. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TableData.h"

@class MySelectionView;

typedef NSString* (^getShowName)(id inItem);

typedef void (^didSelectedOption)(MySelectionView *selview, id selectedItem);


@protocol MySelectionViewDelegate <NSObject>

- (void)didSelectedChoice:(id)selectedItem selectview:(MySelectionView*)selview;

@end

@interface MySelectionView : TableView

@property(nonatomic, strong)NSArray *contentArr;
@property(nonatomic, strong)id selectedItem;

@property(nonatomic, assign)id<MySelectionViewDelegate>delegate;

- (id)initWithContentArray:(NSArray*)conArray selected:(id)item getNameBlock:(getShowName)showblock selectBlock:(didSelectedOption)selectblock;
- (id)initWithContentArray:(NSArray*)conArray selected:(id)item getNameBlock:(getShowName)showblock delegate:(id)delegate;
- (void)show;
- (void)disMissAnimated:(BOOL)animated;

@end

@interface SelectData : CellData

@property(nonatomic, strong)NSString *showText;
@property(nonatomic, strong)NSString *arrowimgName;
@property(nonatomic, assign)BOOL selected;

@property(nonatomic, strong)id item;


@end
//
//  TableData.h
//  EasySelection
//
//  Created by yanqizhou on 1/30/15.
//  Copyright (c) 2015 yanqizhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CellData : NSObject

@property(nonatomic, assign)int type;
@property(nonatomic, assign)float height;
@property(nonatomic, strong)NSMutableDictionary *dicData;

@end

@interface SectionData : NSObject

@property(nonatomic, assign)int type;
@property(nonatomic, strong)NSMutableArray *cellGroup;
@property(nonatomic, strong)NSString *sectionTitle;

- (NSInteger)count;
- (CellData*)cellAtIndex:(NSInteger)index;
- (void)addCell:(CellData*)cellData;
- (CellData*)addCellWithType:(int)type Height:(float)height;
@end

@interface TableData : NSObject

@property(nonatomic, strong)NSMutableArray *sectionGroup;

- (NSInteger)count;
- (SectionData*)sectionAtIndex:(NSInteger)index;
- (void)addSection:(SectionData*)sectionData;
- (SectionData*)addSectionDataWithType:(int)type sectionTitle:(NSString*)title;
@end

@interface TableView : UIView {
    TableData *_tableData;
    UITableView *_tableView;
}

@property(nonatomic, strong)TableData *tableData;
@property(nonatomic, strong)UITableView *tableView;

- (void)genTableData;
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;
- (id)initWithFrame:(CGRect)frame;

@end
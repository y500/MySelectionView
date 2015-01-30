//
//  TableData.m
//  EasySelection
//
//  Created by yanqizhou on 1/30/15.
//  Copyright (c) 2015 yanqizhou. All rights reserved.
//

#import "TableData.h"

@implementation CellData

@end

@implementation SectionData

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cellGroup=[NSMutableArray arrayWithCapacity:10];
        self.type=0;
        self.sectionTitle=nil;
    }
    return self;
}

- (NSInteger)count {
    return _cellGroup.count;
}

- (CellData*)cellAtIndex:(NSInteger)index {
    if (index<_cellGroup.count) {
        if ([[_cellGroup objectAtIndex:index] isKindOfClass:[CellData class]]) {
            return [_cellGroup objectAtIndex:index];
        }else{
            NSLog(@"WARN:Invalid Item At Index:%d",index);
        }
    }else{
        NSLog(@"WARN:Invalid Index:%d out bounds of %d",index,_cellGroup.count);
    }
    return nil;
}

- (void)addCell:(CellData *)cellData {
    if ([cellData isKindOfClass:[CellData class]]) {
        [_cellGroup addObject:cellData];
    }else{
        NSLog(@"WARN:add invalid CellData to CellGroup");
    }
}

- (CellData*)addCellWithType:(int)type Height:(float)height {
    CellData *cellData=[[CellData alloc] init];
    cellData.type=type;
    cellData.height=height;
    [self addCell:cellData];
    
    return cellData;
}

@end

@implementation TableData

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sectionGroup=[NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

- (NSInteger)count {
    return _sectionGroup.count;
}

- (void)addSection:(SectionData *)sectionData {
    if ([sectionData isKindOfClass:[SectionData class]]) {
        [_sectionGroup addObject:sectionData];
    }else{
        NSLog(@"WARN:Add invalid to SeciontGroup");
    }
}

- (SectionData*)sectionAtIndex:(NSInteger)index {
    if (index<_sectionGroup.count) {
        if ([[_sectionGroup objectAtIndex:index] isKindOfClass:[SectionData class]]) {
            return [_sectionGroup objectAtIndex:index];
        }else{
            NSLog(@"WARN:Invalid item at index:%d",index);
        }
    }else{
        NSLog(@"WARN:Invalid index:%d out of bounds:%d",index,_sectionGroup.count);
    }
    return nil;
}

- (SectionData*)addSectionDataWithType:(int)type sectionTitle:(NSString*)title {
    SectionData *section=[[SectionData alloc] init];
    section.type=type;
    section.sectionTitle=title;
    [self addSection:section];
    
    return section;
}

@end

@interface TableView ()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property(nonatomic, assign)UITableViewStyle tableViewStyle;

@end

@implementation TableView
@synthesize tableData=_tableData,tableView=_tableView;

- (void)genTableData {
    self.tableData=[[TableData alloc] init];
    SectionData *section=[_tableData addSectionDataWithType:0 sectionTitle:nil];
    [section addCellWithType:0 Height:0];
}

- (id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self=[super initWithFrame:frame]) {
        _tableViewStyle=style;
        
        [self genTableData];
        if (_tableView==nil) {
            _tableView=[[UITableView alloc] initWithFrame:self.bounds style:_tableViewStyle];
            _tableView.delegate=self;
            _tableView.dataSource=self;
            _tableView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectZero];
            _tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
            [self addSubview:_tableView];
        }
    }
    
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame style:UITableViewStylePlain];
}

- (instancetype)init{
    return [self initWithFrame:CGRectZero];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _tableData.count > 0 ? _tableData.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section < _tableData.count){
        SectionData *theSection = [_tableData sectionAtIndex:section];
        return theSection.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ( indexPath.section < _tableData.count ) {
        SectionData *theSection = [_tableData sectionAtIndex:indexPath.section];
        if ( indexPath.row < theSection.count ) {
            CellData *theCell = [theSection cellAtIndex:indexPath.row];
            return theCell.height;
        }
    }
    
    return 44.0;
}

@end

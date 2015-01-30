//
//  MySelectionView.m
//  innmall
//
//  Created by yanqizhou on 11/13/14.
//  Copyright (c) 2014 yanqizhou. All rights reserved.
//

#import "MySelectionView.h"

#define g_screenHeight [UIScreen mainScreen].bounds.size.height
#define g_screenWidth [UIScreen mainScreen].bounds.size.width

@interface MySelectionView ()

@property(nonatomic, strong)getShowName getShowBlock;
@property(nonatomic, strong)didSelectedOption selectBlock;

@property(nonatomic, strong)UIView *contentView;

@end

@implementation MySelectionView


- (void)genTableData {
    self.tableData=[[TableData alloc] init];
    
    SectionData *section=[[SectionData alloc] init];
    [_tableData addSection:section];
    
    for (id option in _contentArr) {
        SelectData *data=[[SelectData alloc] init];
        data.item=option;
        data.showText=_getShowBlock(option);
        data.arrowimgName=@"selection_mark";
        if ([option isEqual:_selectedItem]) {
            data.selected=YES;
        }else{
            data.selected=NO;
        }
        data.height=44;
        [section addCell:data];
    }
}

- (void)reloadData {
    [self genTableData];
    [_tableView reloadData];
    
    for (int i=0; i<_tableData.count; i++) {
        SectionData *section=[_tableData sectionAtIndex:i];
        for (int j=0;j<section.count; j++) {
            SelectData *data=(SelectData*)[section cellAtIndex:j];
            
            if (data.selected) {
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            }
        }
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SectionData *section=[_tableData sectionAtIndex:indexPath.section];
    SelectData *cellData=(SelectData*)[section cellAtIndex:indexPath.row];
    
    static NSString *identifier=@"selectCell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, cellData.height)];
        label.font=[UIFont systemFontOfSize:15];
        label.textAlignment=NSTextAlignmentCenter;
        label.tag=101;
        label.textColor=[UIColor colorWithRed:0 green:0x79/255 blue:1 alpha:1];
        [cell.contentView addSubview:label];
        
        if ([UIImage imageNamed:cellData.arrowimgName]) {
            UIImageView *arrowImgv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:cellData.arrowimgName]];
            arrowImgv.tag=102;
            arrowImgv.center=CGPointMake(self.frame.size.width-15-arrowImgv.frame.size.width/2, cellData.height/2);
            [cell.contentView addSubview:arrowImgv];
        }
        
        UIView *lineview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
        lineview.backgroundColor=[UIColor colorWithRed:0xd8/0xff green:0xd8/0xff blue:0xd8/0xff alpha:1];
        [cell.contentView addSubview:lineview];
    }
    
    UILabel *label=(UILabel*)[cell.contentView viewWithTag:101];
    label.text=cellData.showText;
    
    UIImageView *arrowImgv=(UIImageView*)[cell.contentView viewWithTag:102];
    arrowImgv.image=[UIImage imageNamed:cellData.arrowimgName];
    arrowImgv.hidden=!cellData.selected;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SectionData *section=[_tableData sectionAtIndex:indexPath.section];
    SelectData *cellData=(SelectData*)[section cellAtIndex:indexPath.row];
    
    self.selectedItem=cellData.item;
    
    [self reloadData];
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedChoice:selectview:)]) {
        [_delegate didSelectedChoice:_selectedItem selectview:self];
    }else if (_selectBlock){
        _selectBlock(self, _selectedItem);
    }
    
    [self disMissAnimated:YES];
}

- (id)initWithContentArray:(NSArray*)conArray selected:(id)item getNameBlock:(getShowName)showblock selectBlock:(didSelectedOption)selectblock {
    
    if (self=[super init]) {
        
        self.contentArr=conArray;
        self.getShowBlock=showblock;
        self.selectBlock=selectblock;
        self.selectedItem=item;
        
        
        self.frame=[UIScreen mainScreen].bounds;
        self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, MIN(conArray.count*44, 300))];
        
        
        [self sendSubviewToBack:_contentView];
        _tableView.frame=_contentView.frame;
        _tableView.separatorColor=[UIColor clearColor];
        
        [self reloadData];
    }
    
    
    return self;
}

- (id)initWithContentArray:(NSArray*)conArray selected:(id)item getNameBlock:(getShowName)showblock delegate:(id)delegate {
    self = [self initWithContentArray:conArray selected:item getNameBlock:showblock selectBlock:nil];
    
    if (self) {
        self.delegate=delegate;
    }
    
    return self;
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    
    CGRect frame = self.contentView.frame;
    frame.origin = CGPointMake(0.0, self.bounds.size.height);
    self.contentView.frame = frame;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, g_screenWidth/2, self.bounds.size.height+self.contentView.bounds.size.height/2);
    CGPathAddLineToPoint(path, nil, g_screenWidth/2, self.bounds.size.height-self.contentView.bounds.size.height/2-10);
    CGPathAddLineToPoint(path, nil, g_screenWidth/2, self.bounds.size.height-self.contentView.bounds.size.height/2);
    
    CAKeyframeAnimation *fanimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    fanimation.path=path;
    fanimation.duration=0.4;
    fanimation.delegate=nil;
    fanimation.fillMode = kCAFillModeForwards;
    fanimation.calculationMode = kCAAnimationPaced;
    fanimation.removedOnCompletion = YES;
    [self.contentView.layer addAnimation:fanimation forKey:nil];
    self.contentView.frame=CGRectMake(0, g_screenHeight-self.contentView.bounds.size.height, self.contentView.frame.size.width, self.contentView.frame.size.height);
    _tableView.frame=CGRectMake(0, g_screenHeight-self.contentView.bounds.size.height, self.contentView.frame.size.width, self.contentView.frame.size.height);
    
    self.alpha=0;
    [UIView animateWithDuration:0.3 animations:^(){self.alpha=1;}];
    
    //add
    UIButton *disbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    disbutton.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-_contentView.frame.size.height);
    [disbutton addTarget:self action:@selector(disAppear) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:disbutton];
}

- (void) disMissAnimated:(BOOL)animated {
    
    if(animated){
        [UIView beginAnimations:@"myselectionviewremoveFromSuperviewWithAnimation" context:nil];
        
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        CGRect frame = self.contentView.frame;
        frame.origin = CGPointMake(0.0, self.bounds.size.height);
        self.contentView.frame = frame;
        
        [UIView commitAnimations];
    }else{
        CGRect frame = self.contentView.frame;
        frame.origin = CGPointMake(0.0, self.bounds.size.height);
        self.contentView.frame = frame;
        [self removeView];
    }
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([animationID isEqualToString:@"myselectionviewremoveFromSuperviewWithAnimation"]) {
        [self removeView];
    }
}

- (void)disAppear {
    [self disMissAnimated:YES];
}

- (void)removeView {
    _tableView.delegate=nil;
    if (self && self.superview) {
        [self removeFromSuperview];
    }
}

@end

@implementation SelectData

@end
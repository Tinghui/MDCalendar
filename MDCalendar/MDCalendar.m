//
//  MDCalendar.m
//
//
//  Copyright (c) 2014 Michael DiStefano
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "MDCalendar.h"
#import "MDCalendarViewCell.h"
#import "MDCalendarHeaderView.h"

#define DAYS_IN_WEEK 7
#define MONTHS_IN_YEAR 12
#define MDCalendarCellWidth() (floor(CGRectGetWidth(_collectionView.bounds) / DAYS_IN_WEEK) \
                                - kMDCalendarViewItemSpacing)


static NSString * const kMDCalendarViewCellIdentifier = @"kMDCalendarViewCellIdentifier";
static NSString * const kMDCalendarHeaderViewIdentifier = @"kMDCalendarHeaderViewIdentifier";


@interface MDCalendar () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, assign) NSDate *currentDate;
@end


// Default spacing
static CGFloat const kMDCalendarViewItemSpacing    = 0.f;
static CGFloat const kMDCalendarViewLineSpacing    = 1.f;

@implementation MDCalendar

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing  = kMDCalendarViewItemSpacing;
        layout.minimumLineSpacing       = kMDCalendarViewLineSpacing;
        self.layout = layout;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate   = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.allowsMultipleSelection = NO;
        
        [_collectionView registerClass:[MDCalendarViewCell class]
            forCellWithReuseIdentifier:kMDCalendarViewCellIdentifier];
        [_collectionView registerClass:[MDCalendarHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:kMDCalendarHeaderViewIdentifier];

        // Default Configuration
        self.startDate      = _currentDate;
        self.selectedDate   = _startDate;
        self.endDate        = [[_startDate dateByAddingMonths:3] lastDayOfMonth];
        
        self.dayFont        = [UIFont systemFontOfSize:17];
        
        self.cellBackgroundColor    = nil;
        self.highlightColor         = self.tintColor;
        self.indicatorColor         = [UIColor lightGrayColor];
        
        self.headerBackgroundColor  = nil;
        self.headerFont             = [UIFont systemFontOfSize:20];
        
        self.textColor          = [UIColor darkGrayColor];
        self.headerTextColor    = _textColor;
        self.weekdayTextColor   = _textColor;
        
        self.canSelectDaysBeforeStartDate = YES;
        
        [self addSubview:_collectionView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _collectionView.frame = self.bounds;
    [self scrollCalendarToDate:_selectedDate animated:NO];
}

- (void)reloadData
{
    if (self.collectionView.isTracking
        || self.collectionView.isDragging
        || self.collectionView.isDecelerating) {
        return;
    }
    [self.collectionView reloadData];
}

#pragma mark - Custom Accessors
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _collectionView.backgroundColor = backgroundColor;
}

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    _collectionView.contentInset = contentInset;
}

- (void)setItemSpacing:(CGFloat)itemSpacing
{
    _layout.minimumInteritemSpacing = itemSpacing;
}

- (void)setLineSpacing:(CGFloat)lineSpacing
{
    _layout.minimumLineSpacing = lineSpacing;
}

- (CGFloat)lineSpacing
{
    return _layout.minimumLineSpacing;
}

- (NSDate *)currentDate
{
    return [NSDate date];
}

#pragma mark - Public Methods

- (void)scrollCalendarToDate:(NSDate *)date animated:(BOOL)animated
{
    UICollectionView *collectionView = _collectionView;
    NSIndexPath *indexPath = [self _indexPathForDate:date];
    NSSet *visibleIndexPaths = [NSSet setWithArray:[collectionView indexPathsForVisibleItems]];
    if (indexPath && [visibleIndexPaths count] > 0 && ![visibleIndexPaths containsObject:indexPath]) {
        [self _scrollCalendarToTopOfSection:indexPath.section animated:animated];
    }
}

#pragma mark - Private Methods & Helper Functions
- (NSInteger)_monthForSection:(NSInteger)section
{
    NSDate *firstDayOfMonth = [self _dateForFirstDayOfSection:section];
    return [firstDayOfMonth month];
}

- (NSDate *)_dateForFirstDayOfSection:(NSInteger)section
{
    return [[_startDate firstDayOfMonth] dateByAddingMonths:section];
}

- (NSDate *)_dateForLastDayOfSection:(NSInteger)section
{
    NSDate *firstDayOfMonth = [self _dateForFirstDayOfSection:section];
    return [firstDayOfMonth lastDayOfMonth];
}

- (NSInteger)_offsetForSection:(NSInteger)section
{
    NSDate *firstDayOfMonth = [self _dateForFirstDayOfSection:section];
    return [firstDayOfMonth weekday] - 1;
}

- (NSInteger)_remainderForSection:(NSInteger)section
{
    NSDate *lastDayOfMonth = [self _dateForLastDayOfSection:section];
    NSInteger weekday = [lastDayOfMonth weekday];
    return DAYS_IN_WEEK - weekday;
}

- (NSDate *)_dateForIndexPath:(NSIndexPath *)indexPath
{
    NSDate *date = [_startDate dateByAddingMonths:indexPath.section];
    NSDateComponents *components = [date components];
    components.day = indexPath.item + 1;
    date = [NSDate dateFromComponents:components];
    
    NSInteger offset = [self _offsetForSection:indexPath.section];
    if (offset) {
        date = [date dateByAddingDays:-offset];
    }
    
    return date;
}

- (NSIndexPath *)_indexPathForDate:(NSDate *)date
{
    NSIndexPath *indexPath = nil;
    if (date) {
        NSDate *firstDayOfCalendar = [_startDate firstDayOfMonth];
        NSInteger section = [firstDayOfCalendar numberOfMonthsUntilEndDate:date];
        NSInteger dayOffset = [self _offsetForSection:section];
        NSInteger dayIndex = [date day] + dayOffset - 1;
        indexPath = [NSIndexPath indexPathForItem:dayIndex inSection:section];
    }
    return indexPath;
}

- (CGRect)_frameForHeaderForSection:(NSInteger)section
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:section];
    UICollectionViewLayoutAttributes *attributes = [_collectionView layoutAttributesForItemAtIndexPath:indexPath];
    CGRect frameForFirstCell = attributes.frame;
    CGFloat headerHeight = [self collectionView:_collectionView
                                         layout:_layout
                referenceSizeForHeaderInSection:section].height;
    return CGRectOffset(frameForFirstCell, 0, -headerHeight);
}

- (void)_scrollCalendarToTopOfSection:(NSInteger)section animated:(BOOL)animated
{
    CGRect headerRect = [self _frameForHeaderForSection:section];
    CGPoint topOfHeader = CGPointMake(0, headerRect.origin.y - _collectionView.contentInset.top);
    [_collectionView setContentOffset:topOfHeader animated:animated];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [_startDate numberOfMonthsUntilEndDate:_endDate] + 1;    // Adding 1 necessary to show month of end date
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSDate *firstDayOfMonth = [self _dateForFirstDayOfSection:section];
    NSInteger month = [firstDayOfMonth month];
    NSInteger year  = [firstDayOfMonth year];
    return ([NSDate numberOfDaysInMonth:month forYear:year]
            + [self _offsetForSection:section]
            + [self _remainderForSection:section]);
}

#pragma mark - UICollectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *date = [self _dateForIndexPath:indexPath];
    
    MDCalendarViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMDCalendarViewCellIdentifier
                                                                         forIndexPath:indexPath];
    cell.backgroundColor = _cellBackgroundColor;
    cell.font = _dayFont;
    cell.textColor = ([date isEqualToDateSansTime:[self currentDate]]? _highlightColor : _textColor);
    cell.date = date;
    cell.highlightColor = _highlightColor;
    cell.borderHeight = 1.0f;
    cell.borderColor = _borderColor;
    
    NSInteger sectionMonth = [self _monthForSection:indexPath.section];
    cell.userInteractionEnabled = [self collectionView:collectionView shouldSelectItemAtIndexPath:indexPath];
    // Disable non-selectable cells
    if (!cell.userInteractionEnabled) {
        cell.textColor = ([date isEqualToDateSansTime:[self currentDate]]?
                          cell.textColor:
                          [cell.textColor colorWithAlphaComponent:0.2]);
        
        // If the cell is outside the selectable range, and it is not today, tell the user
        // that it is an invalid date ("dimmed" is what Apple uses for disabled buttons).
        if (![date isEqualToDateSansTime:_selectedDate]) {
            cell.accessibilityLabel = [cell.accessibilityLabel stringByAppendingString:@", dimmed"];
        }
    }
    
    BOOL showIndicator = NO;
    if ([_delegate respondsToSelector:@selector(calendarView:shouldShowIndicatorForDate:)]) {
        showIndicator = [_delegate calendarView:self shouldShowIndicatorForDate:date];
    }
    
    // Handle showing cells outside of current month
    cell.accessibilityElementsHidden = NO;
    if ([date month] != sectionMonth) {
        // placeholder cell before 1st day of section month
        cell.userInteractionEnabled = NO;
        if (_showsDaysOutsideCurrentMonth) {
            cell.backgroundColor = [cell.backgroundColor colorWithAlphaComponent:0.2];
        }
        else {
            showIndicator = NO;
            cell.label.text = nil;
            cell.borderColor = [UIColor clearColor];
            cell.accessibilityElementsHidden = YES;
        }
        
    }
    else if ([date isEqualToDateSansTime:_selectedDate]) {
        // Handle cell selection
        cell.selected = YES;
    }
    
    cell.indicatorColor = (showIndicator? _indicatorColor: [UIColor clearColor]);
    
    if ([self.delegate respondsToSelector:@selector(calendarView:dayOfMonthWillDisplay:)]) {
        NSDate *date = [self _dateForFirstDayOfSection:indexPath.section];
        [self.delegate calendarView:self dayOfMonthWillDisplay:date];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        
        MDCalendarHeaderView *headerView =
            [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                               withReuseIdentifier:kMDCalendarHeaderViewIdentifier
                                                      forIndexPath:indexPath];
        headerView.backgroundColor = _headerBackgroundColor;
        headerView.font = _headerFont;
        headerView.textColor = _headerTextColor;
        headerView.firstDayOfMonth = [self _dateForFirstDayOfSection:indexPath.section];
        //header text label on 1st date cell of the month
        NSInteger emptyHeading = [self _offsetForSection:indexPath.section];
        NSInteger emptyTailing = DAYS_IN_WEEK - 1 - emptyHeading;
        headerView.labelInset = UIEdgeInsetsMake(0, emptyHeading * MDCalendarCellWidth(),
                                                 0, emptyTailing * MDCalendarCellWidth());
        
        return headerView;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //unselect old cell
    NSIndexPath *oldIndexPath = [self _indexPathForDate:self.selectedDate];
    MDCalendarViewCell *oldCell = [collectionView cellForItemAtIndexPath:oldIndexPath];
    oldCell.selected = NO;
    
    //new cell play selection animtion
    MDCalendarViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell playSelectionAnimation];
    
    //mark selected date and call delegate
    self.selectedDate = [self _dateForIndexPath:indexPath];
    if ([_delegate respondsToSelector:@selector(calendarView:didSelectDate:)]) {
        [_delegate calendarView:self didSelectDate:self.selectedDate];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *date = [self _dateForIndexPath:indexPath];
    
    if ([date isBeforeDate:_startDate] && !_canSelectDaysBeforeStartDate) {
        return NO;
    }
    
    if ([_delegate respondsToSelector:@selector(calendarView:shouldSelectDate:)]) {
        return [_delegate calendarView:self shouldSelectDate:date];
    }
    
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView != self.collectionView) {
        return;
    }
    
    NSSet *visibleSections = [NSSet setWithArray:
                              [[self.collectionView indexPathsForVisibleItems] valueForKey:@"section"]];
    NSArray *sections = [[visibleSections allObjects]
                         sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                             return [obj1 compare:obj2];
                         }];
    
    if ([self.delegate respondsToSelector:@selector(calendarView:firstVisableDateDidChangeTo:)]) {
        NSDate *date = [self _dateForFirstDayOfSection:[[sections firstObject] integerValue]];
        [self.delegate calendarView:self firstVisableDateDidChangeTo:date];
    }
}

#pragma mark - UICollectionViewFlowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    const CGFloat cellWidth = MDCalendarCellWidth();
    return CGSizeMake(cellWidth, cellWidth);
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section
{
    CGFloat boundsWidth = collectionView.bounds.size.width;
    return CGSizeMake(boundsWidth, [MDCalendarHeaderView preferredHeightWithMonthLabelFont:_headerFont]);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    CGFloat boundsWidth = collectionView.bounds.size.width;
    CGFloat remainingPoints = boundsWidth - (MDCalendarCellWidth() * DAYS_IN_WEEK);
    return UIEdgeInsetsMake(0, remainingPoints / 2, _layout.minimumLineSpacing, remainingPoints / 2);
}

@end

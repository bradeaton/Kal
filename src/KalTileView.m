/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalTileView.h"
#import "KalDate.h"
#import "KalPrivate.h"

#define iPad    UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

extern const CGSize kTileSize;
extern const CGSize kTileSize_iPad;

@implementation KalTileView

@synthesize date;

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    origin = frame.origin;
    [self setIsAccessibilityElement:YES];
    [self setAccessibilityTraits:UIAccessibilityTraitButton];
    [self resetState];
  }
  return self;
}

- (void)drawRect:(CGRect)rect
{
  CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat fontSize;
    
    if (iPad) {
        fontSize = 48.f;
    } else {
        fontSize = 24.f;
    }
    
  UIFont *font = [UIFont boldSystemFontOfSize:fontSize];
  UIColor *shadowColor = nil;
  UIColor *textColor = nil;
  UIImage *markerImage = nil;
  CGContextSelectFont(ctx, [font.fontName cStringUsingEncoding:NSUTF8StringEncoding], fontSize, kCGEncodingMacRoman);
      
    CGContextTranslateCTM(ctx, 0, (iPad ? kTileSize_iPad.height : kTileSize.height));
  CGContextScaleCTM(ctx, 1, -1);
  
    if (iPad) {
        if ([self isToday] && self.selected) {
            [[[UIImage imageNamed:@"Kal.bundle/kal_tile_today_selected.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] drawInRect:CGRectMake(0, -1, (iPad ? kTileSize_iPad.width+1 : kTileSize.width+1), (iPad ? kTileSize_iPad.height+1 : kTileSize.height+1))];
            textColor = [UIColor whiteColor];
            shadowColor = [UIColor blackColor];
            markerImage = [UIImage imageNamed:@"Kal.bundle/kal_marker_today_iPad.png"];
        } else if ([self isToday] && !self.selected) {
            [[[UIImage imageNamed:@"Kal.bundle/kal_tile_today.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] drawInRect:CGRectMake(0, -1, (iPad ? kTileSize_iPad.width+1 : kTileSize.width+1), (iPad ? kTileSize_iPad.height+1 : kTileSize.height+1))];
            textColor = [UIColor whiteColor];
            shadowColor = [UIColor blackColor];
            markerImage = [UIImage imageNamed:@"Kal.bundle/kal_marker_today_iPad.png"];
        } else if (self.selected) {
            [[[UIImage imageNamed:@"Kal.bundle/kal_tile_selected.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0] drawInRect:CGRectMake(0, -1, (iPad ? kTileSize_iPad.width+1 : kTileSize.width+1), (iPad ? kTileSize_iPad.height+1 : kTileSize.height+1))];
            textColor = [UIColor whiteColor];
            shadowColor = [UIColor blackColor];
            markerImage = [UIImage imageNamed:@"Kal.bundle/kal_marker_selected_iPad.png"];
        } else if (self.belongsToAdjacentMonth) {
            textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Kal.bundle/kal_tile_dim_text_fill.png"]];
            shadowColor = nil;
            markerImage = [UIImage imageNamed:@"Kal.bundle/kal_marker_dim_iPad.png"];
        } else {
            textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Kal.bundle/kal_tile_text_fill.png"]];
            shadowColor = [UIColor whiteColor];
            markerImage = [UIImage imageNamed:@"Kal.bundle/kal_marker_iPad.png"];
        }
        
    } else {
        if ([self isToday] && self.selected) {
            [[[UIImage imageNamed:@"Kal.bundle/kal_tile_today_selected.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] drawInRect:CGRectMake(0, -1, (iPad ? kTileSize_iPad.width+1 : kTileSize.width+1), (iPad ? kTileSize_iPad.height+1 : kTileSize.height+1))];
            textColor = [UIColor whiteColor];
            shadowColor = [UIColor blackColor];
            markerImage = [UIImage imageNamed:@"Kal.bundle/kal_marker_today.png"];
        } else if ([self isToday] && !self.selected) {
            [[[UIImage imageNamed:@"Kal.bundle/kal_tile_today.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] drawInRect:CGRectMake(0, -1, (iPad ? kTileSize_iPad.width+1 : kTileSize.width+1), (iPad ? kTileSize_iPad.height+1 : kTileSize.height+1))];
            textColor = [UIColor whiteColor];
            shadowColor = [UIColor blackColor];
            markerImage = [UIImage imageNamed:@"Kal.bundle/kal_marker_today.png"];
        } else if (self.selected) {
            [[[UIImage imageNamed:@"Kal.bundle/kal_tile_selected.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0] drawInRect:CGRectMake(0, -1, (iPad ? kTileSize_iPad.width+1 : kTileSize.width+1), (iPad ? kTileSize_iPad.height+1 : kTileSize.height+1))];
            textColor = [UIColor whiteColor];
            shadowColor = [UIColor blackColor];
            markerImage = [UIImage imageNamed:@"Kal.bundle/kal_marker_selected.png"];
        } else if (self.belongsToAdjacentMonth) {
            textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Kal.bundle/kal_tile_dim_text_fill.png"]];
            shadowColor = nil;
            markerImage = [UIImage imageNamed:@"Kal.bundle/kal_marker_dim.png"];
        } else {
            textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Kal.bundle/kal_tile_text_fill.png"]];
            shadowColor = [UIColor whiteColor];
            markerImage = [UIImage imageNamed:@"Kal.bundle/kal_marker.png"];
        }
        
    }
  
//  if (flags.marked)
//    [markerImage drawInRect:CGRectMake(21.f, 5.f, 4.f, 5.f)];
    if (flags.marked) {
        if (iPad)
            [markerImage drawInRect:CGRectMake(51.f, 15.f, 8.f, 10.f)];
        else
            [markerImage drawInRect:CGRectMake(21.f, 5.f, 4.f, 5.f)];
    }

    
  NSUInteger n = [self.date day];
  NSString *dayText = [NSString stringWithFormat:@"%lu", (unsigned long)n];
  const char *day = [dayText cStringUsingEncoding:NSUTF8StringEncoding];
  CGSize textSize = [dayText sizeWithFont:font];
  CGFloat textX, textY;
    textX = roundf(0.5f * ((iPad ? kTileSize_iPad.width : kTileSize.width) - textSize.width));
    textY = 6.f + roundf(0.5f * ((iPad ? kTileSize_iPad.height : kTileSize.height) - textSize.height));
  if (shadowColor) {
    [shadowColor setFill];
    CGContextShowTextAtPoint(ctx, textX, textY, day, n >= 10 ? 2 : 1);
    textY += 1.f;
  }
  [textColor setFill];
  CGContextShowTextAtPoint(ctx, textX, textY, day, n >= 10 ? 2 : 1);
  
  if (self.highlighted) {
    [[UIColor colorWithWhite:0.25f alpha:0.3f] setFill];
      CGContextFillRect(ctx, CGRectMake(0.f, 0.f, (iPad ? kTileSize_iPad.width : kTileSize.width), (iPad ? kTileSize_iPad.height : kTileSize.height)));
  }
}

- (void)resetState
{
  // realign to the grid
  CGRect frame = self.frame;
  frame.origin = origin;
    frame.size = (iPad ? kTileSize_iPad : kTileSize);
  self.frame = frame;
  
  [date release];
  date = nil;
  flags.type = KalTileTypeRegular;
  flags.highlighted = NO;
  flags.selected = NO;
  flags.marked = NO;
}

- (void)setDate:(KalDate *)aDate
{
  if (date == aDate)
    return;

  [date release];
  date = [aDate retain];

  [self setNeedsDisplay];
}

- (BOOL)isSelected { return flags.selected; }

- (void)setSelected:(BOOL)selected
{
  if (flags.selected == selected)
    return;

  // workaround since I cannot draw outside of the frame in drawRect:
  if (![self isToday]) {
    CGRect rect = self.frame;
    if (selected) {
      rect.origin.x--;
      rect.size.width++;
      rect.size.height++;
    } else {
      rect.origin.x++;
      rect.size.width--;
      rect.size.height--;
    }
    self.frame = rect;
  }
  
  flags.selected = selected;
  [self setNeedsDisplay];
}

- (BOOL)isHighlighted { return flags.highlighted; }

- (void)setHighlighted:(BOOL)highlighted
{
  if (flags.highlighted == highlighted)
    return;
  
  flags.highlighted = highlighted;
  [self setNeedsDisplay];
}

- (BOOL)isMarked { return flags.marked; }

- (void)setMarked:(BOOL)marked
{
  if (flags.marked == marked)
    return;
  
  flags.marked = marked;
  [self setNeedsDisplay];
}

- (KalTileType)type { return flags.type; }

- (void)setType:(KalTileType)tileType
{
  if (flags.type == tileType)
    return;
  
  // workaround since I cannot draw outside of the frame in drawRect:
  CGRect rect = self.frame;
  if (tileType == KalTileTypeToday) {
    rect.origin.x--;
    rect.size.width++;
    rect.size.height++;
  } else if (flags.type == KalTileTypeToday) {
    rect.origin.x++;
    rect.size.width--;
    rect.size.height--;
  }
  self.frame = rect;
  
  flags.type = tileType;
  [self setNeedsDisplay];
}

- (BOOL)isToday { return flags.type == KalTileTypeToday; }

- (BOOL)belongsToAdjacentMonth { return flags.type == KalTileTypeAdjacent; }

- (void)dealloc
{
  [date release];
  [super dealloc];
}

@end

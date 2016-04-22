//
//  PMLabel.m
//  StillHot
//
//  Created by Maxim Popov popovme@gmail.com on 15.09.15.
//  Copyright (c) 2015 PopovME. All rights reserved.
//

#import "PMLabel.h"

@implementation PMLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)initialization {
    self.textInset = UIEdgeInsetsZero;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.numberOfLines != 1 && self.preferredMaxLayoutWidth > 0) {
        self.preferredMaxLayoutWidth = self.bounds.size.width - self.textInset.left - self.textInset.right;
    }
}


#pragma mark - Override

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect frame = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, self.textInset) limitedToNumberOfLines:numberOfLines];
    frame.origin.x -= self.textInset.left;
    frame.origin.y -= self.textInset.top;
    frame.size.width += (self.textInset.left + self.textInset.right);
    frame.size.height += (self.textInset.top + self.textInset.bottom);
    return frame;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.textInset)];
}

@end

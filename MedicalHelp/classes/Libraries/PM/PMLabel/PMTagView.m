//
//  PMTagView.m
//  MedicalHelp
//
//  Created by Maxim Popov popovme@gmail.com on 24.11.15.
//  Copyright © 2015 Popovme. All rights reserved.
//

#import "PMTagView.h"

static NSInteger const kTagsHeight = 30;
static NSInteger const kTagsSplitter = 12;
static NSInteger const kTagsTextIndent = 17;

@interface PMTagView ()

@property (nonatomic, strong) NSMutableArray *buttonTags;

@end

@implementation PMTagView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)initialization {
    self.buttonTags = [[NSMutableArray alloc] init];
}


#pragma mark - Public

- (void)setTags:(NSArray *)tags {
    for (UIView *view in self.buttonTags) {
        [view removeFromSuperview];
    }
    [self.buttonTags removeAllObjects];
    
    [tags enumerateObjectsUsingBlock:^(MBase *mBase, NSUInteger index, BOOL *stop) {
        if ([mBase isKindOfClass:[MBase class]]) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kTagsTextIndent * 2, kTagsHeight)];
            button.titleLabel.font = [UIFont helveticaNeueFontOfSize:16];
            button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            button.titleEdgeInsets = UIEdgeInsetsMake(0, kTagsTextIndent, 0, kTagsTextIndent);
            button.adjustsImageWhenHighlighted = NO;
            [button setTitleColor:[UIColor textDarkColor] forState:UIControlStateNormal];
            [button setTitle:mBase.title forState:UIControlStateNormal];
            [button addTarget:self action:@selector(actionTag:) forControlEvents:UIControlEventTouchUpInside];
            button.layer.cornerRadius = button.frame.size.height / 2;
            button.layer.borderWidth = 1;
            button.layer.borderColor = [UIColor bgTagsBorderColor].CGColor;
            button.tag = index;
            [self addSubview:button];
            [self.buttonTags addObject:button];
        }
    }];
    
    [self updateSubviews];
}


#pragma mark - Actions

- (void)actionTag:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(pmTagViewDidSelectTagIndex:)]) {
        [self.delegate pmTagViewDidSelectTagIndex:button.tag];
    }
}


#pragma mark - Work

- (void)updateSubviews {
    CGPoint position = CGPointZero;
    CGFloat maxWidth = self.bounds.size.width;
    CGFloat maxTextWidth = maxWidth - kTagsTextIndent * 2;
    for (UIButton *button in self.buttonTags) {
        NSDictionary *attr = @{NSFontAttributeName: button.titleLabel.font};
        NSString *title = [button titleForState:UIControlStateNormal];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:title attributes:attr];
        CGFloat textWidth = [text boundingRectWithSize:CGSizeMake(maxTextWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.width;
        CGFloat buttonWidth = textWidth + kTagsTextIndent * 2;
        if (position.x + buttonWidth > maxWidth) {
            position.y += (kTagsHeight + kTagsSplitter);
            position.x = 0;
        }
        button.frame = ({
            CGRect frame = button.frame;
            frame.size.width = buttonWidth;
            frame.origin = position;
            frame;
        });
        position.x += (buttonWidth + kTagsSplitter);
    }
    self.frame = ({
        CGRect frame = self.frame;
        frame.size.height = position.y + kTagsHeight;
        frame;
    });
}

@end

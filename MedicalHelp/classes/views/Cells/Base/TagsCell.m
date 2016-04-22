//
//  TagsCell.m
//  MedicalHelp
//
//  Created by Maxim Popov popovme@gmail.com on 24.11.15.
//  Copyright © 2015 Popovme. All rights reserved.
//

#import "TagsCell.h"

#import "PMTagView.h"

@interface TagsCell () <PMTagViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet PMTagView *tagsView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint* tagsHeightConstraint;

@end

@implementation TagsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.font = [UIFont helveticaNeueFontOfSize:18];
    self.titleLabel.textColor = [UIColor textDarkColor];
    
    self.tagsView.delegate = self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.titleLabel.text = nil;
}


#pragma mark - Public

- (void)setTags:(NSArray *)tags {
    if (tags.count > 0) {
        MBase *firstMData = tags.firstObject;
        
        if ([firstMData isKindOfClass:[MSymptom class]]) {
            self.titleLabel.text = @"Симптомы";
        } else if ([firstMData isKindOfClass:[MDisease class]]) {
            self.titleLabel.text = @"Заболевания";
        } else {
            self.titleLabel.text = @"Лекарства";
        }
        
        [self.tagsView setTags:tags];
        
        self.tagsHeightConstraint.constant = self.tagsView.frame.size.height;
        
        [self layoutIfNeeded];
    }
}


#pragma mark - PMTagViewDelegate

- (void)pmTagViewDidSelectTagIndex:(NSInteger)tagIndex {
    if ([self.delegate respondsToSelector:@selector(tagCell:didSelectTagIndex:)]) {
        [self.delegate tagCell:self didSelectTagIndex:tagIndex];
    }
}

@end

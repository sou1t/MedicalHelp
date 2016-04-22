//
//  DescriptionCell.m
//  MedicalHelp
//
//  Created by Maxim Popov popovme@gmail.com on 24.11.15.
//  Copyright © 2015 Popovme. All rights reserved.
//

#import "DescriptionCell.h"

#import "PMAString.h"

@interface DescriptionCell ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *iconView;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint* imageHeightConstraint;

@end

@implementation DescriptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.font = [UIFont helveticaNeueFontOfSize:20];
    self.titleLabel.textColor = [UIColor textDarkColor];
    
    self.descriptionLabel.font = [UIFont helveticaNeueFontOfSize:14];
    self.descriptionLabel.textColor = [UIColor textDarkColor];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.titleLabel.text = nil;
    self.descriptionLabel.text = nil;
    self.iconView.image = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}


#pragma mark - Public

- (void)setMData:(MBase *)mData {
    self.titleLabel.text = mData.title;
    
    UIImage *image = nil;
    if (mData.image.length > 0) {
        image = [UIImage imageNamed:mData.image];
    }
    
    if (image) {
        CGFloat scale = [UIScreen mainScreen].scale;
        CGSize imageSize = CGSizeMake(image.size.width / scale, image.size.height / scale);
        CGFloat factor = MIN(1, (self.iconView.frame.size.width / imageSize.width));
        self.imageHeightConstraint.constant = 20 + imageSize.height * factor;
        self.iconView.image = image;
    } else {
        self.iconView.image = nil;
        self.imageHeightConstraint.constant = 0;
    }
    
    if ([mData isKindOfClass:[MFirstAid class]]) {
        self.descriptionLabel.attributedText = [PMAString attributedString:mData.text];
    } else {
        self.descriptionLabel.text = mData.text;
    }
    
    [self layoutIfNeeded];
}

@end

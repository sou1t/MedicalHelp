//
//  MainCell.m
//  MedicalHelp
//
//  Created by Maxim Popov popovme@gmail.com on 23.11.15.
//  Copyright © 2015 Popovme. All rights reserved.
//

#import "MainCell.h"

@interface MainCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation MainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.font = [UIFont helveticaNeueFontOfSize:16];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.titleLabel.text = nil;
}


#pragma mark - Public

- (void)setMData:(MBase *)mData {
    self.titleLabel.text = mData.title;
    if ([mData isKindOfClass:[MFirstAid class]]) {
        self.titleLabel.textColor = [UIColor textLightColor];
    } else {
        self.titleLabel.textColor = [UIColor textDarkColor];
    }
}

@end

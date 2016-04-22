//
//  TagsCell.h
//  MedicalHelp
//
//  Created by Maxim Popov popovme@gmail.com on 24.11.15.
//  Copyright © 2015 Popovme. All rights reserved.
//

#import "BaseCell.h"

@protocol TagsCellDelegate;

@interface TagsCell : BaseCell

@property (nonatomic, weak) id<TagsCellDelegate> delegate;

- (void)setTags:(NSArray *)tags;

@end

@protocol TagsCellDelegate <NSObject>

@optional
- (void)tagCell:(TagsCell *)tagCell didSelectTagIndex:(NSInteger)tagIndex;

@end

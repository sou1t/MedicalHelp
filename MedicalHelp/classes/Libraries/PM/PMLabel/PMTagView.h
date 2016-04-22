//
//  PMTagView.h
//  MedicalHelp
//
//  Created by Maxim Popov popovme@gmail.com on 24.11.15.
//  Copyright © 2015 Popovme. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PMTagViewDelegate;

@interface PMTagView : UIView

@property (nonatomic, weak) id<PMTagViewDelegate> delegate;

- (void)setTags:(NSArray *)tags;

@end

@protocol PMTagViewDelegate <NSObject>

@optional
- (void)pmTagViewDidSelectTagIndex:(NSInteger)tagIndex;

@end

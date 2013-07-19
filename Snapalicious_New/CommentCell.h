//
//  CommentCell.h
//  momentsapp
//
//  Created by M.A.D on 3/9/12.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : PFTableViewCell

@property (nonatomic, weak) IBOutlet UIImageView   *photoView;
@property (nonatomic, weak) IBOutlet UILabel       *infoLabel;
@property (nonatomic, weak) IBOutlet UILabel       *createdAt;

@end

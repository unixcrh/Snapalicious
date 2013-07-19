//
//  CommentCell.m
//  momentsapp
//
//  Created by M.A.D on 3/9/12.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //top shadow
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

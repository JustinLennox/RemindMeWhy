//
//  PushNoAnimationSegue.m
//  Remind Me Why
//
//  Created by Justin Lennox on 4/6/15.
//  Copyright (c) 2015 Justin Lennox. All rights reserved.
//

#import "PushNoAnimationSegue.h"

@implementation PushNoAnimationSegue

-(void)perform{
    [[[self sourceViewController] navigationController] pushViewController:[self destinationViewController] animated:NO];
}

@end

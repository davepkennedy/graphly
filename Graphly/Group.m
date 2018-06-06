//
//  Group.m
//  Graphly
//
//  Created by Dave Kennedy on 30/05/2018.
//  Copyright © 2018 Dave Kennedy. All rights reserved.
//

#import "Node.h"
#import "Group.h"

@implementation Group {
    NSMutableArray<NSUUID*>* _nodes;
}

@synthesize identifier;
@synthesize nodes = _nodes;

- (instancetype) init {
    self = [super init];
    if (self) {
        _nodes = [NSMutableArray array];
    }
    return self;
}

- (void) addNode:(Node*)node
{
    [_nodes addObject:node.identifier];
    node.group = self.identifier;
}

- (void) removeNode:(Node*)node
{
    [_nodes removeObject:node.identifier];
}

@end

//
//  GraphView.h
//  Graphly
//
//  Created by Dave Kennedy on 08/05/2018.
//  Copyright © 2018 Dave Kennedy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NodeView.h"
#import "Graph.h"

@protocol GraphViewDelegate
- (Graph*) graph;
- (void) activeNode:(Node*)node;
@end

@interface GraphView : NSView<NSTableViewDataSource> {
    NSMutableArray<NodeView*>* nodes;
    NodeView* _activeNode;
}

@property IBOutlet NSTableView* tableView;
@property IBOutlet id<GraphViewDelegate> delegate;

- (NodeView*) activeNode;
- (void) setActiveNode:(NodeView*)node;

- (IBAction)dataUpdated:(id)sender;

@end

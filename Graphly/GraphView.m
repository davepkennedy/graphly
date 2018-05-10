//
//  GraphView.m
//  Graphly
//
//  Created by Dave Kennedy on 08/05/2018.
//  Copyright © 2018 Dave Kennedy. All rights reserved.
//

#import "GraphView.h"
#include <Carbon/Carbon.h>
#import "NSBezierPath+Arrowhead.h"

@implementation GraphView

- (void) awakeFromNib {
    nodes = [NSMutableArray array];
    NSMutableDictionary* nodeLookup = [NSMutableDictionary dictionary];
    for (Node* node in self.delegate.graph.nodes) {
        NodeView* nodeView = [[NodeView alloc] initNode:node withPosition:node.position];
        [nodes addObject:nodeView];
        [self addSubview:nodeView];
        
        [nodeLookup setObject:nodeView forKey:node.identifier];
    }
    for (NodeView* node in nodes) {
        NSMutableArray* connections = [NSMutableArray array];
        for (NSUUID* uuid in node.node.connections) {
            [connections addObject:[nodeLookup objectForKey:uuid]];
        }
        [node setConnections:connections];
    }
}

- (BOOL) acceptsFirstResponder {
    return YES;
}

- (IBAction)dataUpdated:(id)sender {
    [self.activeNode setNeedsLayout:YES];
    [self.activeNode setNeedsDisplay:YES];
    
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    CGFloat lineWidth = NSBezierPath.defaultLineWidth;
    NSBezierPath.defaultLineWidth = 3;
    [[NSColor grayColor] setStroke];
    for (NodeView* node in nodes) {
        for (NodeView* connection in node.connections) {
            //[NSBezierPath strokeLineFromPoint:node.anchor toPoint:server.anchor];
            NSBezierPath* path = [NSBezierPath bezierPathWithArrowFromPoint:node.anchor
                                                                    toPoint:connection.anchor
                                                                  tailWidth:2
                                                                  headWidth:9
                                                                 headLength:18];
            [path stroke];
        }
    }
    NSBezierPath.defaultLineWidth = lineWidth;
}

- (NodeView*) activeNode {
    return _activeNode;
}

- (void) setActiveNode:(NodeView*)node {
    _activeNode.color = [NSColor redColor];
    [_activeNode setNeedsDisplay:YES];
    _activeNode = node;
    _activeNode.color = [NSColor greenColor];
    [_activeNode setNeedsDisplay:YES];
    
    [self.tableView reloadData];
    
    [self.delegate activeNode:node.node];
}

- (void) keyDown:(NSEvent *)event {
    if (event.keyCode == kVK_ANSI_N) {
    }
}

- (void) mouseDown:(NSEvent *)event {
    Node* node = [self.delegate.graph newNode];
    NodeView* nodeView = [[NodeView alloc] initNode:node withPosition:event.locationInWindow];
    [nodes addObject:nodeView];
    [self addSubview:nodeView];
    [self setActiveNode:nodeView];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [_activeNode numberOfProperties];
}

- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)row
{
    return [_activeNode property:tableColumn.headerCell.title forItem:row];
}

- (void)tableView:(NSTableView *)tableView
   setObjectValue:(id)object
   forTableColumn:(NSTableColumn *)tableColumn
              row:(NSInteger)row
{
    [_activeNode newValue:object forProperty:tableColumn.headerCell.title forItem:row];
}

@end

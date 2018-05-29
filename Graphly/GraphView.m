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

#define NODE_SIZE 20
#define LINE_WIDTH 2

@interface GraphView(private)
- (void) addNewNodeAt:(NSPoint) point;
- (void) drawNode:(Node*) node withFillColor:(NSColor*) color;
- (Node*) itemClicked:(NSPoint) point;
@end

@implementation GraphView {
    NSPoint dragStartLocation;
}

- (BOOL) isFlipped {
    return YES;
}

- (void) awakeFromNib {
    // nodes = [NSMutableArray array];
    NSMutableDictionary* nodeLookup = [NSMutableDictionary dictionary];
    /*
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
    */
}

- (BOOL) acceptsFirstResponder {
    return YES;
}

/*
- (NSSize) intrinsicContentSize {
    float maxWidth = self.bounds.size.width;
    float maxHeight = self.bounds.size.height;
    
    for (NodeView* view in nodes) {
        float width = view.frame.origin.x + view.frame.size.width;
        float height = view.frame.origin.y + view.frame.size.height;
        
        if (width > maxWidth) {
            maxWidth = width;
        }
        if (height > maxHeight) {
            maxHeight = height;
        }
    }
    
    return NSMakeSize(maxWidth, maxHeight);
}
*/

- (IBAction)dataUpdated:(id)sender {
    [self setNeedsDisplay:YES];
}

NSRect nodeRect (Node* node) {
    float offs = NODE_SIZE/2;
    return NSMakeRect (node.position.x - offs, node.position.y - offs,
                       NODE_SIZE, NODE_SIZE);
}

- (void) drawNode:(Node*) node withFillColor:(NSColor*) color {
    NSRect bounds = nodeRect(node);
    bounds.origin.x += LINE_WIDTH;
    bounds.origin.y += LINE_WIDTH;
    bounds.size.width -= LINE_WIDTH * 2;
    bounds.size.height -= LINE_WIDTH * 2;
    NSBezierPath* oval = [NSBezierPath bezierPathWithOvalInRect:bounds];
    oval.lineWidth = LINE_WIDTH;
    [color setFill];
    [oval fill];
    [[NSColor blackColor] setStroke];
    [oval stroke];
    
    [node.name drawInRect:NSMakeRect(bounds.origin.x + NODE_SIZE, bounds.origin.y, self.bounds.size.width, NODE_SIZE) withAttributes:NULL];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    CGFloat lineWidth = NSBezierPath.defaultLineWidth;
    NSBezierPath.defaultLineWidth = 3;
    [[NSColor grayColor] setStroke];
    for (Node* node in self.delegate.graph.nodes) {
        [self drawNode:node withFillColor:node==_activeNode ? NSColor.greenColor : NSColor.redColor];
        /*
        for (NodeView* connection in node.connections) {
            //[NSBezierPath strokeLineFromPoint:node.anchor toPoint:server.anchor];
            NSBezierPath* path = [NSBezierPath bezierPathWithArrowFromPoint:node.anchor
                                                                    toPoint:connection.anchor
                                                                  tailWidth:2
                                                                  headWidth:9
                                                                 headLength:18];
            [path stroke];
        }
        */
    }
    NSBezierPath.defaultLineWidth = lineWidth;
}

- (Node*) activeNode {
    return _activeNode;
}

- (void) setActiveNode:(Node*)node {
    _activeNode = node;
    
    [self.tableView reloadData];
    
    [self.delegate activeNode:node];
    [self setNeedsDisplay:YES];
}

- (void) addNewNodeAt:(NSPoint) point
{
    Node* node = [self.delegate.graph newNode];
    node.position = point;
    [self setActiveNode:node];
    [self setNeedsDisplay:YES];
    [self setNeedsLayout:YES];
}

static BOOL pointInNode (NSPoint pt, Node* node) {
    NSRect bounds = nodeRect(node);
    BOOL inRect = NSPointInRect(pt, bounds);
    return inRect;
}

- (Node*) itemClicked:(NSPoint) point {
    Node* item = nil;
    for (Node* node in self.delegate.graph.nodes) {
        if (pointInNode(point, node)) {
            item = node;
            break;
        }
    }
    return item;
}

- (void) mouseDown:(NSEvent *)event {
    NSPoint point = [self convertPoint:event.locationInWindow fromView:nil];
    if ((event.modifierFlags & NSEventModifierFlagShift) == NSEventModifierFlagShift) {
        Node* itemClicked = [self itemClicked:point];
        if (itemClicked) {
            [self.delegate connect:self.activeNode to:itemClicked];
        } else {
            [self addNewNodeAt:point];
        }
    } else {
        [self setActiveNode:[self itemClicked:point]];
        
        dragStartLocation = point;
    }
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

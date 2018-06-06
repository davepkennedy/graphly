//
//  GraphView.m
//  Graphly
//
//  Created by Dave Kennedy on 08/05/2018.
//  Copyright © 2018 Dave Kennedy. All rights reserved.
//

#import "GraphView.h"
#include <math.h>
#include <Carbon/Carbon.h>
#import "Group.h"
#import "Node.h"
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
    Node* draggingItem;
}

- (BOOL) isFlipped {
    return YES;
}

- (BOOL) acceptsFirstResponder {
    return YES;
}

- (void) awakeFromNib {
    // nodes = [NSMutableArray array];
    // NSMutableDictionary* nodeLookup = [NSMutableDictionary dictionary];
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

NSRect adjustGroupRect(NSRect rect, Node* node)
{
    NSRect nr = nodeRect(node);
    float l = nr.origin.x < rect.origin.x ? nr.origin.x : rect.origin.x;
    float t = nr.origin.y < rect.origin.y ? nr.origin.y : rect.origin.y;
    
    float r1 = rect.origin.x + rect.size.width;
    float r2 = nr.origin.x + nr.size.width;
    float b1 = rect.origin.y + rect.size.height;
    float b2 = nr.origin.y + nr.size.height;
    
    float r = r1 > r2 ? r1 : r2;
    float b = b1 > b2 ? b1 : b2;
    
    return NSMakeRect(l, t, r-l, b-t);
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
    for (Group* group in self.delegate.graph.groups) {
        NSRect groupRect = nodeRect([self.delegate.graph nodeForID:group.nodes.firstObject]);
        for (NSUUID* nodeId in group.nodes) {
            groupRect = adjustGroupRect(groupRect, [self.delegate.graph nodeForID:nodeId]);
        }
        NSBezierPath* path = [NSBezierPath bezierPathWithRoundedRect:groupRect xRadius:10 yRadius:10];
        [path stroke];
    }
    for (Node* node in self.delegate.graph.nodes) {
        for (NSUUID* connection in node.connections) {
            //[NSBezierPath strokeLineFromPoint:node.anchor toPoint:server.anchor];
            Node* connectedNode = [self.delegate.graph nodeForID:connection];
            NSBezierPath* path = [NSBezierPath bezierPathWithArrowFromPoint:node.position
                                                                    toPoint:connectedNode.position
                                                                  tailWidth:2
                                                                  headWidth:9
                                                                 headLength:18];
            [path stroke];
        }
        [self drawNode:node withFillColor:[self.delegate nodeIsActive:node] ? NSColor.greenColor : NSColor.redColor];
    }
    NSBezierPath.defaultLineWidth = lineWidth;
}

- (Node*) activeNode {
    return _activeNode;
}

- (void) addNewNodeAt:(NSPoint) point
{
    Node* node = [self.delegate.graph newNode];
    node.position = point;
    [self.delegate setActiveNode:node];
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

- (void) commandKeyDown:(NSEvent*)event {
    switch ([event.charactersIgnoringModifiers characterAtIndex:0]) {
        case 'g':
            [self.delegate createGroup];
            break;
        case 'u':
            [self.delegate ungroup];
            break;
    }
}

- (void) keyDown:(NSEvent *)event {
    
    if ((event.modifierFlags & NSEventModifierFlagCommand) == NSEventModifierFlagCommand) {
        [self commandKeyDown:event];
    }
}

- (void) mouseDown:(NSEvent *)event {
    NSPoint point = [self convertPoint:event.locationInWindow fromView:nil];
    Node* itemClicked = [self itemClicked:point];
    if ((event.modifierFlags & NSEventModifierFlagCommand) == NSEventModifierFlagCommand) {
        if (itemClicked) {
            [self.delegate connectTo:itemClicked];
        } else {
            [self addNewNodeAt:point];
        }
    } else if ((event.modifierFlags & NSEventModifierFlagShift) == NSEventModifierFlagShift) {
        [self.delegate addActiveNode:itemClicked];
    } else {
        if (![self.delegate nodeIsActive:itemClicked]) {
            [self.delegate setActiveNode:itemClicked];
        }
        
        draggingItem = itemClicked;
        dragStartLocation = point;
    }
    [self setNeedsDisplay:YES];
}

- (void) mouseDragged:(NSEvent *)event {
    NSLog(@"Dragged x %f y %f", event.deltaX, event.deltaY);
    if (draggingItem) {
        for (Node* node in self.delegate.graph.nodes) {
            if ([self.delegate nodeIsActive:node]) {
                
                node.position = NSMakePoint(node.position.x + event.deltaX,
                                            node.position.y + event.deltaY);
            }
        }
        [self setNeedsDisplay:YES];
    }
}

- (void) mouseUp:(NSEvent *)event {
    draggingItem = nil;
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

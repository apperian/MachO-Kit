//----------------------------------------------------------------------------//
//|
//|             MachOKit - A Lightweight Mach-O Parsing Library
//|             MKRebaseOpcode.m
//|
//|             D.V.
//|             Copyright (c) 2014-2015 D.V. All rights reserved.
//|
//| Permission is hereby granted, free of charge, to any person obtaining a
//| copy of this software and associated documentation files (the "Software"),
//| to deal in the Software without restriction, including without limitation
//| the rights to use, copy, modify, merge, publish, distribute, sublicense,
//| and/or sell copies of the Software, and to permit persons to whom the
//| Software is furnished to do so, subject to the following conditions:
//|
//| The above copyright notice and this permission notice shall be included
//| in all copies or substantial portions of the Software.
//|
//| THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//| OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//| MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//| IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
//| CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
//| TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//| SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//----------------------------------------------------------------------------//

#import "MKRebaseCommand.h"
#import "MKInternal.h"
#import "MKRebaseInfo.h"

//----------------------------------------------------------------------------//
@implementation MKRebaseCommand

//|++++++++++++++++++++++++++++++++++++|//
+ (id*)_subclassesCache
{ static NSSet *subclasses; return &subclasses; }

//|++++++++++++++++++++++++++++++++++++|//
+ (uint32_t)canInstantiateWithOpcode:(uint8_t)opcode
{
    @try {
        return (opcode == [self opcode]) ? 10 : 0;
    }
    @catch (NSException *exception) {
        return 0;
    }
}

//|++++++++++++++++++++++++++++++++++++|//
+ (Class)classForOpcode:(uint8_t)opcode
{
    // If we have one or more compatible subclasses, return the best match.
    {
        Class subclass = [self bestSubclassWithRanking:^uint32_t(Class cls) {
            return [cls canInstantiateWithOpcode:opcode];
        }];
        
        if (subclass != MKRebaseCommand.class)
            return subclass;
    }
    
    return nil;
}

//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//
#pragma mark - 	Creating a Rebase Command
//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//

//|++++++++++++++++++++++++++++++++++++|//
+ (instancetype)commandAtOffset:(mk_vm_offset_t)offset fromParent:(MKRebaseInfo*)parent error:(NSError**)error
{
    uint8_t opcode;
    NSError *memoryMapError = nil;
	
    if ([parent.memoryMap copyBytesAtOffset:offset fromAddress:parent.nodeContextAddress into:&opcode length:sizeof(uint8_t) requireFull:YES error:&memoryMapError] < sizeof(uint8_t)) {
		MK_ERROR_OUT = [NSError mk_errorWithDomain:MKErrorDomain code:MK_EINTERNAL_ERROR underlyingError:memoryMapError description:@"Could not read opcode at offset [%" MK_VM_PRIuOFFSET "] from %@.", offset, parent.nodeDescription];
        return nil;
    }
    
    opcode = opcode & REBASE_OPCODE_MASK;
    
    Class commandClass = [self classForOpcode:opcode];
    if (commandClass == NULL) {
        NSString *reason = [NSString stringWithFormat:@"No class for rebase opcode [%" PRIu8 "].", opcode];
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
    }
    
    return [[[commandClass alloc] initWithOffset:offset fromParent:parent error:error] autorelease];
}

//|++++++++++++++++++++++++++++++++++++|//
- (instancetype)initWithOffset:(mk_vm_offset_t)offset fromParent:(MKBackedNode*)parent error:(NSError**)error
{
    self = [super initWithOffset:offset fromParent:parent error:error];
    if (self == nil) return nil;
	
	NSError *memoryMapError = nil;
	
    if ([self.memoryMap copyBytesAtOffset:offset fromAddress:parent.nodeContextAddress into:&_data length:sizeof(uint8_t) requireFull:YES error:&memoryMapError] < sizeof(uint8_t)) {
		MK_ERROR_OUT = [NSError mk_errorWithDomain:MKErrorDomain code:MK_EINTERNAL_ERROR underlyingError:memoryMapError description:@"Could not read the rebase command immediate data."];
		[self release]; return nil;
	}
    
    uint8_t opcode = _data & REBASE_OPCODE_MASK;
    
    if (opcode != self.class.opcode) {
        NSString *reason = [NSString stringWithFormat:@"Can not initialize %@ with opcode [%" PRIu8 "].", NSStringFromClass(self.class), opcode];
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
    }
    
    return self;
}

//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//
#pragma mark - 	Performing Rebasing
//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//

//|++++++++++++++++++++++++++++++++++++|//
- (BOOL)rebase:(void (^)(void))rebase withContext:(struct MKRebaseContext*)rebaseContext error:(NSError**)error
{
#pragma unused(rebase)
#pragma unused(rebaseContext)
#pragma unused(error)
	@throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Subclasses must implement -rebase:withContext:error:." userInfo:nil];
}

//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//
#pragma mark - 	About This Rebase Command
//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//

//|++++++++++++++++++++++++++++++++++++|//
+ (uint8_t)opcode
{ @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Subclasses must implement +opcode." userInfo:nil]; }

//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//
#pragma mark - 	Rebase Command Values
//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//

//|++++++++++++++++++++++++++++++++++++|//
- (uint8_t)opcode
{ return _data & REBASE_OPCODE_MASK; }

//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//
#pragma mark - 	MKNode
//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//

//|++++++++++++++++++++++++++++++++++++|//
- (MKNodeDescription*)layout
{
	// TODO - Derive these from the subclasses?
    MKNodeFieldBuilder *opcode = [MKNodeFieldBuilder
        builderWithProperty:MK_PROPERTY(opcode)
        type:[MKNodeFieldTypeEnumeration enumerationWithUnderlyingType:MKNodeFieldTypeByte.sharedInstance name:nil elements:@{
            @(REBASE_OPCODE_DONE): @"REBASE_OPCODE_DONE",
            @(REBASE_OPCODE_SET_TYPE_IMM): @"REBASE_OPCODE_SET_TYPE_IMM",
            @(REBASE_OPCODE_SET_SEGMENT_AND_OFFSET_ULEB): @"REBASE_OPCODE_SET_SEGMENT_AND_OFFSET_ULEB",
            @(REBASE_OPCODE_ADD_ADDR_ULEB): @"REBASE_OPCODE_ADD_ADDR_ULEB",
            @(REBASE_OPCODE_ADD_ADDR_IMM_SCALED): @"REBASE_OPCODE_ADD_ADDR_IMM_SCALED",
            @(REBASE_OPCODE_DO_REBASE_IMM_TIMES): @"REBASE_OPCODE_DO_REBASE_IMM_TIMES",
            @(REBASE_OPCODE_DO_REBASE_ULEB_TIMES): @"REBASE_OPCODE_DO_REBASE_ULEB_TIMES",
            @(REBASE_OPCODE_DO_REBASE_ADD_ADDR_ULEB): @"REBASE_OPCODE_DO_REBASE_ADD_ADDR_ULEB",
            @(REBASE_OPCODE_DO_REBASE_ULEB_TIMES_SKIPPING_ULEB): @"REBASE_OPCODE_DO_REBASE_ULEB_TIMES_SKIPPING_ULEB"
        }]
        offset:0
    ];
    opcode.description = @"Opcode";
    opcode.options = MKNodeFieldOptionDisplayAsDetail;
    
    return [MKNodeDescription nodeDescriptionWithParentDescription:super.layout fields:@[
        opcode.build
    ]];
}

@end

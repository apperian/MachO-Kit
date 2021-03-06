//----------------------------------------------------------------------------//
//|
//|             MachOKit - A Lightweight Mach-O Parsing Library
//|             MKOptionSetFormatter.m
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

#import "MKOptionSetFormatter.h"

//----------------------------------------------------------------------------//
@implementation MKOptionSetFormatter

//|++++++++++++++++++++++++++++++++++++|//
+ (instancetype)optionSetFormatterWithOptions:(NSDictionary*)options
{
    MKOptionSetFormatter *retValue = [self new];
    retValue.options = options;
    
    return [retValue autorelease];
}

//|++++++++++++++++++++++++++++++++++++|//
- (void)dealloc
{
    [_options release];
    
    [super dealloc];
}

//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//
#pragma mark -  NSCoding
//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//

//|++++++++++++++++++++++++++++++++++++|//
- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
    self = [super init];
    if (self == nil) return nil;
    
    _options = [[aDecoder decodeObjectOfClass:NSDictionary.class forKey:@"options"] retain];
    _zeroBehavior = (NSUInteger)[aDecoder decodeIntegerForKey:@"zeroBehavior"];
    
    return self;
}

//|++++++++++++++++++++++++++++++++++++|//
- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:self.options forKey:@"options"];
    [aCoder encodeInteger:self.zeroBehavior forKey:@"zeroBehavior"];
}

//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//
#pragma mark -  NSCopying
//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//

//|++++++++++++++++++++++++++++++++++++|//
- (id)copyWithZone:(NSZone*)zone
{
    MKOptionSetFormatter *copy = [[MKOptionSetFormatter allocWithZone:zone] init];
    copy.options = self.options;
    copy.zeroBehavior = self.zeroBehavior;
    
    return copy;
}

//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//
#pragma mark -  Configuring Formatter Behavior
//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//

@synthesize options = _options;
@synthesize zeroBehavior = _zeroBehavior;

//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//
#pragma mark -  NSFormatter
//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//

//|++++++++++++++++++++++++++++++++++++|//
- (NSString*)stringForObjectValue:(NSNumber*)anObject
{
    if ([anObject isKindOfClass:NSNumber.class] == NO)
        return nil;
    
    uint64_t value;
    size_t bits;
    switch (*[anObject objCType]) {
        case 'c':
        case 'C':
            bits = sizeof(uint8_t) * 8;
            value = (uint64_t)[anObject unsignedCharValue];
            break;
        case 's':
        case 'S':
            bits = sizeof(uint16_t) * 8;
            value = (uint64_t)[anObject unsignedShortValue];
            break;
        case 'i':
        case 'I':
            bits = sizeof(uint32_t) * 8;
            value = (uint64_t)[anObject unsignedIntValue];
            break;
        case 'q':
        case 'Q':
            bits = sizeof(uint64_t) * 8;
            value = (uint64_t)[anObject unsignedLongLongValue];
            break;
        default:
            return nil;
    }
    
    MKOptionSetFormatterOptions *options = self.options;
    
    // Special case the 0 value
    if (value == 0) {
        if (options[@(0)])
            return options[@(0)];
        else {
            switch (self.zeroBehavior) {
                case MKOptionSetFormatterZeroBehaviorNil:
                    return nil;
                case MKOptionSetFormatterZeroBehaviorEmptyString:
                    return @"";
                case MKOptionSetFormatterZeroBehaviorZeroString:
                default:
                    return @"0";
            }
        }
    }
    
    NSMutableString *retValue = [NSMutableString string];
    uint64_t maskedBits = 0;
    
    for (NSNumber *maskValue in options) {
        uint64_t mask;
        switch (*[maskValue objCType]) {
            case 'c':
            case 'C':
                mask = (uint64_t)[maskValue unsignedCharValue];
                break;
            case 's':
            case 'S':
                mask = (uint64_t)[maskValue unsignedShortValue];
                break;
            case 'i':
            case 'I':
                mask = (uint64_t)[maskValue unsignedIntValue];
                break;
            case 'q':
            case 'Q':
                mask = (uint64_t)[maskValue unsignedLongLongValue];
                break;
            default:
                continue;
        }
        
        if (mask == 0x0)
            continue;
        
        if ((value & mask) == mask) {
            maskedBits |= mask;
            if (retValue.length != 0) [retValue appendString:@" "];
            [retValue appendString:options[maskValue]];
        }
    }
    
    value &= (~maskedBits);
    
    for (unsigned i=0; i<bits; i++) {
        if (value & (1<<i)) {
            if (retValue.length != 0) [retValue appendString:@" "];
            [retValue appendFormat:@"(1<<%u)", i];
        }
    }
    
    return retValue;
}

@end

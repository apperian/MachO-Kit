//----------------------------------------------------------------------------//
//|
//|             MachOKit - A Lightweight Mach-O Parsing Library
//! @file       MKObjCClassData.h
//!
//! @author     D.V.
//! @copyright  Copyright (c) 2014-2015 D.V. All rights reserved.
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

#include <MachOKit/macho.h>
@import Foundation;

#import <MachOKit/MKOffsetNode.h>
#import <MachOKit/MKPointer.h>
#import <MachOKit/MKCString.h>

@class MKObjCClassMethodList;
@class MKObjCProtocolList;
@class MKObjCClassPropertyList;
@class MKObjCClassIVarList;

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------//
//! @name       Class Flags
//! @relates    MKObjCClassData
//!
//
typedef NS_OPTIONS(uint32_t, MKObjCClassFlag) {
    //! Class is a metaclass.
    MKObjCClassMeta                     = (1U<<0),
    //! Class is a root class.
    MKObjCClassRoot                     = (1U<<1),
    //! Class has .cxx_construct/destruct implementations
    MKObjCClassHasCXXStructors          = (1U<<2),
    //! Class has visibility=hidden set.
    MKObjCClassHidden                   = (1U<<4),
    //! Class has attribute(objc_exception).
    MKObjCClassException                = (1U<<5),
    //! Class compiled with -fobjc-arc (automatic retain/release)
    MKObjCClassIsARR                    = (1U<<7),
    //! Class has .cxx_destruct but no .cxx_construct.
    MKObjCClassHasCXXDestructorOnly     = (1U<<8),
    //! Class was compiled with MRC but has weak ivars.
    MKObjCClassHasWeakiVarWithoutARR    = (1U<<9)
};



//----------------------------------------------------------------------------//
@interface MKObjCClassData : MKOffsetNode {
@package
    MKObjCClassFlag _flags;
    uint32_t _instanceStart;
    uint32_t _instanceSize;
    uint32_t _reserved;
    MKPointer *_name;
    MKPointer *_methods;
    MKPointer *_protocols;
    MKPointer *_properties;
    MKPointer *_ivars;
    MKPointer *_ivarLayout;
    MKPointer *_weakIVarLayout;
}

@property (nonatomic, readonly) MKObjCClassFlag flags;

@property (nonatomic, readonly) uint32_t instanceStart;

@property (nonatomic, readonly) uint32_t instanceSize;

@property (nonatomic, readonly) uint32_t reserved;

@property (nonatomic, readonly) MKPointer<MKCString*> *name;

@property (nonatomic, readonly) MKPointer<MKObjCClassMethodList*> *methods;

@property (nonatomic, readonly) MKPointer<MKObjCProtocolList*> *protocols;

@property (nonatomic, readonly) MKPointer<MKObjCClassPropertyList*> *properties;

@property (nonatomic, readonly) MKPointer<MKObjCClassIVarList*> *ivars;

@property (nonatomic, readonly) MKPointer<MKCString*> *ivarLayout;

@property (nonatomic, readonly) MKPointer<MKCString*> *weakIVarLayout;

@end

NS_ASSUME_NONNULL_END

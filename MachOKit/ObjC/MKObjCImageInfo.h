//----------------------------------------------------------------------------//
//|
//|             MachOKit - A Lightweight Mach-O Parsing Library
//! @file       MKObjCImageInfo.h
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

NS_ASSUME_NONNULL_BEGIN

//----------------------------------------------------------------------------//
//! @name       Class Flags
//! @relates    MKObjCClassData
//!
//
typedef NS_OPTIONS(uint32_t, MKObjCImageFlags) {
    //! used for Fix&Continue, now ignored
    MKObjCImageIsReplacement                = 1<<0,
    //! image supports GC
    MKObjCImageSupportsGC                   = 1<<1,
    //! image requires GC
    MKObjCImageRequiresGC                   = 1<<2,
    //! image is from an optimized shared cache
    MKObjCImageOptimizedByDyld              = 1<<3,
    //! used for an old workaround, now ignored
    MKObjCImageCorrectedSynthesize          = 1<<4,
    //! image compiled for a simulator platform
    MKObjCImageIsSimulated                  = 1<<5,
    //! class properties in category_t
    MKObjCImageHasCategoryClassProperties   = 1<<6
};



//----------------------------------------------------------------------------//
@interface MKObjCImageInfo : MKOffsetNode {
@package
    uint32_t _version;
    uint32_t _flags;
}

@property (nonatomic, readonly) MKObjCImageFlags imageFlags;

@property (nonatomic, readonly) uint8_t swiftVersion;

//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//
#pragma mark -  objc_image_info Values
//! @name       objc_image_info Values
//!
//! @brief      These values are extracted directly from the objc_image_info
//!             structure without modification or cleanup.
//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//

@property (nonatomic, readonly) uint32_t version;

@property (nonatomic, readonly) uint32_t flags;

@end

NS_ASSUME_NONNULL_END

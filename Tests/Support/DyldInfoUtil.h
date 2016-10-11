//----------------------------------------------------------------------------//
//|
//|             MachOKit - A Lightweight Mach-O Parsing Library
//|             DyldInfoUtil.h
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

@import Foundation;

//----------------------------------------------------------------------------//
@interface DyldInfoUtil : NSObject

//! Parses \a input into an array of dictionaries, each representing a single
//! dependent library.  Each dictionary contains the following keys:
//!
//!     name: Name of the dependent library
//!     attributes: Attributes of the dependent library
//!
+ (NSArray*)parseDylibs:(NSString*)input;

//! Parses \a input into an array of strings, each representing a single
//! opcode. Strings are in the following format where \c XXXX is the offset
//! from the start of the rebase commands.
//!
//!     0xXXXX OPOCDE_NAME([ARGS])
//!
+ (NSArray*)parseRebaseCommands:(NSString*)input;

//! Parses \a input into an array of dictionaries, each representing a single
//! fixup.  Each dictionary contains the following keys:
//!
//!     segment: Name of the segment in which the fixup resides
//!     section: Name of the section in which the fixup resides
//!     address: vm address of the fixup location
//!     type: fixup type
//!
+ (NSArray*)parseFixups:(NSString*)input;

@end

/*******************************************************************************
 * The MIT License (MIT)
 *
 * Copyright (c) 2023, Jean-David Gadina - www.xs-labs.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the Software), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 ******************************************************************************/

import Foundation

public extension CrashHelper
{
    class func crash_SwiftFatalError()
    {
        fatalError( "hello, world" )
    }

    class func crash_SwiftException()
    {
        try! self.throwSwiftException()
    }

    class func crash_SwiftUnwrap()
    {
        let test: String? = nil

        print( test! )
    }

    class func crash_SwiftOverflow()
    {
        var test = self.getUIntMax()
        test    += 1

        print( test )
    }

    private class func throwSwiftException() throws
    {
        throw NSError(
            domain:   "com-xs-labs.CrashTest",
            code:     42,
            userInfo:
            [
                NSLocalizedDescriptionKey:             "hello, world - NSLocalizedDescriptionKey",
                NSLocalizedFailureReasonErrorKey:      "hello, world - NSLocalizedFailureReasonErrorKey",
                NSLocalizedRecoverySuggestionErrorKey: "hello, world - NSLocalizedRecoverySuggestionErrorKey",
                NSDebugDescriptionErrorKey:            "hello, world - NSDebugDescriptionErrorKey",
                NSLocalizedFailureErrorKey:            "hello, world - NSLocalizedFailureErrorKey",
                NSLocalizedDescriptionKey:             "hello, world - NSLocalizedDescriptionKey",
            ]
        )
    }

    private class func getUIntMax() -> UInt
    {
        UInt.max
    }
}

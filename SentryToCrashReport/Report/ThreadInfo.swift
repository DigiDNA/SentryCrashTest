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

public class ThreadInfo
{
    public private( set ) var main:          Bool
    public private( set ) var id:            Int
    public private( set ) var name:          String?
    public private( set ) var current:       Bool
    public private( set ) var crashed:       Bool
    public private( set ) var rawStacktrace: Stacktrace?
    public private( set ) var stacktrace:    Stacktrace?

    public init( dictionary: [ String: Any ] ) throws
    {
        guard let id      = dictionary[ "id" ]      as? Int,
              let main    = dictionary[ "main" ]    as? Bool,
              let current = dictionary[ "current" ] as? Bool,
              let crashed = dictionary[ "crashed" ] as? Bool
        else
        {
            throw RuntimeError( message: "Invalid thread data" )
        }

        self.id      = id
        self.name    = dictionary[ "name" ] as? String
        self.main    = main
        self.current = current
        self.crashed = crashed

        if let stacktrace = dictionary[ "raw_stacktrace" ] as? [ String: Any ]
        {
            self.rawStacktrace = try Stacktrace( dictionary: stacktrace )
        }

        if let stacktrace = dictionary[ "stacktrace" ] as? [ String: Any ]
        {
            self.stacktrace = try Stacktrace( dictionary: stacktrace )
        }
    }
}

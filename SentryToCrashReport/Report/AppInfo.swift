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

public class AppInfo
{
    public private( set ) var startTime:  Date
    public private( set ) var identifier: String
    public private( set ) var name:       String
    public private( set ) var version:    String
    public private( set ) var build:      String

    public init( dictionary: [ String: Any ] ) throws
    {
        guard let startTime  = dictionary[ "app_start_time" ] as? String,
              let startTime  = ISO8601DateFormatter().date( from: startTime ),
              let identifier = dictionary[ "app_identifier" ] as? String,
              let name       = dictionary[ "app_name" ] as? String,
              let version    = dictionary[ "app_version" ] as? String,
              let build      = dictionary[ "app_build" ] as? String
        else
        {
            throw RuntimeError( message: "Invalid app context data" )
        }

        self.startTime  = startTime
        self.identifier = identifier
        self.name       = name
        self.version    = version
        self.build      = build
    }
}

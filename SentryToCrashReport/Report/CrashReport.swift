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

public class CrashReport
{
    public private( set ) var app:     AppInfo
    public private( set ) var device:  DeviceInfo
    public private( set ) var system:  SystemInfo
    public private( set ) var threads: [ ThreadInfo ]

    public convenience  init( url: URL ) throws
    {
        let path = url.path( percentEncoded: false )

        guard FileManager.default.fileExists( atPath: path )
        else
        {
            throw RuntimeError( message: "Report file does not exist" )
        }

        guard let data = try? Data( contentsOf: url )
        else
        {
            throw RuntimeError( message: "Cannot read report file" )
        }

        try self.init( data: data )
    }

    public convenience init( data: Data ) throws
    {
        guard let json = try? JSONSerialization.jsonObject( with: data ) as? [ String: Any ]
        else
        {
            throw RuntimeError( message: "Invalid JSON" )
        }

        try self.init( dictionary: json )
    }

    public init( dictionary: [ String: Any ] ) throws
    {
        guard let contexts = dictionary[ "contexts" ] as? [ String: Any ],
              let app      = contexts[ "app" ]        as? [ String: Any ],
              let device   = contexts[ "device" ]     as? [ String: Any ],
              let os       = contexts[ "os" ]         as? [ String: Any ],
              let threads  = dictionary[ "threads" ]  as? [ String: Any ],
              let threads  = threads[ "values" ]      as? [ [ String: Any ] ]
        else
        {
            throw RuntimeError( message: "Invalid crash report format" )
        }

        self.app     = try AppInfo( dictionary: app )
        self.device  = try DeviceInfo( dictionary: device )
        self.system  = try SystemInfo( dictionary: os )
        self.threads = try threads.map
        {
            try ThreadInfo( dictionary: $0 )
        }
    }
}

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

import ArgumentParser
import Foundation

struct Options: ParsableArguments
{
    @Argument( help: "A JSON crash report from Sentry" ) var report: String
}

let options = Options.parseOrExit()

guard FileManager.default.fileExists( atPath: options.report )
else
{
    error( "Report file does not exist: \( options.report )" )
}

guard let data = try? Data( contentsOf: URL( filePath: options.report ) )
else
{
    error( "Cannot read report file: \( options.report )" )
}

guard let json = try? JSONSerialization.jsonObject( with: data ) as? [ String: Any ]
else
{
    error( "Invalid report file: \( options.report )" )
}

guard let threads = ( json[ "threads" ] as? [ String: Any ] )?[ "values" ] as? [ [ String: Any ] ]
else
{
    error( "No threads found in report file: \( options.report )" )
}

threads.forEach
{
    guard let info = ThreadInfo( dictionary: $0 )
    else
    {
        error( "Invalid thread data in report file: \( options.report )" )
    }

    let title: [ String? ] = [
        "#\( info.id )",
        info.name,
        info.main    ? "MAIN"    : nil,
        info.crashed ? "CRASHED" : nil,
    ]

    print( "Thread \( title.compactMap { $0 }.joined( separator: " - " ) )" )

    if let stacktrace = info.stacktrace
    {
        printStacktrace( stacktrace )
    }

    if let stacktrace = info.rawStacktrace
    {
        printStacktrace( stacktrace )
    }

    print( "" )
}

func printStacktrace( _ stacktrace: Stacktrace )
{
    stacktrace.frames.forEach
    {
        let url = URL( filePath: $0.package )

        print( "    \( $0.function ): \( url.lastPathComponent )" )
    }
}

func error( _ message: String ) -> Never
{
    print( "Error - \( message )" )
    exit( -1 )
}

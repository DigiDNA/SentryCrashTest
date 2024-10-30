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

public class CrashReportFormater: CustomStringConvertible
{
    public private( set ) var report: CrashReport

    public init( report: CrashReport )
    {
        self.report = report
    }

    public var description: String
    {
        [
            self.info,
            self.threads,
        ]
        .joined( separator: "\n\n" )
    }

    public var info: String
    {
        self.format( info:
            [
                ( "Identifier",     self.report.app.identifier ),
                ( "Version",        "\( self.report.app.version ) (\( self.report.app.build )" ),
                ( "Code Type",      "" ),
                ( "Parent Process", "" ),
                ( "User ID",        "" ),
                ( "",               "" ),
                ( "Date/Time",      "" ),
                ( "OS Version",     "\( self.report.system.name ) \( self.report.system.version ) (\( self.report.system.build ))" ),
                ( "Anonymous UUID", "" ),
            ]
        )
    }

    public var threads: String
    {
        self.report.threads.map
        {
            self.format( thread: $0 )
        }
        .joined( separator: "\n\n" )
    }

    private func format( info: [ ( String, String ) ] ) -> String
    {
        let max = info.reduce( 0 ) { $0 < $1.0.count ? $1.0.count : $0 }

        return info.map
        {
            if $0.0.count == 0
            {
                return ""
            }

            let key = "\( $0.0 ):".padding( toLength: max + 1, withPad: " ", startingAt: 0 )

            return "\( key ) \( $0.1 )"
        }
        .joined( separator: "\n" )
    }

    private func format( thread: ThreadInfo ) -> String
    {
        var title = "Thread \( thread.id )"

        if thread.crashed
        {
            title.append( " Crashed" )
        }

        title.append( ":" )

        if let name = thread.name
        {
            title.append( " \( name )" )
        }

        if let trace = thread.stacktrace ?? thread.rawStacktrace
        {
            return [
                title,
                self.format( stacktrace: trace ),
            ]
            .joined( separator: "\n" )
        }

        return title
    }

    private func format( stacktrace: Stacktrace ) -> String
    {
        stacktrace.frames.enumerated().map
        {
            self.format( stackframe: $0.element, index: $0.offset )
        }
        .joined( separator: "\n" )
    }

    private func format( stackframe: Stackframe, index: Int ) -> String
    {
        let package = URL( filePath: stackframe.package )

        return "\( index )    \( package.lastPathComponent )    \( stackframe.function )"
    }
}

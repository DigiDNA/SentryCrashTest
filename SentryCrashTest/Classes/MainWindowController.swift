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

import Cocoa
import Sentry

public class MainWindowController: NSWindowController
{
    @objc public dynamic var crashOnMainThread = UserDefaults.standard.bool( forKey: "CrashOnMainThread" )
    {
        didSet
        {
            UserDefaults.standard.set( self.crashOnMainThread, forKey: "CrashOnMainThread" )
        }
    }

    @objc public dynamic var enableSessionTracking = UserDefaults.standard.bool( forKey: "EnableSessionTracking" )
    {
        didSet
        {
            UserDefaults.standard.set( self.enableSessionTracking, forKey: "EnableSessionTracking" )
        }
    }

    public init()
    {
        super.init( window: nil )
    }

    public required init?( coder: NSCoder )
    {
        nil
    }

    public override var windowNibName: NSNib.Name?
    {
        "MainWindowController"
    }

    @IBAction
    private func crash_ObjCException( _ sender: Any? )
    {
        self.performCrash
        {
            CrashHelper.crash_ObjCException()
        }
    }

    @IBAction
    private func crash_CPPException( _ sender: Any? )
    {
        self.performCrash
        {
            CrashHelper.crash_CPPException()
        }
    }

    @IBAction
    private func crash_SegmentationFault( _ sender: Any? )
    {
        self.performCrash
        {
            CrashHelper.crash_SegmentationFault()
        }
    }

    @IBAction
    private func crash_Abort( _ sender: Any? )
    {
        self.performCrash
        {
            CrashHelper.crash_Abort()
        }
    }

    @IBAction
    private func crash_StackOverflow( _ sender: Any? )
    {
        self.performCrash
        {
            CrashHelper.crash_StackOverflow()
        }
    }

    @IBAction
    private func crash_SwiftFatalError( _ sender: Any? )
    {
        self.performCrash
        {
            CrashHelper.crash_SwiftFatalError()
        }
    }

    @IBAction
    private func crash_SwiftException( _ sender: Any? )
    {
        self.performCrash
        {
            CrashHelper.crash_SwiftException()
        }
    }

    @IBAction
    private func crash_SwiftUnwrap( _ sender: Any? )
    {
        self.performCrash
        {
            CrashHelper.crash_SwiftUnwrap()
        }
    }

    @IBAction
    private func crash_SwiftOverflow( _ sender: Any? )
    {
        self.performCrash
        {
            CrashHelper.crash_SwiftOverflow()
        }
    }

    @IBAction
    private func hang( _ sender: Any? )
    {
        while true
        {}
    }

    private func performCrash( _ execute: @escaping () -> Void )
    {
        if self.crashOnMainThread
        {
            execute()
        }
        else
        {
            Thread.detachNewThreadSelector( #selector( self.performCrashOnThread ), toTarget: self, with: ThreadExecuteInfo( action: execute ) )
        }
    }

    @objc
    private func performCrashOnThread( _ info: ThreadExecuteInfo )
    {
        info.action()
    }

    @objc
    private class ThreadExecuteInfo: NSObject
    {
        public var action: () -> Void

        public init( action: @escaping () -> Void )
        {
            self.action = action
        }
    }
}

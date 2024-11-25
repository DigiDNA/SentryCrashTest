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

@main
public class ApplicationDelegate: NSObject, NSApplicationDelegate
{
    private var mainWindowController       = MainWindowController()
    private var crashReportWindowController: CrashReportWindowController?
    private var trackingObserver:            NSKeyValueObservation?

    public func applicationDidFinishLaunching( _ aNotification: Notification )
    {
        self.mainWindowController.window?.center()
        self.mainWindowController.window?.makeKeyAndOrderFront( nil )

        self.trackingObserver = self.mainWindowController.observe( \.enableSessionTracking )
        {
            _, _ in self.restartSentry()
        }

        self.startSentry()
    }

    public func applicationWillTerminate( _ aNotification: Notification )
    {}

    public func applicationShouldTerminateAfterLastWindowClosed( _ sender: NSApplication ) -> Bool
    {
        true
    }

    private func showCrashReportWindow( event: Event )
    {
        self.crashReportWindowController = CrashReportWindowController( event: event )

        self.crashReportWindowController?.window?.center()
        self.crashReportWindowController?.window?.makeKeyAndOrderFront( nil )
    }

    private func restartSentry()
    {
        SentrySDK.close()
        self.startSentry()
    }

    private func startSentry()
    {
        SentrySDK.start
        {
            options in

            options.dsn = "https://2ece6bf9843a3a1bddd234f98b670aea@o4508199831863296.ingest.de.sentry.io/4508199836581968"

            #if DEBUG
                options.debug = true
            #endif

            options.tracesSampleRate   = 1.0
            options.profilesSampleRate = 1.0

            options.enableAutoSessionTracking = self.mainWindowController.enableSessionTracking

            options.onCrashedLastRun =
            {
                _ in
            }

            options.beforeSend =
            {
                event in

                if let previous = self.crashReportWindowController?.event, event === previous
                {
                    return previous
                }

                DispatchQueue.main.async
                {
                    self.showCrashReportWindow( event: event )
                }

                return nil
            }
        }
    }
}

using System;
using System.Runtime.InteropServices;

class Program2
{

    // X11 constants and functions
    private const int AnyPropertyType = 0;
    private const int PropModeReplace = 0;
    [DllImport("libX11.so")]
    private static extern IntPtr XOpenDisplay(IntPtr display);
    [DllImport("libX11.so")]
    private static extern IntPtr XInternAtom(IntPtr display, string atomName, bool onlyIfExists);
    [DllImport("libX11.so")]
    private static extern IntPtr XGetSelectionOwner(IntPtr display, IntPtr selection);
    [DllImport("libX11.so")]
    private static extern int XConvertSelection(IntPtr display, IntPtr selection, IntPtr target, IntPtr property, IntPtr requestor, uint time);
    [DllImport("libX11.so")]
    private static extern int XNextEvent(IntPtr display, ref XEvent event_return);
    [DllImport("libX11.so")]
    private static extern int XGetWindowProperty(IntPtr display, IntPtr window, IntPtr property, IntPtr long_offset, IntPtr long_length, int delete, IntPtr req_type, out IntPtr actual_type_return, out int actual_format_return, out uint nitems_return, out uint bytes_after_return, ref IntPtr prop_return);
    [DllImport("libX11.so")]
    private static extern int XFree(IntPtr data);
    [DllImport("libX11.so")]
    private static extern IntPtr XCreateSimpleWindow(IntPtr display, IntPtr

    static void Main(string[] args)
    {
        // Open X11 display connection
        IntPtr display = XOpenDisplay(IntPtr.Zero);

        // Read text from clipboard
        IntPtr clipboard = XInternAtom(display, "CLIPBOARD", false);
        IntPtr targets = XInternAtom(display, "TARGETS", false);
        IntPtr property = XGetSelectionOwner(display, clipboard);
        if (property != IntPtr.Zero)
        {
            XConvertSelection(display, clipboard, targets, IntPtr.Zero, IntPtr.Zero, IntPtr.Zero);
            XEvent xev;
            do
            {
                XNextEvent(display, ref xev);
            } while (xev.type != 31);

            IntPtr data = IntPtr.Zero;
            XGetWindowProperty(display, xev.xselection.requestor, xev.xselection.property, IntPtr.Zero, 0, 1000000, AnyPropertyType, out IntPtr actualType, out int actualFormat, out uint nitems, out uint bytesAfter, ref data);
            if (data != IntPtr.Zero)
            {
                byte[] buffer = new byte[nitems.ToInt32()];
                Marshal.Copy(data, buffer, 0, buffer.Length);
                string text = System.Text.Encoding.UTF8.GetString(buffer);
                XFree(data);
            }
        }

        // Write text to clipboard
        IntPtr textProperty = XInternAtom(display, "UTF8_STRING", false);
        IntPtr selectionProperty = XInternAtom(display, "CLIPBOARD", false);
        XSetSelectionOwner(display, selectionProperty, IntPtr.Zero, 0);
        IntPtr ownerWindow = XCreateSimpleWindow(display, XDefaultRootWindow(display), 0, 0, 1, 1, 0, 0, 0);
        XSetSelectionOwner(display, selectionProperty, ownerWindow, 0);
        IntPtr textData = Marshal.StringToHGlobalAnsi("Hello, world!");
        XChangeProperty(display, ownerWindow, selectionProperty, textProperty, 8, PropModeReplace, textData, Marshal.SizeOf(typeof(byte)) * ("Hello, world!".Length + 1));
        XCloseDisplay(display);
    }

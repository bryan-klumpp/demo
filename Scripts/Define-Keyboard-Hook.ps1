#Thanks to whoever came up with this C# keyboard hook, I found it at a post by user "marsze" at https://stackoverflow.com/questions/54236696/how-to-capture-global-keystrokes-with-powershell but it looks to be older, https://hinchley.net/articles/creating-a-key-logger-via-a-global-system-hook-using-powershell (Pete Hinchley) and https://null-byte.wonderhowto.com/how-to/create-simple-hidden-console-keylogger-c-sharp-0132757/ (Mr. Falkreath) are posts from 2013 and 2012, respectively.
AAAAAAAAAAAAAAAAAAAAAAAAAAAAdd-Type -TypeDefinition '
using System;
using System.IO;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Windows.Forms;

namespace KeyboardHook {
  public static class Program {
    private const int WH_KEYBOARD_LL = 13;
    private const int WM_KEYDOWN = 0x0100;
    private const int WM_KEYUP = 0x0101;
    private const int WM_SYSKEYDOWN = 0x0104;
    private const int WM_SYSKEYUP = 0x0105;

    private static HookProc hookProc = HookCallback;
    private static IntPtr hookId = IntPtr.Zero;
    private static int keyCode = 0;
    private static int[] keyCodesNotToForward = null;

    [DllImport("user32.dll")]
    private static extern IntPtr CallNextHookEx(IntPtr hhk, int nCode, IntPtr wParam, IntPtr lParam);

    [DllImport("user32.dll")]
    private static extern bool UnhookWindowsHookEx(IntPtr hhk);

    [DllImport("user32.dll")]
    private static extern IntPtr SetWindowsHookEx(int idHook, HookProc lpfn, IntPtr hMod, uint dwThreadId);

    [DllImport("kernel32.dll")]
    private static extern IntPtr GetModuleHandle(string lpModuleName);

    public static int WaitForKey(int[] p_keyCodesNotToForward) {
      keyCodesNotToForward = p_keyCodesNotToForward;
      hookId = SetHook(hookProc);
      Application.Run();
      UnhookWindowsHookEx(hookId);
      return keyCode;
    }
    private static bool isForward(int keyCode) {
        for(int i = 0; i < keyCodesNotToForward.Length; i++) {
            if (keyCode == keyCodesNotToForward[i]) {
                return false;
            }
        } 
        return true;
    }

    private static IntPtr SetHook(HookProc hookProc) {
      IntPtr moduleHandle = GetModuleHandle(Process.GetCurrentProcess().MainModule.ModuleName);
      return SetWindowsHookEx(WH_KEYBOARD_LL, hookProc, moduleHandle, 0);
    }

    private delegate IntPtr HookProc(int nCode, IntPtr wParam, IntPtr lParam);

    private static IntPtr HookCallback(int nCode, IntPtr wParam, IntPtr lParam) {
      if (nCode >= 0 && (wParam == (IntPtr)WM_KEYDOWN || wParam == (IntPtr)WM_SYSKEYDOWN)) { //credit https://www.codeproject.com/Articles/14485/Low-level-Windows-API-hooks-from-C-to-stop-unwante for the tip to include a check for syskeydown as well, Alt-Tab (and probably all Alt-key combinations) wasnt working right without it.  Im not so sure about using keyup vs. keydown though...
        keyCode = Marshal.ReadInt32(lParam);
        Application.Exit();
      }
      //Console.WriteLine(isForward(keyCode));
      if(isForward(keyCode)) {
        return CallNextHookEx(hookId, nCode, wParam, lParam);
      } else {
        return new IntPtr(1); //credit https://www.codeproject.com/Articles/14485/Low-level-Windows-API-hooks-from-C-to-stop-unwante for showing how to return 1 to block the key from triggering in the current window
      }
    }
  }
}
' -ReferencedAssemblies System.Windows.Forms

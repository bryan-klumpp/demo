using System;
using System.Collections.Generic;

namespace FileUtils
{
    public class FileTreeSize
    {
        static List<String> logLines = new List<String>();
        static long threshold = (2 * (1024 * 1024 * 1024L));
        public static void Main()
        {
            treeSize("c:\\");
        }
        public static void treeSize(System.String rootDirString)
        {
            System.IO.DirectoryInfo rootDir = new System.IO.DirectoryInfo(rootDirString);
            WalkDirectoryTree(rootDir, 0);
            for (int i = logLines.Count - 1; i >= 0; i--) {
                Console.WriteLine(logLines[i]);
            }
            Console.WriteLine("Press any key");
            Console.ReadKey();
        }

        static long WalkDirectoryTree(System.IO.DirectoryInfo root, int level)
        {
            long totalSize = 0;
            System.IO.FileInfo[] files = null;
            System.IO.DirectoryInfo[] subDirs = null;
            // First, process all the files directly under this folder
            try {
                files = root.GetFiles("*.*");
                foreach (System.IO.FileInfo fi in files)
                {
                    // In this example, we only access the existing FileInfo object. If we
                    // want to open, delete or modify the file, then
                    // a try-catch block is required here to handle the case
                    // where the file has been deleted since the call to TraverseTree().
                    totalSize += fi.Length;
                }
                // Now find all the subdirectories under this directory.
                subDirs = root.GetDirectories("*",System.IO.SearchOption.TopDirectoryOnly);

                foreach (System.IO.DirectoryInfo dirInfo in subDirs)
                {
                    if (! hasAttribute(dirInfo, System.IO.FileAttributes.ReparsePoint)) { //Steer clear of directory junctions, etc. which skew results at best and could result in a loop
                        // Resursive call for each subdirectory.
                        totalSize += WalkDirectoryTree(dirInfo, level + 1);
                    }

                }
            }
           catch (UnauthorizedAccessException e) { e.ToString(); }
            catch (System.IO.DirectoryNotFoundException e) { e.ToString(); }


            if (totalSize > threshold) {
                //for (int i = 0; i < level; i++) { Console.Write(">   "); }
                logLines.Add(root.FullName + "  "+totalSize);
            }
            return totalSize;
        }

        static Boolean hasAttribute(System.IO.FileInfo i, System.IO.FileAttributes fa)
        {
            return (i.Attributes & fa) != 0;
        }
        static Boolean hasAttribute(System.IO.DirectoryInfo i, System.IO.FileAttributes fa)
        {
            return (i.Attributes & fa) != 0;
        }
    }
}

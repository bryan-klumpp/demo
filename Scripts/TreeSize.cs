using System;

namespace FileUtils
{
    public class FileTreeSize
    {
        public static void Main()
        {
            treeSize("c:\\");
        }
        public static void treeSize(System.String rootDirString)
        {
            System.IO.DirectoryInfo rootDir = new System.IO.DirectoryInfo(rootDirString);
            WalkDirectoryTree(rootDir, 0);
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
                    if (! hasAttribute(dirInfo, System.IO.FileAttributes.ReparsePoint)) {
                        // Resursive call for each subdirectory.
                        totalSize += WalkDirectoryTree(dirInfo, level + 1);
                    }

                }
            }
            // This is thrown if even one of the files requires permissions greater
            // than the application provides.
            catch (UnauthorizedAccessException e) { e.ToString(); }
            catch (System.IO.DirectoryNotFoundException e) { e.ToString(); }


            if (totalSize > (10 * (1024L * 1024L * 1024L))) {
                for (int i = 0; i < level; i++) { Console.Write("   "); }
                Console.WriteLine(root.FullName + ": "+totalSize);
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

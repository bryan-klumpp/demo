using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

/*
 * ChatGPT: Please write a C# function to sort a block of text that is in a tabular delimited format.  The function will take the delimiter as an argument, and it will also take as arguments the column indexes by which to sort.  The resulting sorted block should be placed back on the System clipboard.  If a column contains only numerical data it will be used to sort numerically; otherwise the column will sort according to the string value.  The function will take the input text block from the system clipboard.  Please make this function capable of executing on Ubuntu 20.04 if possible (you can use the xclip program).
 *
sudo apt install mono-devel
mcs textsorter.cs
xclip -o | mono textsorter.exe | xclip

*/

namespace TextSorter
{
    class Program
    {
        static void Main(string[] args)
        {
            // Get the input text block from the system clipboard
            string inputText = Clipboard.GetText();

            // Sort the text block using the specified column indexes and delimiter
            string sortedText = SortText(inputText, new int[] { 0, 1 }, '\t');

            // Place the sorted text block back on the system clipboard
            Clipboard.SetText(sortedText);
        }

        static string SortText(string text, int[] columnIndexes, char delimiter)
        {
            // Split the input text block into lines
            string[] lines = text.Split(new string[] { "\r\n", "\n" }, StringSplitOptions.RemoveEmptyEntries);

            // Split each line into fields using the specified delimiter
            List<string[]> fieldsList = new List<string[]>();
            foreach (string line in lines)
            {
                string[] fields = line.Split(new char[] { delimiter }, StringSplitOptions.None);
                fieldsList.Add(fields);
            }

            // Sort the fields list using the specified column indexes
            IComparer<string[]> comparer = new FieldComparer(columnIndexes);
            fieldsList.Sort(comparer);

            // Build the sorted text block by joining the sorted fields with the delimiter
            StringBuilder sortedText = new StringBuilder();
            foreach (string[] fields in fieldsList)
            {
                sortedText.AppendLine(string.Join(delimiter.ToString(), fields));
            }

            return sortedText.ToString();
        }

        class FieldComparer : IComparer<string[]>
        {
            private int[] columnIndexes;

            public FieldComparer(int[] columnIndexes)
            {
                this.columnIndexes = columnIndexes;
            }

            public int Compare(string[] x, string[] y)
            {
                for (int i = 0; i < columnIndexes.Length; i++)
                {
                    int index = columnIndexes[i];
                    if (index < x.Length && index < y.Length)
                    {
                        string xField = x[index];
                        string yField = y[index];
                        if (IsNumeric(xField) && IsNumeric(yField))
                        {
                            double xNum = double.Parse(xField);
                            double yNum = double.Parse(yField);
                            int result = xNum.CompareTo(yNum);
                            if (result != 0)
                            {
                                return result;
                            }
                        }
                        else
                        {
                            int result = xField.CompareTo(yField);
                            if (result != 0)
                            {
                                return result;
                            }
                        }
                    }
                }

                // If all columns compare equal, the lines are considered equal
                return 0;
            }

            private bool IsNumeric(string text)
            {
                double num;
                return double.TryParse(text, out num);
            }
        }
    }
}

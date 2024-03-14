using System.Text;
using System.Diagnostics;
using System.Text.RegularExpressions;
using System.Xml.Linq;

class Program {
    static void Main(string[] args) {
         
        System.Xml.Linq.XElement xroot = System.Xml.Linq.XElement.Load(@"helloworld.xml");
        Console.WriteLine(xroot);
        
        String replaceInThis = "abcdeffghijklmnopqrstuvwxyz";
        MatchEvaluator myEvaluator = new MatchEvaluator( ReplaceCC ); //https://learn.microsoft.com/en-us/dotnet/api/system.text.regularexpressions.matchevaluator?view=net-6.0  but not sure where the ^ and & came from as I had to remove them
        Console.WriteLine(Regex.Replace(replaceInThis, "e(.*)g", myEvaluator));
        //Console.WriteLine(Regex.Replace(replaceInThis, "e(.*)g", match => return "HelloWorldLambda");
        
        
        
        
        
        
        //String testData = @" { b, b , 9 }"+"\n"+ @"{ a, a , 8 }"+"\n"+@"{  a, a, 2}";
        //Console.WriteLine(sortByRegexCapturingGroups(testData));

    }

    public static string sortByRegexCapturingGroups(String input) {

        return input;
    }

     static String ReplaceCC( Match m )
   {   return  m.Groups.Values.ElementAt(1).ToString().ToUpper();
        // return m.ToString().ToUpper();
   }

    class SortFormat {
        Regex regex;
        String name;

        SortFormat(String name, String regexWithCapturingGroupsAndSortTags) {
            this.name=name;
            Regex matchNextMetaCharacter = new Regex(or(onlyOne("[^("),"<sort:(\\w*)>"));
            int pos = 0;
            Match m = matchNextMetaCharacter.Match(regexWithCapturingGroupsAndSortTags, pos);
            while(m.Success) {
                String match = m.Value;
                // pos=m.Index + m.Length;

                m = m.NextMatch();
            }
        }

    }

    public static string onlyOne(String oneChar) {
        return "["+oneChar+"]($|[^"+oneChar+"])";
    }
    public static string or(String s1, String s2) {
        return "("+s1+"|"+s2+")";
    }

public static string FormatTextBlock2(string input, char delimiter)
{
    
    // Split the input into lines
    string[] lines = input.Split(new[] { Environment.NewLine }, StringSplitOptions.TrimEntries);

    // Find the column widths based on the first line
    int[] columnWidths = lines[0]
        .Split(delimiter)
        .Select(column => column.Trim().Length)
        .ToArray();

    // Build the format string
    string format = "|";
    for (int i = 0; i < columnWidths.Length; i++)
    {
        format += " {" + i + ",-" + (columnWidths[i] + 2) + "} |";
    }

    // Build the formatted output
    StringBuilder output = new StringBuilder();
    output.AppendLine(lines[0].TrimEnd(delimiter)); // Add the header row

    for (int i = 1; i < lines.Length; i++)
    {
        string[] fields = lines[i].Split(delimiter).Select(field => field.Trim()).ToArray();

        // Build the formatted fields
        string[] formattedFields = new string[columnWidths.Length];
        for (int j = 0; j < columnWidths.Length; j++)
        {
            if (j < fields.Length)
            {
                string field = fields[j];
                int width = columnWidths[j];

                if (field.Length > width)
                {
                    field = field.Substring(0, width);
                }

                formattedFields[j] = " " + field + " ";
            }
            else
            {
                formattedFields[j] = new string(' ', columnWidths[j] + 2);
            }
        }

        // Append the formatted row to the output
        output.AppendLine(string.Format(format, formattedFields).TrimEnd());
    }

    return output.ToString();
}

public static string FormatTextBlock1(string input, char delimiter)
{
    // Split the input into lines
    string[] lines = input.Split(new[] { Environment.NewLine }, StringSplitOptions.RemoveEmptyEntries);

    // Find the column widths based on the first line
    int[] columnWidths = lines[0]
        .Split(delimiter)
        .Select(column => column.Trim().Length)
        .ToArray();

    // Build the format string
    string format = "|";
    for (int i = 0; i < columnWidths.Length; i++)
    {
        format += " {" + i + ",-" + (columnWidths[i] + 2) + "} |";
    }

    // Build the formatted output
    StringBuilder output = new StringBuilder();
    output.AppendLine(lines[0].TrimEnd(delimiter)); // Add the header row

    for (int i = 1; i < lines.Length; i++)
    {
        string[] fields = lines[i].Split(delimiter).Select(field => field.Trim()).ToArray();

        // Build the formatted fields
        string[] formattedFields = new string[columnWidths.Length];
        for (int j = 0; j < columnWidths.Length; j++)
        {
            if (j < fields.Length)
            {
                string field = fields[j];
                int width = columnWidths[j];

                if (field.Length > width)
                {
                    field = field.Substring(0, width);
                }

                formattedFields[j] = " " + field + " ";
            }
            else
            {
                formattedFields[j] = new string(' ', columnWidths[j] + 2);
            }
        }

        // Append the formatted row to the output
        output.AppendLine(string.Format(format, formattedFields));
    }

    return output.ToString();
}


    static string GetTextFromClipboard() {
        Process process = new Process();
        process.StartInfo.FileName = "xclip";
        process.StartInfo.Arguments = "-o";
        process.StartInfo.UseShellExecute = false;
        process.StartInfo.RedirectStandardOutput = true;
        process.Start();
        string text = process.StandardOutput.ReadToEnd();
        process.WaitForExit();
        return text;
    }

    static void SetTextToClipboard(string text) {
        Process process = new Process();
        process.StartInfo.FileName = "xclip";
        process.StartInfo.Arguments = "-i";
        process.StartInfo.UseShellExecute = false;
        process.StartInfo.RedirectStandardInput = true;
        process.Start();
        process.StandardInput.Write(text);
        process.StandardInput.Close();
        process.WaitForExit();
    }

    static string FormatTextAsTable(string text, string delimiter) {
        string[] lines = text.Split(new[] { "\r\n", "\r", "\n" }, StringSplitOptions.None);
        string[] headers = lines[0].Split(new[] { delimiter }, StringSplitOptions.None);
        int[] columnWidths = new int[headers.Length];

        for (int i = 0; i < headers.Length; i++) {
            columnWidths[i] = headers[i].Length + 2; // add padding
        }

        for (int i = 1; i < lines.Length; i++) {
            string[] fields = lines[i].Split(new[] { delimiter }, StringSplitOptions.None);
            for (int j = 0; j < fields.Length; j++) {
                columnWidths[j] = Math.Max(columnWidths[j], fields[j].Length + 2); // add padding
            }
        }

        StringBuilder builder = new StringBuilder();
        builder.AppendLine(string.Join(delimiter, headers.Select((h, i) => h.PadRight(columnWidths[i]))));

        for (int i = 1; i < lines.Length; i++) {
            string[] fields = lines[i].Split(new[] { delimiter }, StringSplitOptions.None);
            string[] formattedFields = fields.Select((f, j) => f.PadRight(columnWidths[j])).ToArray();
            int totalWidth = formattedFields.Sum(f => f.Length);
            int excessWidth = totalWidth - (delimiter.Length * (formattedFields.Length - 1));
            if (excessWidth > 0) {
                int maxWidth = columnWidths.Max();
                int shrinkableColumns = columnWidths.Count(w => w == maxWidth);
                int excessPerColumn = excessWidth / shrinkableColumns;
                int remainingExcess = excessWidth % shrinkableColumns;
                for (int j = 0; j < formattedFields.Length; j++) {
                    if (columnWidths[j] == maxWidth) {
                        int width = columnWidths[j] - excessPerColumn;
                        if (remainingExcess > 0) {
                            width -= 1;
                            remainingExcess -= 1;
                        }
                        formattedFields[j] = formattedFields[j].Substring(0, width) + delimiter;
                    }
                }
            }
            builder.AppendLine(string.Join(delimiter, formattedFields));
        }

        return builder.ToString();
    }
}

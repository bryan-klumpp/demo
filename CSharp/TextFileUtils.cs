using System.IO;
using System.Text.RegularExpressions;
using System;
using System.Linq;
using System.Text;
using System.Diagnostics;

class TextFileUtils
{
    /* ChatGPT: Please write a C# function to add a specified text block to a file after a line in the file matching a regular expression that I will provide.  The arguments will be the file path, the regular expression to find the start line, and a single string of the text to be added to the file. */
    static void AddTextAfterMatch(string filePath, string regexPattern, string textToAdd)
    {
        // Read all lines from the file
        string[] lines = File.ReadAllLines(filePath);

        // Find the index of the line that matches the regular expression
        int matchIndex = Array.FindIndex(lines, line => Regex.IsMatch(line, regexPattern));

        if (matchIndex >= 0)
        {
            // Create a new list to hold the lines with the added text
            List<string> newLines = new List<string>();

            // Add all lines before the matched line
            newLines.AddRange(lines.Take(matchIndex + 1));

            // Add the text to be added
            newLines.Add(textToAdd);

            // Add all lines after the matched line
            newLines.AddRange(lines.Skip(matchIndex + 1));

            // Write the new lines back to the file
            File.WriteAllLines(filePath, newLines);
        }
    }

    /* ChatGPT: Please write a C# function to add a specified text block to a file after a text block that will be matched with a multi-line regular expression that I will provide (the file will not be considered to be line-separated; rather, I will provide \n endline characters as needed).   The arguments will be the file path, the regular expression to find, and a single string of the text to be added to the file after the regex match.   */

    /* ChatGPT good regex tips in general for multiline...
        string filePath = "example.txt";
        string regexPattern = @"start of block\n.+?\nend of block";
        string textToAdd = "This text will be added after the matched block.\n";

        AppendTextAfterRegexMatch(filePath, regexPattern, textToAdd);

        In this example, the regular expression pattern matches a block of text starting with the string "start of block" and ending with the string "end of block", with any text in between. The .+? pattern matches any character (except for newline characters) one or more times, but does so lazily (i.e., it matches as few characters as possible to satisfy the pattern). The RegexOptions.Multiline option allows the ^ and $ anchors to match at the beginning and end of lines within the input string.
    */
    public void AppendTextAfterRegexMatch(string filePath, string regexPattern, string textToAdd)
    {
        // Read the file contents into a string
        string fileContents = File.ReadAllText(filePath);

        // Use a regular expression to find the match
        Regex regex = new Regex(regexPattern, RegexOptions.Multiline);
        Match match = regex.Match(fileContents);

        if (match.Success)
        {
            // Get the index of the end of the matched block
            int endIndex = match.Index + match.Length;

            // Insert the new text after the matched block
            fileContents = fileContents.Insert(endIndex, textToAdd);
        }
        else
        {
            // If no match is found, add the text at the beginning of the file
            fileContents = textToAdd + fileContents;
        }

        // Write the modified contents back to the file
        File.WriteAllText(filePath, fileContents);
    }


    /* ChatGPT: Please write a C# function to format a block of text to be formatted in a visual tabular format with fields separated by a delimiter.  The function will take the text block from the system clipboard and use the first line as a guide for formatting.  The function will take as an argument the delimiter that is used to separate the fields.  The code will search the first line of the text block for the positions of the delimiter and use that as a guide for formatting the remaining lines with the fields lined up by spaces.   The code will preserve the exact positioning of the delimiters in the first line and apply that to the following lines where possible, but the code can make the following rows longer if needed.  There must be at least one space before and after each delimiter occurrence.  After processing, the code will place the resulting formatted text block back on the system clipboard.  Please make this capable of executing on Ubuntu 20.04 if possible. */
    /* 
        
     */

    public static void formatClipboardTabular(string delimiter)
    {
        string text = GetTextFromClipboard();
        string formattedText = FormatTextAsTable(text, delimiter);
        SetTextToClipboard(formattedText);
        Console.WriteLine("Formatted text copied to clipboard.");
    }

    static string GetTextFromClipboard()
    {
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

    static void SetTextToClipboard(string text)
    {
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

    static string FormatTextAsTable(string text, string delimiter)
    {
        string[] lines = text.Split(new[] { "\r\n", "\r", "\n" }, StringSplitOptions.None);
        string[] headers = lines[0].Split(new[] { delimiter }, StringSplitOptions.None);
        int[] columnWidths = new int[headers.Length];

        for (int i = 0; i < headers.Length; i++)
        {
            columnWidths[i] = headers[i].Length + 2; // add padding
        }

        for (int i = 1; i < lines.Length; i++)
        {
            string[] fields = lines[i].Split(new[] { delimiter }, StringSplitOptions.None);
            for (int j = 0; j < fields.Length; j++)
            {
                columnWidths[j] = Math.Max(columnWidths[j], fields[j].Length + 2); // add padding
            }
        }

        StringBuilder builder = new StringBuilder();
        builder.AppendLine(string.Join(delimiter, headers.Select((h, i) => h.PadRight(columnWidths[i]))));

        for (int i = 1; i < lines.Length; i++)
        {
            string[] fields = lines[i].Split(new[] { delimiter }, StringSplitOptions.None);
            builder.AppendLine(string.Join(delimiter, fields.Select((f, j) => f.PadRight(columnWidths[j]))));
        }

        return builder.ToString();
    }
}

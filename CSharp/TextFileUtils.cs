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

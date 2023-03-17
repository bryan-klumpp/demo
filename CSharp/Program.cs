// See https://aka.ms/new-console-template for more information
using System.Xml;
using System.Xml.Schema;

Console.WriteLine("Hello, World!");
System.Xml.XmlReader reader = XmlReader.Create(@"/home/klumpb/note.xml");
XmlSchemaSet schemaSet = new XmlSchemaSet();
XmlSchemaInference schema = new XmlSchemaInference();
// make 
schema.Occurrence = XmlSchemaInference.InferenceOption.Restricted;
schema.TypeInference = XmlSchemaInference.InferenceOption.Restricted;
schemaSet = schema.InferSchema(reader);

foreach (XmlSchema s in schemaSet.Schemas())
{
    using (var stringWriter = new StringWriter())
    {
        using (var writer = XmlWriter.Create(stringWriter))
        {
            s.Write(writer);
        }

        Console.WriteLine( stringWriter.ToString() );
    }
}
using NUnit.Framework;

namespace CSharpTest;

public class Tests
{
    [SetUp]
    public void Setup()
    {
    }

    [Test]
    public void Test1()
    {
        System.Console.WriteLine("Hello from a test");
        Assert.IsFalse(false);
    }
}
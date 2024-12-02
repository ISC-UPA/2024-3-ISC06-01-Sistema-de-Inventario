using System.Security.Cryptography;

class Program
{
    static void Main()
    {
        var key = new byte[32];
        using (var generator = RandomNumberGenerator.Create())
        {
            generator.GetBytes(key);
            string secretKey = Convert.ToBase64String(key);
            Console.WriteLine($"Generated JWT Secret Key: {secretKey}");
            Console.ReadLine();
        }

    }
}


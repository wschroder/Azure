using Storage.Queue.Domain.Entity;
using Storage.Queue.Support;
using System;
using System.Text.Json;
using System.Threading.Tasks;

namespace Storage.Queue.Receiver
{
    class Program
    {
        static async Task Main(string[] args)
        {
            string connectionString = "DefaultEndpointsProtocol=https;AccountName=wlsstorage779;AccountKey=DvygnXM/eD8G03N9WLwNEI4BpnioyUveK/qzKovLf0zl5aKInokZ0FoLiq+NhlDpjj3d5fx4ynOSP5aKQz8KYg==;EndpointSuffix=core.windows.net";
            string queueName = "fish-sightings";

            var reader = new QueueReader(connectionString, queueName);

            while (true)
            {
                FishObservation observation = await reader.Read<FishObservation>();

                if (observation == null)
                {
                    Console.WriteLine("\r\nNo more data available.  Hit any key to exit...");
                    Console.ReadKey();
                    break;
                }

                var options = new JsonSerializerOptions { WriteIndented = true };

                Console.WriteLine(JsonSerializer.Serialize(observation, typeof(FishObservation), options));

                Console.WriteLine("\r\nHit 'q' to exit, or any other key to continue...");
                ConsoleKeyInfo key = Console.ReadKey();
                if (key.KeyChar == 'q')
                {
                    break;
                }
            }
        }
    }
}

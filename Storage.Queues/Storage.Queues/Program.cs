using Storage.Queue.Domain.Entity;
using Storage.Queue.Support;
using Storage.Queues.Common;
using System;
using System.Threading.Tasks;

namespace Storage.Queue.Sender
{
    class Program
    {
        static async Task Main(string[] args)
        {

            string connectionString = "DefaultEndpointsProtocol=https;AccountName=wlsstorage779;AccountKey=DvygnXM/eD8G03N9WLwNEI4BpnioyUveK/qzKovLf0zl5aKInokZ0FoLiq+NhlDpjj3d5fx4ynOSP5aKQz8KYg==;EndpointSuffix=core.windows.net";
            string queueName = "fish-sightings";

            while(true)
            {
                FishObservation observation = DataGenerator.CreateFishObservation();

                var queueWriter = new QueueWriter(connectionString, queueName);

                string messageId = await queueWriter.Write(observation);

                Console.WriteLine($"\r\nMessage {messageId} sent.");

                Console.WriteLine("\r\nHit 'q' to quit, or any other key to continue.");
                ConsoleKeyInfo key = Console.ReadKey();
                if (key.KeyChar == 'q')
                {
                    break;
                }
            }

        }
    }
}

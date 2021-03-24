using Azure;
using Azure.Storage.Queues;
using Azure.Storage.Queues.Models;
using System;
using System.Text.Json;
using System.Threading.Tasks;

namespace Storage.Queue.Support
{
    public class QueueReader
    {
        QueueClient _queueClient;

        public QueueReader(string connectionString, string queueName)
        {
            _queueClient = new QueueClient(connectionString, queueName);
            if (_queueClient.Exists() == false)
            {
                throw new InvalidOperationException($"Queue not found: {queueName}");
            }
        }

        public async Task<TReadType> Read<TReadType>() where TReadType:class
        {
            Response<QueueMessage> response = await _queueClient.ReceiveMessageAsync();

            if (response.Value==null)
            {
                return null;
            }

            TReadType result = JsonSerializer.Deserialize<TReadType>(response.Value.Body);

            return result;
        }
    }
}

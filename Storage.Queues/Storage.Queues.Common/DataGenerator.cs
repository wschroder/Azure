using Storage.Queue.Domain.Entity;
using Storage.Queue.Domain.Enum;
using System;

namespace Storage.Queues.Common
{
    public static class DataGenerator
    {
        public static FishObservation CreateFishObservation()
        {

            Bogus.Faker<FishObservation> testData = new Bogus.Faker<FishObservation>()
                .RuleFor(o => o.ReportTime, f => f.Date.Past(yearsToGoBack: 2))
                .RuleFor(o => o.FishType, f => f.PickRandom<FishType>().ToString())
                .RuleFor(o => o.Observer, (f, u) => f.Name.FindName())
                .RuleFor(o => o.FishCount, f => f.Random.Int(min: 0, max: 20))
                .RuleFor(o => o.ConfidenceRating, f => Math.Round(f.Random.Decimal(min: 0.5m, max: 1), 2));

            FishObservation observation = testData.Generate();

            return observation;
        }

    }
}

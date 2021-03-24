using System;

namespace Storage.Queue.Domain.Entity
{
    public class FishObservation
    {
        public DateTime ReportTime { get; set; }
        public string FishType { get; set; }
        public string Observer { get; set; }
        public int FishCount { get; set; }
        public decimal ConfidenceRating { get; set; }
    }
}

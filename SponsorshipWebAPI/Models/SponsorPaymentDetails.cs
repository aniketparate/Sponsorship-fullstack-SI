namespace SponsorshipWebApp.Models
{
    public class SponsorPaymentDetails
    {
        public int SponsorID { get; set; }

        public string? SponsorName { get; set; }

        public string? IndustryType { get; set; }

        public string? ContactEmail { get; set; }

        public string? Phone { get; set; }

        public decimal TotalPaymentsMade { get; set; }

        public int NumberOfPayments { get; set; }

        public DateTime LatestPaymentDate { get; set; }
    }
}

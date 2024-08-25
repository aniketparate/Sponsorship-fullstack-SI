namespace SponsorshipWebApp.Models
{
    public class MatchPaymentDetails
    {
        public int MatchID { get; set; }
        public string? MatchName { get; set; }
        public DateTime MatchDate { get; set; }
        public string? Location { get; set; }
        public decimal TotalPayments { get; set; }
    }
}
using System.ComponentModel.DataAnnotations;

namespace SponsorshipWebApp.Models
{
    public class PaymentDetails
    {
        public int ContractID { get; set; } 

        public DateTime PaymentDate { get; set; }
                  
        [Required]
        public decimal AmountPaid { get; set; } 

        [Required]
        public string? PaymentStatus { get; set; }
    }
}

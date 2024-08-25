using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SponsorshipWebApp.DAO;
using SponsorshipWebApp.Models;

namespace SponsorshipWebApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SponsorshipController : ControllerBase
    {
        private readonly ISponsorDao _sponsorDao;

        public SponsorshipController(ISponsorDao sponsorDao) => _sponsorDao = sponsorDao;

        [HttpGet("sponsorpaymentdetails")]
        public async Task<ActionResult<List<SponsorPaymentDetails>>> GetSponsorPaymentDetails()
        {

            var sponsorPaymentDetails = await _sponsorDao.GetSponsorPaymentDetails();
            if (sponsorPaymentDetails == null)
            {
                return NotFound();
            }
            return Ok(sponsorPaymentDetails);
        }

        [HttpGet("matchpaymentdetails")]
        public async Task<ActionResult<List<MatchPaymentDetails>>> GetMatchPaymentDetails()
        {
            var matchPaymentDetails = await _sponsorDao.GetMatchPaymentDetails();
            if (matchPaymentDetails == null)
            {
                return NotFound();
            }
            return Ok(matchPaymentDetails);
        }

        [HttpGet("sponsormatchsummary/{year}")]
        public async Task<ActionResult<List<SponsorMatchSummary>>> GetSponsorMatchSummary(int year)
        {
            var summaries = await _sponsorDao.GetSponsorMatchSummary(year);
            if (summaries == null)
            {
                return NotFound();
            }
            return Ok(summaries);
        }

        [HttpPost("paymentdetail", Name = "CreatePaymentDetail")]
        public async Task<ActionResult<PaymentDetails>> CreatePaymentDetail(PaymentDetails paymentDetails)
        {
            if (paymentDetails != null)
            {
                int res = await _sponsorDao.InsertPaymentDetails(paymentDetails);
                if (res > 0)
                {
                    return CreatedAtRoute(nameof(CreatePaymentDetail), new { id = paymentDetails.ContractID }, paymentDetails);
                }
                return BadRequest("Failed to add product");
            }
            else
            {
                return BadRequest();
            }
        }
    }
}
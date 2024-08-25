using Npgsql;
using SponsorshipWebApp.Models;
using System.Data.Common;
using System.Data;

namespace SponsorshipWebApp.DAO
{
    public class SponsorDaoImpl : ISponsorDao
    {
        readonly NpgsqlConnection _connection;
        public SponsorDaoImpl(NpgsqlConnection connection)
        {
            _connection = connection;
        }


        public async Task<List<SponsorPaymentDetails>> GetSponsorPaymentDetails()
        {
            string? errorMessage = null;
            List<SponsorPaymentDetails> sponsorPaymentDetailsList = new List<SponsorPaymentDetails>();
            string query = @"select s.sponsorID, s.sponsorName, s.industryType, s.contactEmail, s.phone,
                    coalesce(sum(p.amountPaid), 0) as totalPaymentsMade,
                    count(p.paymentID) as numberOfPayments,
                    coalesce(max(p.paymentDate), '1900-01-01') as latestPaymentDate
                    from sponsorship.sponsors s left join sponsorship.contracts c on s.sponsorID = c.sponsorID
                    left join sponsorship.payments p on c.contractID = p.contractID
                    group by s.sponsorID, s.sponsorName, s.industryType, s.contactEmail, s.phone
                    order by s.sponsorID;";

            try
            {
                using (_connection)
                {
                    await _connection.OpenAsync();
                    NpgsqlCommand command = new NpgsqlCommand(query, _connection);
                    command.CommandType = CommandType.Text;
                    NpgsqlDataReader reader = await command.ExecuteReaderAsync();
                    if (reader.HasRows)
                    {
                        while (reader.Read())
                        {
                            SponsorPaymentDetails details = new SponsorPaymentDetails
                            {
                                SponsorID = (int)reader.GetInt32(0),
                                SponsorName = reader.GetString(1),
                                IndustryType = reader.GetString(2),
                                ContactEmail = reader.GetString(3),
                                Phone = reader.GetString(4),
                                TotalPaymentsMade = reader.GetDecimal(5),
                                NumberOfPayments = reader.GetInt32(6),
                                LatestPaymentDate = reader.GetDateTime(7)
                            };
                            sponsorPaymentDetailsList.Add(details);
                        }
                    }
                    reader?.Close();
                }
            }
            catch (NpgsqlException e)
            {
                errorMessage = e.Message;
                Console.WriteLine("Database exception occurred: " + errorMessage);
            }
            catch (Exception e)
            {
                errorMessage = e.Message;
                Console.WriteLine("An unexpected error occurred: " + errorMessage);
            }
            return sponsorPaymentDetailsList;
        }

        public async Task<List<MatchPaymentDetails>> GetMatchPaymentDetails()
        {
            string? errorMessage = null;
            List<MatchPaymentDetails> matchPaymentDetailsList = new List<MatchPaymentDetails>();
            string query = @"select m.matchID, m.matchName, m.matchDate, m.location,
                    coalesce(sum(p.amountPaid), 0) as totalPayments
                    from sponsorship.matches m left join sponsorship.contracts c on m.matchID = c.matchID
                    left join sponsorship.payments p on c.contractID = p.contractID
                    group by m.matchID, m.matchName, m.matchDate, m.location
                    order by m.matchDate;";

            try
            {
                using (_connection)
                {
                    await _connection.OpenAsync();
                    NpgsqlCommand command = new NpgsqlCommand(query, _connection);
                    command.CommandType = CommandType.Text;
                    NpgsqlDataReader reader = await command.ExecuteReaderAsync();
                    if (reader.HasRows)
                    {
                        while (await reader.ReadAsync())
                        {
                            MatchPaymentDetails details = new MatchPaymentDetails
                            {
                                MatchID = reader.GetInt32(0),
                                MatchName = reader.GetString(1),
                                MatchDate = reader.GetDateTime(2),
                                Location = reader.GetString(3),
                                TotalPayments = reader.GetDecimal(4)
                            };
                            matchPaymentDetailsList.Add(details);
                        }
                    }
                }
            }
            catch (NpgsqlException e)
            {
                errorMessage = e.Message;
                Console.WriteLine("Database exception occurred: " + errorMessage);
            }
            catch (Exception e)
            {
                errorMessage = e.Message;
                Console.WriteLine("An unexpected error occurred: " + errorMessage);
            }
            return matchPaymentDetailsList;
        }

        public async Task<List<SponsorMatchSummary>> GetSponsorMatchSummary(int year)
        {
            string? errorMessage = null;
            List<SponsorMatchSummary> summaries = new List<SponsorMatchSummary>();
            string query = @"select s.sponsorName, count(c.matchID) as numberOfMatches
                  from sponsorship.sponsors s join sponsorship.contracts c on s.sponsorID = c.sponsorID
                  join sponsorship.matches m on c.matchID = m.matchID
                  where extract(year from m.matchDate) = @year
                  group by s.sponsorName order by numberOfMatches desc;";

            try
            {
                using (_connection)
                {
                    await _connection.OpenAsync();
                    NpgsqlCommand command = new NpgsqlCommand(query, _connection);
                    command.CommandType = CommandType.Text;
                    command.Parameters.AddWithValue("@year", year);
                    NpgsqlDataReader reader = await command.ExecuteReaderAsync();
                    if (reader.HasRows)
                    {
                            while (await reader.ReadAsync())
                            {
                                SponsorMatchSummary summary = new SponsorMatchSummary
                                {
                                    SponsorName = reader.GetString(0),
                                    NumberOfMatches = reader.GetInt32(1)
                                };
                                summaries.Add(summary);
                            }
                    }
                }
            }
            catch (NpgsqlException e)
            {
                errorMessage = e.Message;
                Console.WriteLine("Database exception occurred: " + errorMessage);
            }
            catch (Exception e)
            {
                errorMessage = e.Message;
                Console.WriteLine("An unexpected error occurred: " + errorMessage);
            }

            return summaries;
        }

        public async Task<int> InsertPaymentDetails(PaymentDetails paymentDetails)
        {
            int rowsInserted = 0;
            string message = null;

            string insertQuery = @"INSERT INTO sponsorship.payments (contractID, paymentDate, amountPaid, paymentStatus) 
                           VALUES (@contractID, @paymentDate, @amountPaid, @paymentStatus)";

            try
            {
                using (_connection)
                {
                    await _connection.OpenAsync();

                    using (var insertCommand = new NpgsqlCommand(insertQuery, _connection))
                    {
                        insertCommand.Parameters.AddWithValue("@contractID", paymentDetails.ContractID);
                        insertCommand.Parameters.AddWithValue("@paymentDate", paymentDetails.PaymentDate);
                        insertCommand.Parameters.AddWithValue("@amountPaid", paymentDetails.AmountPaid);
                        insertCommand.Parameters.AddWithValue("@paymentStatus", paymentDetails.PaymentStatus);

                        rowsInserted = await insertCommand.ExecuteNonQueryAsync();
                    }
                }
            }
            catch (NpgsqlException e)
            {
                message = e.Message;
                Console.WriteLine($"An error occurred while inserting payment details: {message}");
            }
            catch (Exception e)
            {
                message = e.Message;
                Console.WriteLine($"An unexpected error occurred: {message}");
            }
            return rowsInserted;
        }

    }
}

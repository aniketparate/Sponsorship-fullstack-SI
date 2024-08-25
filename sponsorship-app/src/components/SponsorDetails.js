import React, { useEffect, useState } from 'react'
import './style.css'
import { sponsorDetailService } from '../services/sponsorDetailService'

const SponsorDetails = () => {
    const [sponsorData, setSponsorData] = useState([])
    const [error, setError] = useState(null);

    useEffect(() => {
        const fetchDataFromApi = async () => {
            try {
                const result = await sponsorDetailService();
                setSponsorData(result);
                
            } catch (err) {
                setError(err.message);
            }
        }
        fetchDataFromApi();
    }, [])

  return (
    <div className="sponsor-details">
        <h1>Sponsor Details</h1>
        {error && <p className="error-message">Error: {error}</p>}
        <table className="sponsor-table">
            <thead>
                <tr>
                    <th>Sponsor Name</th>
                    <th>Industry Type</th>
                    <th>Contact Email</th>
                    <th>Phone</th>
                    <th>Total Payments Made</th>
                    <th>Number of Payments</th>
                    <th>Latest Payment Date</th>
                </tr>
            </thead>
            <tbody>
                {sponsorData.map(sponsor => (
                    <tr key={sponsor.sponsorID}>
                        <td>{sponsor.sponsorName}</td>
                        <td>{sponsor.industryType}</td>
                        <td>{sponsor.contactEmail}</td>
                        <td>{sponsor.phone}</td>
                        <td>${sponsor.totalPaymentsMade.toLocaleString()}</td>
                        <td>{sponsor.numberOfPayments}</td>
                        <td>{new Date(sponsor.latestPaymentDate).toLocaleDateString()}</td>
                    </tr>
                ))}
            </tbody>
        </table>
    </div>
  )
}

export default SponsorDetails

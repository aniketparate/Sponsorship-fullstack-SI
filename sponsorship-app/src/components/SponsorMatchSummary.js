import React, { useState } from 'react'
import './style.css'
import { sponsorMatchService } from '../services/sponsorMatchService';

const SponsorMatchSummary = () => {
    const [year, setYear] = useState('');
    const [data, setData] = useState([]);
    const [error, setError] = useState('');
  
    const handleFetchData = async () => {
       if (!year || isNaN(year) || year.length !== 4) {
            setError('Invalid year provided');
            return;
        }
        setError('');
        try {
            const result = await sponsorMatchService(year);
            setData(result);
        } catch (err) {
            setError('Error fetching sponsor match summary');
        } 
    };
  
    return (
      <div className="sponsor-match-summary">
        <h1>Sponsor Match Summary</h1>
        <input 
          type="number"
          value={year} 
          onChange={(e) => setYear(e.target.value)} 
          placeholder="Enter year" 
        />
        <button onClick={handleFetchData}>
          Fetch Data
        </button>
        {error && <p className="error">{error}</p>}
        {data.length > 0 && (
          <table className="data-table">
            <thead>
              <tr>
                <th>Sponsor Name</th>
                <th>Number of Matches</th>
              </tr>
            </thead>
            <tbody>
              {data.map((item, index) => (
                <tr key={index}>
                  <td>{item.sponsorName}</td>
                  <td>{item.numberOfMatches}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    );
}

export default SponsorMatchSummary

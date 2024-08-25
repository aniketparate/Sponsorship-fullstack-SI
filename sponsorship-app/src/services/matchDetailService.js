import { fetchData } from "./sponsorApiService";

export const matchDetailService = async () => {
    try {
        const endpoint = 'matchpaymentdetails';
        const data = await fetchData(endpoint);
        return data;
    } catch (error) {
        console.error('Failed to fetch match payment details:', error.response?.data?.message || error.message);
        throw new Error('Could not retrieve match payment details at this time. Please try again later.');
    }
};
import { fetchData } from "./sponsorApiService";

export const sponsorDetailService = async () => {
    try {
        const endpoint = 'sponsorpaymentdetails';
        const data = await fetchData(endpoint);
        return data;
    } catch (error) {
        console.error('Failed to fetch sponsor payment details:', error.response?.data?.message || error.message);
        throw new Error('Could not retrieve sponsor payment details at this time. Please try again later.');
    }
};
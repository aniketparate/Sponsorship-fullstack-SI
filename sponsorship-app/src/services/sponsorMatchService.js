import { fetchData } from "./sponsorApiService";

export const sponsorMatchService = async (year) => {
    if (!year || isNaN(year)) {
        throw new Error('Invalid year provided');
    }

    const endpoint = `sponsormatchsummary/${year}`;
    try {
        const data = await fetchData(endpoint);
        return data;
    } catch (error) {
        console.error('Error fetching sponsor match summary:', error.message);
        throw error;
    }
};
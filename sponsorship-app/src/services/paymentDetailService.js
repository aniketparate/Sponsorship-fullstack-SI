import { postData } from "./sponsorApiService";

export const paymentDetailService = async (paymentDetails) => {
    try {
        const endpoint = 'paymentDetail';
        const response = await postData(endpoint, paymentDetails);
        return response;
    } catch (error) {
        console.error('Payment Detail Service Error:', error.message);
        throw error;
    }
};

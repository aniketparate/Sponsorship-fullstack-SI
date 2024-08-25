import React from 'react';
import { render, screen, waitFor } from '@testing-library/react';
import '@testing-library/jest-dom/extend-expect';
import SponsorDetails from '../components/SponsorDetails';
import { sponsorDetailService } from '../services/sponsorDetailService';

jest.mock('../services/sponsorDetailService');

describe('SponsorDetails Component', () => {
    beforeEach(() => {
        jest.clearAllMocks();
    });

    test('renders loading state and then displays data', async () => {
        const mockData = [
            {
                sponsorID: '1',
                sponsorName: 'Sponsor A',
                industryType: 'Technology',
                contactEmail: 'contact@sponsorA.com',
                phone: '123-456-7890',
                totalPaymentsMade: 10000,
                numberOfPayments: 5,
                latestPaymentDate: '2024-08-15'
            },
            {
                sponsorID: '2',
                sponsorName: 'Sponsor B',
                industryType: 'Healthcare',
                contactEmail: 'contact@sponsorB.com',
                phone: '098-765-4321',
                totalPaymentsMade: 15000,
                numberOfPayments: 8,
                latestPaymentDate: '2024-08-18'
            }
        ];

        sponsorDetailService.mockResolvedValue(mockData);

        render(<SponsorDetails />);

        expect(screen.getByText('Sponsor Name')).toBeInTheDocument();
        expect(screen.getByText('Industry Type')).toBeInTheDocument();

        await waitFor(() => {
            expect(screen.getByText('Sponsor A')).toBeInTheDocument();
            expect(screen.getByText('Technology')).toBeInTheDocument();
            expect(screen.getByText('contact@sponsorA.com')).toBeInTheDocument();
            expect(screen.getByText('123-456-7890')).toBeInTheDocument();
            expect(screen.getByText('$10,000')).toBeInTheDocument();
            expect(screen.getByText('5')).toBeInTheDocument();
            expect(screen.getByText('8/15/2024')).toBeInTheDocument();
        });

        await waitFor(() => {
            expect(screen.getByText('Sponsor B')).toBeInTheDocument();
            expect(screen.getByText('Healthcare')).toBeInTheDocument();
            expect(screen.getByText('contact@sponsorB.com')).toBeInTheDocument();
            expect(screen.getByText('098-765-4321')).toBeInTheDocument();
            expect(screen.getByText('$15,000')).toBeInTheDocument();
            expect(screen.getByText('8')).toBeInTheDocument();
            expect(screen.getByText('8/18/2024')).toBeInTheDocument();
        });
    });

    test('displays an error message when there is an error', async () => {
        sponsorDetailService.mockRejectedValue(new Error('Failed to fetch data'));

        render(<SponsorDetails />);
        await waitFor(() => {
            expect(screen.getByText('Error: Failed to fetch data')).toBeInTheDocument();
        });
    });
});

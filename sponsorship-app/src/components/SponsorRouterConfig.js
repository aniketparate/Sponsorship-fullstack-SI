import React from 'react'
import { BrowserRouter, Route, Routes } from 'react-router-dom'
import SponsorHome from './SponsorHome'
import SponsorNav from './SponsorNav'
import SponsorDetails from './SponsorDetails'
import MatchDetails from './MatchDetails'
import PaymentDetails from './PaymentDetails'
import SponsorMatchSummary from './SponsorMatchSummary'

const SponsorRouterConfig = () => {
  return <BrowserRouter>
    <SponsorNav />
    <Routes>
        <Route path='/' element={<SponsorHome />} />
        <Route path='/sponsorpaymentdetails' element={<SponsorDetails />} />
        <Route path='/matchpaymentdetails' element={<MatchDetails />} />
        <Route path='/sponsormatchsummary' element={<SponsorMatchSummary />} />
        <Route path='/paymentdetail' element={<PaymentDetails />} />
    </Routes>
  </BrowserRouter>
}

export default SponsorRouterConfig

import React from 'react'
import './style.css'
import { Link } from 'react-router-dom'

const SponsorNav = () => {
  return <nav className='sponsorNav'>
    <Link className='nav-link' to='/'>Home</Link>
    <Link className='nav-link' to='/sponsorpaymentdetails'>Sponsors Details</Link>
    <Link className='nav-link' to='/matchpaymentdetails'>Match Details</Link>
    <Link className='nav-link' to='/sponsormatchsummary'>Summary</Link>
    <Link className='nav-link' to='/paymentdetail'>Payment</Link>
  </nav>
}

export default SponsorNav

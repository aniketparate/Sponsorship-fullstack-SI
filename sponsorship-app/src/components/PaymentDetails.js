import React, { useState } from 'react'
import { paymentDetailService } from '../services/paymentDetailService';

const PaymentDetails = () => {
    const [formData, setFormData] = useState({
        contractID: '',
        paymentDate: '',
        amountPaid: '',
        paymentStatus: '',
      });
      const [errors, setErrors] = useState({});
      const [successMessage, setSuccessMessage] = useState('');
    
      const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData((prevData) => ({ ...prevData, [name]: value }));
      };
    
      const validateForm = () => {
        const errors = {};
        if (!formData.contractID) errors.contractID = 'Contract ID is required';
        if (!formData.paymentDate) errors.paymentDate = 'Payment Date is required';
        if (!formData.amountPaid || isNaN(formData.amountPaid) || formData.amountPaid <= 0) 
          errors.amountPaid = 'Valid Amount Paid is required';
        if (!formData.paymentStatus) errors.paymentStatus = 'Payment Status is required';
    
        return errors;
      };
    
      const handleSubmit = async (e) => {
        e.preventDefault();
        const formErrors = validateForm();
        
        if (Object.keys(formErrors).length > 0) {
            setErrors(formErrors);
            return;
        }
    
        try {
            const response = await paymentDetailService(formData);

            if (response) {
                setSuccessMessage('Payment details submitted successfully!');
                setFormData({
                    contractID: '',
                    paymentDate: '',
                    amountPaid: '',
                    paymentStatus: '',
                });
                setErrors({});
            } else {
                throw new Error('Failed to submit payment details');
            }
        } catch (error) {
            setErrors({ form: error.message });
        }
    };
    
      return (
        <div className="form-container">
          <h1>Payment Details</h1>
          {successMessage && <p className="success-message">{successMessage}</p>}
          {errors.form && <p className="error-message">{errors.form}</p>}
          <form onSubmit={handleSubmit}>
            <div className="form-group">
              <label htmlFor="contractID">Contract ID</label>
              <input
                type="number"
                id="contractID"
                name="contractID"
                value={formData.contractID}
                onChange={handleChange}
              />
              {errors.contractID && <p className="error-message">{errors.contractID}</p>}
            </div>
            <div className="form-group">
              <label htmlFor="paymentDate">Payment Date</label>
              <input
                type="date"
                id="paymentDate"
                name="paymentDate"
                value={formData.paymentDate}
                onChange={handleChange}
              />
              {errors.paymentDate && <p className="error-message">{errors.paymentDate}</p>}
            </div>
            <div className="form-group">
              <label htmlFor="amountPaid">Amount Paid</label>
              <input
                type="number"
                id="amountPaid"
                name="amountPaid"
                value={formData.amountPaid}
                onChange={handleChange}
              />
              {errors.amountPaid && <p className="error-message">{errors.amountPaid}</p>}
            </div>
            <div className="form-group">
              <label htmlFor="paymentStatus">Payment Status</label>
              <input
                type="text"
                id="paymentStatus"
                name="paymentStatus"
                value={formData.paymentStatus}
                onChange={handleChange}
              />
              {errors.paymentStatus && <p className="error-message">{errors.paymentStatus}</p>}
            </div>
            <button type="submit" className="submit-button">Submit</button>
          </form>
        </div>
      );
}

export default PaymentDetails

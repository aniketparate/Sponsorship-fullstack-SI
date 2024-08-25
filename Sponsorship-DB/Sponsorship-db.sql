show search_path;
set search_path to sponsorship,public;

CREATE TABLE sponsors (
    sponsorID SERIAL PRIMARY KEY,
    sponsorName varchar NOT NULL,
    industryType varchar,
    contactEmail varchar UNIQUE NOT NULL,
    phone varchar NOT NULL
);
select * from sponsors;

CREATE TABLE matches (
    matchID SERIAL PRIMARY KEY,
    matchName varchar NOT NULL,
    matchDate date NOT NULL,
    location varchar NOT NULL
);
select * from matches;

CREATE TABLE contracts (
    contractID SERIAL PRIMARY KEY,
    sponsorID integer NOT NULL,
    matchID integer NOT NULL,
    contractDate date NOT NULL,
    contractValue decimal NOT NULL,
    FOREIGN KEY (sponsorID) REFERENCES sponsors(sponsorID),
    FOREIGN KEY (matchID) REFERENCES matches(matchID)
);
select * from contracts

CREATE TABLE payments (
    paymentID SERIAL PRIMARY KEY,
    contractID integer NOT NULL,
    paymentDate date NOT NULL,
    amountPaid decimal NOT NULL,
    paymentStatus varchar CHECK (PaymentStatus IN ('Pending', 'Completed', 'Failed')) NOT NULL,
    FOREIGN KEY (contractID) REFERENCES contracts(contractID)
);
select * from payments


INSERT INTO sponsors (sponsorName, industryType, contactEmail, phone)
VALUES
('Nike', 'Sportswear', 'nike@sports.com', '1234567890'),
('Adidas', 'Sportswear', 'contact@adidas.com', '2345678901'),
('Red Bull', 'Energy', 'info@redbull.com', '3456789012'),
('Puma', 'Sportswear', 'support@puma.com', '4567890123'),
('Under Armour', 'Sportswear', 'hello@underarmour.com', '5678901234'),
('Coca Cola', 'Beverages', 'contact@coca-cola.com', '6789012345'),
('Pepsi', 'Beverages', 'pepsi@contact.com', '7890123456'),
('Samsung', 'Electronics', 'samsung@sponsor.com', '8901234567'),
('Sony', 'Electronics', 'support@sony.com', '9012345678'),
('Visa', 'Financial Services', 'info@visa.com', '1234567890');


INSERT INTO matches (matchName, matchDate, location)
VALUES
('ICC World Cup Final', '2024-11-15', 'Mumbai'),
('UEFA Champions League Final', '2024-06-01', 'London'),
('ISL Semi-Final', '2024-12-10', 'Kolkata'),
('NBA Finals Game 7', '2024-06-25', 'Los Angeles'),
('Super Bowl LVII', '2024-02-10', 'Miami'),
('Wimbledon Mens Final', '2024-07-14', 'London'),
('Tokyo Olympic 100m Final', '2024-07-31', 'Tokyo'),
('FIFA World Cup Semi-Final', '2024-12-18', 'Doha'),
('Indian Premier League Final', '2024-05-20', 'Chennai'),
('Boston Marathon', '2024-04-19', 'Boston');

INSERT INTO contracts (sponsorID, matchID, contractDate, contractValue)
VALUES
(1, 1, '2024-08-01', 150000.00),
(2, 2, '2024-05-15', 200000.00),
(3, 3, '2024-09-20', 100000.00),
(4, 4, '2024-07-01', 180000.00),
(5, 5, '2024-06-10', 250000.00),
(6, 6, '2024-02-01', 220000.00),
(7, 7, '2024-07-25', 175000.00),
(8, 8, '2024-12-01', 300000.00),
(9, 9, '2024-05-10', 270000.00),
(10, 10, '2024-04-01', 160000.00);

INSERT INTO contracts (sponsorID, matchID, contractDate, contractValue)
VALUES
(1, 2, '2024-08-01', 150000.00),  -- Nike sponsoring UEFA Champions League Final
(1, 3, '2024-09-01', 130000.00);  -- Nike sponsoring ISL Semi-Final

INSERT INTO contracts (sponsorID, matchID, contractDate, contractValue)
VALUES
(2, 4, '2024-07-01', 180000.00),  -- Adidas sponsoring NBA Finals Game 7
(2, 5, '2024-06-01', 200000.00);  -- Adidas sponsoring Super Bowl LVII

INSERT INTO contracts (sponsorID, matchID, contractDate, contractValue)
VALUES
(3, 6, '2024-07-10', 120000.00),  -- Red Bull sponsoring Wimbledon Men's Final
(3, 7, '2024-08-01', 140000.00);  -- Red Bull sponsoring Tokyo Olympic 100m Final

INSERT INTO payments (contractID, paymentDate, amountPaid, paymentStatus)
VALUES
(1, '2024-08-10', 75000.00, 'Completed'),
(1, '2024-09-10', 75000.00, 'Completed'),
(2, '2024-06-20', 100000.00, 'Completed'),
(2, '2024-07-20', 100000.00, 'Completed'),
(3, '2024-09-30', 50000.00, 'Completed'),
(3, '2024-10-30', 50000.00, 'Pending'),
(4, '2024-07-10', 90000.00, 'Completed'),
(4, '2024-08-10', 90000.00, 'Pending'),
(5, '2024-06-15', 125000.00, 'Completed'),
(6, '2024-02-20', 110000.00, 'Completed'),
(7, '2024-08-01', 87500.00, 'Completed'),
(8, '2024-12-10', 150000.00, 'Completed'),
(9, '2024-05-25', 135000.00, 'Completed'),
(10, '2024-04-10', 80000.00, 'Completed'),
(10, '2024-05-10', 80000.00, 'Pending');

select * from contracts;
select * from matches;
select * from payments;
select * from sponsors;

-- Retrieve the Top 5 Most Expensive Contracts.Display the ContractId and contract Value.
select contractID, contractValue from contracts order by contractValue desc limit 5;

-- Select all payments that are pending, and update their status to 'Completed' if the payment date is within the last 7 days.
update payments set paymentStatus = 'Completed' where paymentStatus = 'Pending' 
and paymentDate >= current_date - interval '7 days';

--  List All Matches that are Scheduled After July 1, 2024, Sorted by Match Date
select * from matches where matchDate > '2024-07-01' order by matchDate;

-- List All Sponsors and the Number of Matches They Have Sponsored, Including Those Who Haven't Sponsored Any Matches .Display the SponsorName and the Number of MatchesSponsored
select s.sponsorName, count(c.matchID) as "Number of MatchesSponsored"
from sponsors s left join contracts c on s.sponsorID = c.sponsorID
group by s.sponsorName;

-- List the sponsors who have not completed their payments for any contract. Display the SponsorName, ContractID  and status. 
select s.sponsorName, c.contractID, p.paymentStatus from sponsors s
join contracts c on s.sponsorID = c.sponsorID
join payments p on c.contractID = p.contractID
where p.paymentStatus = 'Pending';

-- -----------------------------------------------------------------------------------

-- Retrieve the total contract value for each sponsor, but only for sponsors who have at least one completed payment. Display the Sponsorname and the TotalContractValue
select s.sponsorName, sum(c.contractValue) AS TotalContractValue from sponsors s
join contracts c on s.sponsorID = c.sponsorID
join payments p on c.contractID = p.contractID
where p.paymentStatus = 'Completed' group by s.sponsorName
having count(distinct p.paymentID) > 0;


-- Retrieve sponsors who have sponsored more than one match, along with the total number of matches they have sponsored. Display the Sponsor name and Number of Matches.
select s.sponsorName, count(c.matchID) as "Number Of Matches" from sponsors s
join contracts c on s.sponsorID = c.sponsorID group by s.sponsorName
having count(c.matchID) > 1;

-- List Sponsors Who Have Sponsored Matches with a Higher Total Contract Value Than the Average for All Sponsors:
select s.sponsorID,s.sponsorName,
  coalesce(sum(c.contractValue), 0) as totalContractValue,
    case 
        when coalesce(sum(c.contractValue), 0) > 500000 then 'Platinum'
        when coalesce(sum(c.contractValue), 0) between 200000 and 500000 then 'Gold'
        when coalesce(sum(c.contractValue), 0) between 100000 and 200000 then 'Silver'
        else 'Bronze'
    end as category
from sponsors s left join contracts c on s.sponsorID = c.sponsorID
group by s.sponsorID, s.sponsorName order by totalContractValue desc;

-- Retrieve Matches Where the Average Contract Value is Greater Than the Average Contract Value of All Matches. Display the match name and average contract value.
with MatchAvgValues as (
    select matchID, avg(contractValue) as avgContractValue
    from contracts group by matchID
),
OverallAvgValue as (
    select avg(avgContractValue) as overallAvgValue
    from MatchAvgValues
)
select m.matchName, mav.avgContractValue from matches m
join MatchAvgValues mav on m.matchID = mav.matchID
join OverallAvgValue oav on mav.avgContractValue > oav.overallAvgValue;

--  Find Sponsors Who Have the Highest Total Payments for a Single Match. Display the sponsor name, match name and total amount paid
with MatchTotalPayments as (
    select s.sponsorName, m.matchName, sum(p.amountPaid) as TotalAmountPaid
    from sponsors s join contracts c on s.sponsorID = c.sponsorID
    join matches m on c.matchID = m.matchID
    join payments p on c.contractID = p.contractID
    group by s.sponsorName, m.matchName, c.matchID
),
MaxPayments as (
    select max(TotalAmountPaid) as MaxAmountPaid
    from MatchTotalPayments
)
select mtp.sponsorName, mtp.matchName, mtp.TotalAmountPaid
from MatchTotalPayments mtp join MaxPayments mp on mtp.TotalAmountPaid = mp.MaxAmountPaid;


-- -----------------------------------------------------------------------------------

-- 1
create view match_sponsor_payments as
select m.matchID, m.matchName, m.matchDate,
    m.location, s.sponsorID, s.sponsorName,
    coalesce(sum(p.amountPaid), 0) as totalPayments
from matches m
join contracts c on m.matchID = c.matchID
join sponsors s on c.sponsorID = s.sponsorID
left join payments p on c.contractID = p.contractID
group by m.matchID, m.matchName, m.matchDate, m.location, s.sponsorID, s.sponsorName;

select matchID, matchName, matchDate, location, sponsorName, totalPayments
from match_sponsor_payments where totalPayments > 200000
order by totalPayments desc;


drop view match_sponsor_payments;
-- 2
create view contract_details as
select c.contractID, s.sponsorName, m.matchName, c.contractValue
from contracts c
join sponsors s on c.sponsorID = s.sponsorID
join matches m on c.matchID = m.matchID;

with avg_contract_value as (
    select avg(contractValue) as avgValue from contracts
)
select * from contract_details
where contractValue > (select avgValue from avg_contract_value);

-- 3
create view pending_payments as
select s.sponsorName, p.paymentID, p.contractID,
    p.paymentDate, p.amountPaid, p.paymentStatus
from payments p
join contracts c on p.contractID = c.contractID
join sponsors s on c.sponsorID = s.sponsorID
where p.paymentStatus = 'Pending';

select sponsorName, sum(amountPaid) as totalPendingPayments
from pending_payments group by sponsorName having sum(amountPaid) > 50000;


-- 4
create view sponsor_match_counts as
select s.sponsorName, count(c.matchID) as numberOfMatches
from sponsors s
join contracts c on s.sponsorID = c.sponsorID
group by s.sponsorName;

select sponsorName from sponsor_match_counts where numberOfMatches > 2;

-- 5
create view sponsorship_overview as
select s.sponsorName as "Sponsor Name",
    s.industryType as "Industry Type", s.contactEmail as "Contact Email",
    m.matchName as "Match Name", m.matchDate as "Match Date",
    m.location as "Location", c.contractValue as "Contract Value",
    c.contractDate as "Contract Date",
    coalesce(sum(p.amountPaid), 0) as "Total Amount Paid",
    count(p.paymentID) as "Number of Payments Made",
    max(p.paymentDate) as "Latest Payment Date",
    case 
        when count(p.paymentID) = 0 then 'Pending'
        when sum(p.amountPaid) < c.contractValue then 'Pending'
        else 'Completed'
    end as "Payment Status"
from sponsors s join contracts c on s.sponsorID = c.sponsorID
join matches m on c.matchID = m.matchID
left join payments p on c.contractID = p.contractID
group by s.sponsorName, s.industryType, s.contactEmail, 
m.matchName, m.matchDate, m.location, c.contractValue, c.contractDate
having count(p.paymentID) >= 0 order by s.sponsorName, m.matchDate;

select * from sponsorship_overview;
drop view sponsorship_overview;


-- -----------------------------------------------------------------------------
INSERT INTO matches (matchName, matchDate, location)
VALUES ('New Match', '2024-08-01', 'New Location');

select * from matches;
select * from payments;
select * from sponsors;

SELECT 1 
        FROM payments p
        JOIN contracts c ON p.contractID = c.contractID
        WHERE c.matchID = NEW.matchID
        AND p.paymentDate IS NOT NULL
        AND p.amountPaid IS NOT NULL;

-- sponsor's details along with the total payments made, the number of payments, and the latest payment date.
select s.sponsorID, s.sponsorName, s.industryType, s.contactEmail,
                    s.phone,
    coalesce(sum(p.amountPaid), 0) as totalPaymentsMade,
    count(p.paymentID) as numberOfPayments,
    coalesce(max(p.paymentDate), '1900-01-01') as latestPaymentDate
from sponsorship.sponsors s left join sponsorship.contracts c on s.sponsorID = c.sponsorID
left join sponsorship.payments p on c.contractID = p.contractID
group by s.sponsorID, s.sponsorName, s.industryType, s.contactEmail, s.phone
order by s.sponsorID;


select * from matches;
-- Develop an API endpoint that returns the details of all matches along with the  Match Date, Location and total amount of payments made for each match
select m.matchID, m.matchName, m.matchDate, m.location,
    coalesce(sum(p.amountPaid), 0) as totalPayments
from sponsorship.matches m left join sponsorship.contracts c on m.matchID = c.matchID
left join sponsorship.payments p on c.contractID = p.contractID
group by m.matchID, m.matchName, m.matchDate, m.location
order by m.matchDate;


select * from payments;

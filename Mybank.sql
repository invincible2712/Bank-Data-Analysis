create database mybank;
use mybank;
select * from accounts;
select * from atms;
select * from branches;
select * from credit_cards;
select * from customers;
select * from loans;
select * from transactions;

-- calculate total numbers of customers
select count(*) as TotalCustomers from Customers;

-- calculate tot no. of accounts
select count(*) as TotalAccounts from Accounts;

-- Calculate total loan amount
select sum(amount) as TotalLoansAmount from loans;

-- Calculate total credit limit accross all credit cards
select sum(CreditLimit) as TotalCreditLimit from Credit_Cards;

-- Find all active accounts
select * from accounts where status = 'Active';

-- Find all accounts made after 15th jan 2023
select * from transactions where transactionDate > '2023-01-15';

-- find loans with interest rates above 5.0
select * from loans where InterestRate > 5.0;

-- Find credit cards with Balances exceeding the credit card
select * from credit_cards where Balance > creditlimit;

-- Retrieve customer details along with their accounts
select c.customerID, c.Name, c.Age, a.Accountnumber, a.AccountType, a.Balance
from customers c
JOIN Accounts a ON c.customerID = a.CustomerID;

-- Retrieve transaction details along with associated account and customer information
select t.TransactionID, t.TransactionDate, t.Amount, t.Type, t.Description,
a.AccountNumber, a.AccountType, c.Name as CustomerName
from Transactions t
Join Accounts a ON t.AccountNumber = a.AccountNumber
JOIN Customers c ON a.CustomerID = c.CustomerID;

-- top 10 customers with highest loan amount
select c.Name, I.amount as LoanAmount
from Customers c
JOIN loans I ON c.CustomerID = I.CustomerID
Order by I.amount DESC
limit 10;

-- delete inactive acc
set SQL_Safe_Updates = 0;
Delete From Accounts
where status = "inactive";

-- Find customers with multiple accounts
Select c.CustomerID, c.Name, Count(a.AccountNumber) as NumAccounts
from Customers c
Join accounts a ON c.CustomerID = a.CustomerID
Group by c.CustomerID, c.Name 
Having Count(a.AccountNumber) > 1;

-- Print the first 3 characters of name from customers table
Select Substring(Name , 1,3) as FirstThreeCharactersofname
from customers;

-- Print the name from customers table into two columns FirstName and LAstName 
select
substring_index(Name,' ',1) as FirstName,
substring_index(Name,' ',-1) as LastName
from customers;

-- SQL query to show only odd rows from Customers Table
select * from Customers
where MOD(CustomerID,2) <> 0;

-- SQL query to determine the 5th highest loan Amount without using LIMIT keyword
select distinct Amount
from loans l1
where 5 = ( 
select count(Distinct Amount)
from loans l2
where l2.Amount >= L1.amount);

-- SQL query to show the second highest loan from the Loans table using sub_query
select MAX(amount) as SecondHighestLoan
from loans
where Amount < (
select Max(amount)
from loans);

-- SQL query to list CustomerID whose account in inactive
select CustomerID
from Accounts
where Status = 'Inactive';

-- SQL query to fetch the first row of the customers table
select * from Customers
limit 1;

-- SQL query to show the current date and time
select now() as CurrentDateTime;

-- SQL query to create a new table which consists of data and structure copied from the customers
create table CustomersClone like customers;
insert into CustomersClone Select * from customers;

-- SQL query to calculate how many days are remaining for customers to pay off the loans
select customerID,
DateDiff(EndDate,CurDate()) as DaysRemaining
from loans
where EndDate > CurDate();

-- Query to find the latest transaction date for each account
Select AccountNumber, Max(TransactionDate) as LatestTransactionDate 
from Transactions
Group by AccountNumber;

-- Find the average age of customers
Select avg(age) as AverageAge
from customers;

-- Find accounts with less than minimum amount for accounts opened before 1st jan 2022
select AccountNumber, Balance
from Accounts 
where Balance < 25000
and OpenDate <= '2022-01-01';

-- Find loans that are currently active
select * from loans
where EndDate >= curdate()
and status = 'Active';

-- Find the total amount of transactions for each account for a specific month
select AccountNumber, SUM(Amount) as TotalAmount
from Transactions
where Month(TransactionsDate) = 6
And year(TransactionDate) = 2023
group by AccountNumber;--

-- Find the avg credeit card baalance for each Customer
Select CustomerID, AVG(Balance) as AverageCreditCardBalance
from credit_cards
group by CustomerID;

-- Find the number of inactive ATms per Location
select Location, Count(*) as NumberOfActiveATMs
from ATMs
where status = 'Out of Service'
group by Location;

-- male and female count
select gender , count(*) as MaleFemalecount
from customers
group by gender;

-- name starts with j
select * from customers
where name like 'j%';

-- ends with outlook.com';
select * from customers
where email like '%outlook.com';

-- Categorize in different age groups : Below 30 , 30 to 60 , Above 60
select name , age , case when age < 30 then 'Below 30'
when age Between 30 and 60 then '30 to 60'
else 'Above 60'
End as Age_group
from Customers;

-- Transactions withdrawl above 20000 in 5(May)
select * from transactions
where type = 'withdrawal'
and amount > 2000
and month(Transactiondate) = 5;

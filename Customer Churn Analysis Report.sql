CREATE DATABASE bank_churn;
USE bank_churn;

CREATE TABLE customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Surname VARCHAR(50),
    CreditScore INT,
    Geography VARCHAR(50),
    Gender VARCHAR(10),
    Age INT,
    Tenure INT,
    Balance FLOAT,
    NumOfProducts INT,
    HasCrCard INT,
    IsActiveMember INT,
    EstimatedSalary FLOAT,
    Exited INT
);

DESCRIBE customers;

-- See first 10 rows
SELECT * FROM customers LIMIT 10;

-- Count total customers
SELECT COUNT(*) as TotalCustomers FROM customers;

-- TASK 1: DML - Explore customer segments

-- 1. Churn Overview
SELECT 
    Exited,
    COUNT(*) as CustomerCount,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customers), 2) as Percentage
FROM customers
GROUP BY Exited;

-- 2. Churn by Geography
SELECT 
    Geography,
    SUM(Exited) as ChurnedCustomers,
    COUNT(*) as TotalCustomers,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) as ChurnRate
FROM customers
GROUP BY Geography
ORDER BY ChurnRate DESC;

-- 3. Churn by Gender
SELECT 
    Gender,
    SUM(Exited) as ChurnedCustomers,
    COUNT(*) as TotalCustomers,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) as ChurnRate
FROM customers
GROUP BY Gender;

-- 4. Churn by Age Groups
SELECT 
    CASE 
        WHEN Age < 30 THEN '18-29'
        WHEN Age < 40 THEN '30-39'
        WHEN Age < 50 THEN '40-49'
        ELSE '50+'
    END as AgeGroup,
    SUM(Exited) as ChurnedCustomers,
    COUNT(*) as TotalCustomers,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) as ChurnRate
FROM customers
GROUP BY AgeGroup
ORDER BY ChurnRate DESC;

-- TASK 2: Summary Statistics

-- Credit Score Statistics
SELECT 
    AVG(CreditScore) as Mean_CreditScore,
    MIN(CreditScore) as Min_CreditScore,
    MAX(CreditScore) as Max_CreditScore,
    STDDEV(CreditScore) as StdDev_CreditScore
FROM customers;

-- Balance Statistics
SELECT 
    AVG(Balance) as Mean_Balance,
    MIN(Balance) as Min_Balance,
    MAX(Balance) as Max_Balance,
    STDDEV(Balance) as StdDev_Balance
FROM customers;

-- Compare churned vs retained customers
SELECT 
    Exited,
    AVG(CreditScore) as Avg_CreditScore,
    AVG(Balance) as Avg_Balance,
    AVG(Age) as Avg_Age
FROM customers
GROUP BY Exited;

-- TASK 3: Key Churn Metrics

-- Multi-dimensional churn analysis
SELECT 
    Geography,
    Gender,
    AVG(Age) as Avg_Age,
    AVG(CreditScore) as Avg_CreditScore,
    AVG(Balance) as Avg_Balance,
    AVG(NumOfProducts) as Avg_Products,
    SUM(Exited) as Churned,
    COUNT(*) as Total,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) as ChurnRate
FROM customers
GROUP BY Geography, Gender
ORDER BY ChurnRate DESC;
CREATE database business_performance_analysis;
USE business_performance_analysis;
 CREATE TABLE projects (
     ProjectID INT PRIMARY KEY,
     ProjectName VARCHAR(100),
	Department VARCHAR(50),
	Region VARCHAR(50),
	Revenue DECIMAL(10,1) );


INSERT INTO projects VALUES
(1, 'AI Automation', 'IT', 'North', 120000),
(2, 'Cloud Migration', 'IT', 'South', 150000),
(3, 'HR Training', 'HR', 'North', 60000),
(4, 'Recruitment Drive', 'HR', 'West', 75000),
(5, 'Sales Campaign', 'Sales', 'East', 200000),
(6, 'Market Research', 'Sales', 'East', 180000),
(7, 'Finance Audit', 'Finance', 'South', 90000),
(8, 'Budget Planning', 'Finance', 'North', 110000);


SELECT * FROM projects;


SELECT ProjectID, ProjectName, Department, Revenue
FROM (
    SELECT 
         ProjectID,
         ProjectName,
         Department,
         Revenue,
         ROW_NUMBER() OVER (
		PARTITION BY Department 
             ORDER BY Revenue DESC
         ) AS rn
     FROM projects
) ranked WHERE rn = 1;




SELECT ProjectID, ProjectName, Department, Revenue
FROM (
    SELECT 
        ProjectID,
        ProjectName,
        Department,
        Revenue,
        ROW_NUMBER() OVER (
            PARTITION BY Department 
            ORDER BY Revenue DESC
        ) AS rn
    FROM projects
) ranked
WHERE rn = 1;



WITH RegionRevenue AS (
    SELECT 
        Region,
        ProjectID,
        Revenue,
        SUM(Revenue) OVER (
            PARTITION BY Region 
            ORDER BY ProjectID
        ) AS CumulativeRevenue
    FROM projects
)
SELECT * 
FROM RegionRevenue;
SELECT VERSION();




SELECT p.*
FROM projects p
JOIN (
    SELECT Department, MAX(Revenue) AS MaxRevenue
    FROM projects
    GROUP BY Department
) t
ON p.Department = t.Department
AND p.Revenue = t.MaxRevenue;
-- 📌 Summary
-- Issue	Fix
-- Errors on ROW_NUMBER	Connect to MySQL 8.0
-- Errors on WITH (CTE)	Use MySQL 8.0
-- Status = unconnected	🔴 Main problem
-- Logic	✅ 100% correct



CREATE DATABASE business_performance_analysis;


CREATE TABLE projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100),
    Department VARCHAR(50),
    Region VARCHAR(50),
    Revenue DECIMAL(10,2)
);


INSERT INTO projects VALUES
(1, 'AI Automation', 'IT', 'North', 120000),
(2, 'Cloud Migration', 'IT', 'South', 150000),
(3, 'HR Training', 'HR', 'North', 60000),
(4, 'Recruitment Drive', 'HR', 'West', 75000),
(5, 'Sales Campaign', 'Sales', 'East', 200000),
(6, 'Market Research', 'Sales', 'East', 180000),
(7, 'Finance Audit', 'Finance', 'South', 90000),
(8, 'Budget Planning', 'Finance', 'North', 110000);
✔️ Data inserted.



SELECT * FROM projects;


SELECT ProjectID, ProjectName, Department, Revenue
FROM (
    SELECT 
        ProjectID,
        ProjectName,
        Department,
        Revenue,
        ROW_NUMBER() OVER (
            PARTITION BY Department 
            ORDER BY Revenue DESC
        ) AS rn
    FROM projects
) ranked
WHERE rn = 1;

WITH RegionRevenue AS (
    SELECT 
        Region,
        ProjectID,
        Revenue,
        SUM(Revenue) OVER (
            PARTITION BY Region 
            ORDER BY ProjectID
        ) AS CumulativeRevenue
    FROM projects
)
SELECT * FROM RegionRevenue;

sql


SELECT 
    Department,
    SUM(Revenue) AS TotalRevenue,
    AVG(Revenue) AS AvgRevenue
FROM projects
GROUP BY Department
ORDER BY TotalRevenue DESC;

SELECT 
    Department,
    SUM(Revenue) AS DepartmentRevenue,
    ROUND(
        SUM(Revenue) * 100 / SUM(SUM(Revenue)) OVER (), 
        2
    ) AS RevenueContributionPercent
FROM projects
GROUP BY Department
ORDER BY RevenueContributionPercent DESC;

SELECT 
    ProjectID,
    ProjectName,
    Department,
    Revenue,
    RANK() OVER (
        PARTITION BY Department 
        ORDER BY Revenue DESC
    ) AS RevenueRank
FROM projects;

SELECT
    Region,
    ProjectID,
    Revenue,
    SUM(Revenue) OVER (
        PARTITION BY Region
        ORDER BY ProjectID
    ) AS RunningRevenue
FROM projects;

SELECT
    ProjectID,
    ProjectName,
    Revenue,
    CASE
        WHEN Revenue >= 150000 THEN 'High Performer'
        WHEN Revenue >= 100000 THEN 'Medium Performer'
        ELSE 'Low Performer'
    END AS PerformanceCategory
FROM projects;


SELECT
    ProjectID,
    ProjectName,
    Department,
    Revenue,
    ROUND(
        Revenue - AVG(Revenue) OVER (PARTITION BY Department),
        2
    ) AS DeviationFromDeptAvg
FROM projects;

SELECT *
FROM (
    SELECT
        ProjectID,
        ProjectName,
        Department,
        Revenue,
        DENSE_RANK() OVER (
            PARTITION BY Department
            ORDER BY Revenue DESC
        ) AS rnk
    FROM projects
) t
WHERE rnk <= 2;


SELECT
    Region,
    SUM(Revenue) AS RegionRevenue,
    ROUND(
        SUM(Revenue) * 100 / SUM(SUM(Revenue)) OVER (),
        2
    ) AS RegionRevenuePercent
FROM projects
GROUP BY Region;

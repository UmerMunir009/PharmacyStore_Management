
CREATE PROCEDURE GetTopEmployeeingivenTime
    @startDate DATE,
    @endDate DATE
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);

    SET @sql = 'CREATE VIEW TopEmployeeingivenTime AS SELECT TOP 1 Emp_ID,COUNT(Cus_SalesOrder.Cus_OrderID) AS NumberOfCustomers
    FROM Cus_SalesOrder where OrderDate BETWEEN ''' + CONVERT(VARCHAR, @startDate, 120) + ''' AND ''' + CONVERT(VARCHAR, @endDate, 120) + '''
    group by Emp_ID order by NumberOfCustomers DESC;';

    EXEC sp_executesql @sql;
END 

SELECT * FROM TopEmployeeingivenTime;

EXEC GetTopEmployeeingivenTime '2021-01-01', '2024-03-31';  


--------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE CustomerOrdersSummary
AS
BEGIN
    SELECT  c.CNIC,  c.Cus_Name,  COUNT(o.Cus_OrderID) AS TotalOrders FROM Customer c
     LEFT JOIN Cus_SalesOrder o ON c.CNIC = o.Cus_CNIC
    GROUP BY  c.CNIC, c.Cus_Name;
END;
EXEC CustomerOrdersSummary;


CREATE VIEW vw_CustomerOrdersSummary AS
SELECT 
    c.CNIC, 
    c.Cus_Name, 
    COUNT(o.Cus_OrderID) AS TotalOrders
FROM 
    Customer c
    LEFT JOIN Cus_SalesOrder o ON c.CNIC = o.Cus_CNIC
GROUP BY 
    c.CNIC, c.Cus_Name;
	
select * from vw_CustomerOrdersSummary;
	


-----------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE MaxSellingMedicines
AS
BEGIN
    SELECT  TOP 10 m.Med_Name,SUM(O.PurMed_Price) AS TotalSalesAmount FROM   Medicine_Stock m
    INNER JOIN Ordered_Medicine om ON m.Med_Code = om.MedCode
    INNER JOIN Cus_SalesOrder o ON om.COrderID = o.Cus_OrderID
    INNER JOIN Cus_Invoice i ON o.Cus_OrderID = i.COrderID
    GROUP BY  m.Med_Name ORDER BY TotalSalesAmount DESC;
END;

EXEC MaxSellingMedicines

CREATE VIEW vwMaxSellingMedicines AS
SELECT  TOP 10  m.Med_Name, SUM(o.PurMed_Price) AS TotalSalesAmount
FROM 
    Medicine_Stock m
    INNER JOIN Ordered_Medicine om ON m.Med_Code = om.MedCode
    INNER JOIN Cus_SalesOrder o ON om.COrderID = o.Cus_OrderID
    INNER JOIN Cus_Invoice i ON o.Cus_OrderID = i.COrderID
GROUP BY m.Med_Name ORDER BY TotalSalesAmount DESC;

select * from vwMaxSellingMedicines
   

----------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE TopMedicinesDeliveredToBranches
AS
BEGIN
    WITH RankedMedicines AS (
        SELECT 
            mb.BranchName,
            om.MedCode,
            m.Med_Name,
            SUM(om.Quantity) AS TotalQuantityDelivered,
            ROW_NUMBER() OVER(PARTITION BY mb.BranchName ORDER BY SUM(om.Quantity) DESC) AS RowNum
        FROM 
            LocalBranch mb
            INNER JOIN Local_SalesOrder os ON mb.BranchCode = os.BCode
            INNER JOIN Loc_Ordered_Medicine om ON os.Local_OrderID = om.LOrderID
            INNER JOIN Medicine_Stock m ON om.MedCode = m.Med_Code
        GROUP BY 
            mb.BranchName, om.MedCode, m.Med_Name
    )
    SELECT 
        BranchName,
        MedCode,
        Med_Name,
        TotalQuantityDelivered
    FROM 
        RankedMedicines
    WHERE 
        RowNum = 1; 
END;

EXEC TopMedicinesDeliveredToBranches;


CREATE VIEW viewTopMedicinesDeliveredToBranches AS
WITH RankedMedicines AS (
    SELECT 
        mb.BranchName,
        om.MedCode,
        m.Med_Name,
        SUM(om.Quantity) AS TotalQuantityDelivered,
        ROW_NUMBER() OVER(PARTITION BY mb.BranchName ORDER BY SUM(om.Quantity) DESC) AS RowNum
    FROM 
        LocalBranch mb
        INNER JOIN Local_SalesOrder os ON mb.BranchCode = os.BCode
        INNER JOIN Loc_Ordered_Medicine om ON os.Local_OrderID = om.LOrderID
        INNER JOIN Medicine_Stock m ON om.MedCode = m.Med_Code
    GROUP BY 
        mb.BranchName, om.MedCode, m.Med_Name
)
SELECT 
    BranchName,
    MedCode,
    Med_Name,
    TotalQuantityDelivered
FROM 
    RankedMedicines
WHERE 
    RowNum = 1; 

select * from viewTopMedicinesDeliveredToBranches
------------------------------------------------------------------------------------------------------------------------------------
---Analytical Reports


CREATE PROCEDURE ProductSalesByMonYear
AS
BEGIN
    SELECT 
        m.Med_Name AS ProductName,YEAR(o.OrderDate) AS Year, MONTH(o.OrderDate) AS Month, SUM(o.PurMed_Price) AS TotalSalesAmount
    FROM 
        Medicine_Stock m
        INNER JOIN Ordered_Medicine om ON m.Med_Code = om.MedCode
        INNER JOIN Cus_SalesOrder o ON om.COrderID = o.Cus_OrderID
        INNER JOIN Cus_Invoice i ON o.Cus_OrderID = i.COrderID
    GROUP BY 
        m.Med_Name, YEAR(o.OrderDate), MONTH(o.OrderDate)
    ORDER BY 
        m.Med_Name, Year, Month;
END;

EXEC ProductSalesByMonYear;

CREATE VIEW viewProductSalesByMonYear AS
SELECT 
    m.Med_Name AS ProductName,YEAR(o.OrderDate) AS Year,MONTH(o.OrderDate) AS Month,SUM(o.PurMed_Price) AS TotalSalesAmount
FROM 
    Medicine_Stock m
    INNER JOIN Ordered_Medicine om ON m.Med_Code = om.MedCode
    INNER JOIN Cus_SalesOrder o ON om.COrderID = o.Cus_OrderID
    INNER JOIN Cus_Invoice i ON o.Cus_OrderID = i.COrderID
GROUP BY  m.Med_Name, YEAR(o.OrderDate), MONTH(o.OrderDate) 

select * from viewProductSalesByMonYear order by ProductName



------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE BranchSalesAnalysis
AS
BEGIN 
    SELECT lb.BranchName,ls.OrderDate,SUM(ls.Payable_Amount) AS TotalSalesAmount,COUNT(*) AS TotalOrders
    FROM LocalBranch lb
    INNER JOIN Local_SalesOrder ls ON lb.BranchCode = ls.BCode
    GROUP BY lb.BranchName, ls.OrderDate
    ORDER BY lb.BranchName, ls.OrderDate;
END;

EXEC BranchSalesAnalysis;


--------------------------------------------------------------------------------------------------------------------------

--Materialized View
go
create view mv_CustomerOrdersSummary with schemabinding as
SELECT c.CNIC, c.Cus_Name, COUNT(*) AS TotalOrders FROM  dbo.Customer c
    INNER JOIN dbo.Cus_SalesOrder o ON c.CNIC = o.Cus_CNIC
GROUP BY 
    c.CNIC, c.Cus_Name;
GO 

CREATE UNIQUE CLUSTERED INDEX IX_mv_CustomerOrdersSummary ON mv_CustomerOrdersSummary (CNIC);

select * from mv_CustomerOrdersSummary;
















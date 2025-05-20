CREATE PROCEDURE InsertACustomer
    @CNIC varchar(50),
    @Cus_Name varchar(50),
    @CusAddress nvarchar(100),
    @Ph_Number varchar(30),
    @Cus_Type varchar(20)  
AS
BEGIN
 
    IF NOT EXISTS (SELECT 1 FROM Customer WHERE CNIC = @CNIC)
    BEGIN
        INSERT INTO Customer (CNIC, Cus_Name, CusAddress, Ph_Number, Cus_Type)
        VALUES (@CNIC, @Cus_Name, @CusAddress, @Ph_Number, @Cus_Type);
    END
    ELSE
    BEGIN
        PRINT 'Error: CNIC already exists.';
    END
END

CREATE PROCEDURE InsertEmployeeInfo
    @Emp_Type varchar(30),
    @Salary int
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM EmployeeInfo WHERE Emp_Type = @Emp_Type)
    BEGIN
        INSERT INTO EmployeeInfo (Emp_Type, Salary) VALUES (@Emp_Type, @Salary);
    END
    ELSE
    BEGIN
        PRINT 'Error: Employee Type already exists.';   
    END
END


CREATE PROCEDURE InsertEmployee
    @EmpID varchar(30),
    @Emp_Name varchar(50),
    @Ph_Number1 varchar(30),
    @EmpAddress nvarchar(100),
    @JoiningDate date,
    @Emp_Type varchar(30)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Employee WHERE EmpID = @EmpID)
    BEGIN
        IF EXISTS (SELECT 1 FROM EmployeeInfo WHERE Emp_Type = @Emp_Type)
        BEGIN
            INSERT INTO Employee (EmpID, Emp_Name, Ph_Number1, EmpAddress, JoiningDate, Emp_Type)
            VALUES (@EmpID, @Emp_Name, @Ph_Number1, @EmpAddress, @JoiningDate, @Emp_Type);
        END
        ELSE
        BEGIN
            PRINT 'Error: Employee Type does not exist in EmployeeInfo.';
        END
    END
    ELSE
    BEGIN
        PRINT 'Error: Employee ID already exists.';
    END
END


CREATE PROCEDURE InsertMedStock
    @Med_Code varchar(30),
    @Med_Name varchar(50),
    @Quantity int,
    @CostPrice float,
    @SalePrice float,
    @Manu_Date date,
    @ExpiryDate date
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Medicine_Stock WHERE Med_Code = @Med_Code)
    BEGIN
        INSERT INTO Medicine_Stock (Med_Code, Med_Name, Quantity, CostPrice, SalePrice, Manu_Date, ExpiryDate)
		VALUES (@Med_Code, @Med_Name, @Quantity, @CostPrice, @SalePrice, @Manu_Date, @ExpiryDate);
    END
    ELSE
    BEGIN
        PRINT 'Error: Medicine Code already exists.';
    END
END



CREATE PROCEDURE InsertCusSalesOrder
    @Cus_OrderID varchar(30),
    @Emp_ID varchar(30),
    @Cus_CNIC varchar(50),
    @HC_Services1 varchar(15),
    @HC_Services2 varchar(15),
    @PurMed_Price float,
    @OrderDate date,
    @OrderTime time
AS
BEGIN

    IF NOT EXISTS (SELECT 1 FROM Cus_SalesOrder WHERE Cus_OrderID = @Cus_OrderID)
    BEGIN
        IF EXISTS (SELECT 1 FROM Customer WHERE CNIC = @Cus_CNIC)
        BEGIN
            INSERT INTO Cus_SalesOrder (Cus_OrderID, Emp_ID, Cus_CNIC, HC_Services1, HC_Services2, PurMed_Price, OrderDate, OrderTime)
            VALUES (@Cus_OrderID, @Emp_ID, @Cus_CNIC, @HC_Services1, @HC_Services2, @PurMed_Price, @OrderDate, @OrderTime);
        END
        ELSE
        BEGIN
            PRINT 'Error: Customer CNIC does not exist.';
        END
    END
    ELSE
    BEGIN
        PRINT 'Error: Customer Order ID already exists.';
    END
END
EXEC InsertCusSalesOrder 'ODR2505', 'EMP1', '352022350895', null, 'BP-Check', 0.0, '2024-05-28', '12:00:00';



CREATE PROCEDURE InsertIntoOrdMedicine
    @COrderID varchar(30),
    @MedCode varchar(30),
    @Quantity int
AS
BEGIN
    DECLARE @PricePerUnit float;

    SELECT @PricePerUnit = SalePrice FROM Medicine_Stock WHERE Med_Code = @MedCode;

    INSERT INTO Ordered_Medicine (COrderID, MedCode, Quantity, PricePerUnit)
    VALUES (@COrderID, @MedCode, @Quantity, @PricePerUnit);

	UPDATE Medicine_Stock SET Quantity = Quantity - @Quantity WHERE Med_Code = @MedCode;

    UPDATE Cus_SalesOrder SET PurMed_Price = PurMed_Price +( @Quantity * @PricePerUnit ) where Cus_OrderID=@COrderID

END
drop Procedure InsertIntoOrdMedicine


CREATE PROCEDURE GenerateCusInvoice
AS
BEGIN
    DECLARE @COrderID VARCHAR(30);
    DECLARE @CNIC VARCHAR(50);
    DECLARE @DeliveryCharges INT;
    DECLARE @TotalBill FLOAT;
    DECLARE @Discount FLOAT;
    DECLARE @PayAble_Amount FLOAT;
    DECLARE @LoopIndex INT;

    SET @COrderID = 'ODR';
    SET @LoopIndex = 1;
    WHILE @LoopIndex <= 4000
    BEGIN
        SET @COrderID = 'ODR' + CONVERT(VARCHAR, @LoopIndex);
        SELECT @CNIC = Cus_CNIC FROM Cus_SalesOrder WHERE Cus_OrderID = @COrderID;
        SELECT @TotalBill = PurMed_Price FROM Cus_SalesOrder WHERE Cus_OrderID = @COrderID;

        IF (SELECT HC_Services1 FROM Cus_SalesOrder WHERE Cus_OrderID = @COrderID) IS NOT NULL
        BEGIN
            SET @TotalBill = @TotalBill + 50;
        END;

        IF (SELECT HC_Services2 FROM Cus_SalesOrder WHERE Cus_OrderID = @COrderID) IS NOT NULL
        BEGIN
            SET @TotalBill = @TotalBill + 50;
        END;

        IF EXISTS (SELECT 1 FROM Customer WHERE CNIC = @CNIC AND Cus_Type = 'On-Site')
        BEGIN
            SET @DeliveryCharges = 0;
        END
        ELSE
        BEGIN
            SET @DeliveryCharges = 200;
            SET @TotalBill = @TotalBill + 200;
        END;

		IF (SELECT COUNT(*) FROM Cus_SalesOrder WHERE Cus_CNIC = @CNIC) > 3
		BEGIN
            SET @Discount = @TotalBill *  0.10;
		END
        ELSE
		BEGIN
            SET @Discount = 0;
        END;

        SET @PayAble_Amount = @TotalBill - @Discount;


 INSERT INTO Cus_Invoice (COrderID, Cus_CNIC, DeliveryCharges, TotalBill, Discount, PayAble_Amount) 
 VALUES (@COrderID, @CNIC, @DeliveryCharges, @TotalBill, @Discount, @PayAble_Amount);

        SET @LoopIndex = @LoopIndex + 1;
    END;
END;

drop procedure GenerateCusInvoice
delete from Cus_Invoice
select *from Cus_Invoice
EXEC GenerateCusInvoice;


-----------------------------------------------------------------------------------------------------
CREATE PROCEDURE InsertIntoSupplier
    @CompanyID varchar(30),
    @CompanyName varchar(50),
    @Email varchar(30),
    @Sup_Address varchar(50)
AS
BEGIN
        INSERT INTO Supplier (CompanyID, CompanyName, Email, Sup_Address)
        VALUES (@CompanyID, @CompanyName, @Email, @Sup_Address);

END


CREATE PROCEDURE InsertIntoPurchaseOrder
    @PurchaseID varchar(30),
    @CompanyID varchar(30),
    @PayableAmount float,
    @OrderDate date,
    @OrderTime time
AS
BEGIN
    INSERT INTO PurchaseOrder (PurchaseID, CompanyID, PayAble_Amount, OrderDate, OrderTime)
    VALUES (@PurchaseID, @CompanyID, @PayableAmount, @OrderDate, @OrderTime);
END


CREATE PROCEDURE InsertPurMedicine
    @PurchaseID varchar(30),
    @MedCode varchar(30),
    @Quantity int
AS
BEGIN
    UPDATE Medicine_Stock SET Quantity = Quantity + @Quantity WHERE Med_Code = @MedCode;
    DECLARE @PricePerUnit float;
    SELECT @PricePerUnit = CostPrice FROM Medicine_Stock WHERE Med_Code = @MedCode;

    INSERT INTO PurchasedMedicine (PurchaseID, MedCode, Quantity, PricePerUnit)
    VALUES (@PurchaseID, @MedCode, @Quantity, @PricePerUnit);

    DECLARE @TotalPrice float;
	SET @TotalPrice = @Quantity * @PricePerUnit;

    UPDATE PurchaseOrder SET PayAble_Amount = PayAble_Amount + @TotalPrice  WHERE PurchaseID = @PurchaseID;

END
drop procedure InsertPurMedicine



create procedure InsertLocalBranch
    @BranchCode varchar(30),
    @BranchName varchar(50),
    @Email varchar(30),
    @BranchAddress varchar(50)
AS
BEGIN
    INSERT INTO LocalBranch (BranchCode, BranchName, Email, BranchAddress)
    VALUES (@BranchCode, @BranchName, @Email, @BranchAddress);
END;




CREATE PROCEDURE InsertLocalSalesOrder
    @Local_OrderID varchar(30),
    @BCode varchar(30),
    @Payable_Amount float,
    @OrderDate date,
    @OrderTime time
AS
BEGIN
    IF EXISTS (SELECT 1 FROM LocalBranch WHERE BranchCode = @BCode)
    BEGIN
        INSERT INTO Local_SalesOrder (Local_OrderID, BCode, Payable_Amount, OrderDate, OrderTime)
        VALUES (@Local_OrderID, @BCode, @Payable_Amount, @OrderDate, @OrderTime);
    END
    ELSE
    BEGIN
        PRINT 'Error: Branch code does not exist.';
    END
END;




CREATE PROCEDURE InsertIntoLocOrdMedicine 
    @LOrderID varchar(30),
    @MedCode varchar(30),
    @Quantity int
AS
BEGIN
    DECLARE @PricePerUnit float;
    SELECT @PricePerUnit = CostPrice FROM Medicine_Stock WHERE Med_Code = @MedCode;

    INSERT INTO Loc_Ordered_Medicine (LOrderID, MedCode, Quantity, PricePerUnit) VALUES (@LOrderID, @MedCode, @Quantity, @PricePerUnit);

    upDate Medicine_Stock set Quantity = Quantity - @Quantity WHERE Med_Code = @MedCode;
    UPDATE Local_SalesOrder SET Payable_Amount = Payable_Amount + (@Quantity * @PricePerUnit) WHERE Local_OrderID = @LOrderID;

END;

EXEC InsertIntoLocOrdMedicine 'L_ODR_1', 'MD1', 70;

drop procedure InsertIntoLocOrdMedicine















        

      
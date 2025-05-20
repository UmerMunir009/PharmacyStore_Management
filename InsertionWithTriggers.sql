
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

EXEC InsertACustomer '352020002997', 'CusCheck', '123 Main Street, City, Country', '1234567890', 'On-Site';

SELECT*from Customer where CNIC='352020002997'

CREATE PROCEDURE InsertintoCusSales 
    @Cus_OrderID varchar(30),
    @Emp_ID varchar(30),
    @Cus_CNIC varchar(50),
    @HC_Services1 varchar(15),
    @HC_Services2 varchar(15),
   -- @PurMed_Price float,
    @OrderDate date,
    @OrderTime time
AS
BEGIN

    IF NOT EXISTS (SELECT 1 FROM Cus_SalesOrder WHERE Cus_OrderID = @Cus_OrderID)
    BEGIN
        IF EXISTS (SELECT 1 FROM Customer WHERE CNIC = @Cus_CNIC)
        BEGIN 
		    declare @PurMed_Price float;
			set  @PurMed_Price =0.0;
            INSERT INTO Cus_SalesOrder (Cus_OrderID, Emp_ID, Cus_CNIC, HC_Services1, HC_Services2, PurMed_Price, OrderDate, OrderTime)
            VALUES (@Cus_OrderID, @Emp_ID, @Cus_CNIC, @HC_Services1, @HC_Services2, @PurMed_Price, @OrderDate, @OrderTime);
    END
        
    END
 
END
EXEC InsertintoCusSales 'ODR2506', 'EMP1', '352020002997', null, 'BP-Check', '2024-05-28', '12:00:00';

select*from Cus_SalesOrder where Cus_OrderID='ODR2506'
select*from Cus_Invoice where COrderID='ODR2506'

CREATE PROCEDURE InsertOrdMed
    @COrderID varchar(30),
    @MedCode varchar(30),
    @Quantity int
AS
BEGIN
    DECLARE @AvailableQuantity int;
    SELECT @AvailableQuantity = Quantity FROM Medicine_Stock WHERE Med_Code = @MedCode;
    IF @AvailableQuantity >= @Quantity
    BEGIN
        DECLARE @PricePerUnit float;
         SELECT @PricePerUnit = SalePrice FROM Medicine_Stock WHERE Med_Code = @MedCode;
        INSERT INTO Ordered_Medicine (COrderID, MedCode, Quantity, PricePerUnit)
        VALUES (@COrderID, @MedCode, @Quantity, @PricePerUnit);
    END
    ELSE
    BEGIN
        PRINT 'Error:Medicine is not present in that Quantity in Medicine_Stock';
    END
END
EXEC InsertOrdMed  @COrderID = 'ODR2506',  @MedCode = 'MD1',  @Quantity = 5;
drop procedure InsertOrdMed


------------------------------------------------------------------------------------------------------

CREATE PROCEDURE InsertPurcOdr
    @PurchaseID varchar(30),
    @CompanyID varchar(30),
    @OrderDate date,
    @OrderTime time
AS
BEGIN
      declare @PayableAmount float;
	  set @PayableAmount =0.0;
    INSERT INTO PurchaseOrder (PurchaseID, CompanyID, PayAble_Amount, OrderDate, OrderTime)
    VALUES (@PurchaseID, @CompanyID, @PayableAmount, @OrderDate, @OrderTime);
END

EXEC InsertPurcOdr 'PUR705', 'CMP10',  '2024-06-01', '12:30:00';





CREATE PROCEDURE InsertPurMedi
    @PurchaseID varchar(30),
    @MedCode varchar(30),
    @Quantity int
AS
BEGIN
   
    DECLARE @PricePerUnit float;
    SELECT @PricePerUnit = CostPrice FROM Medicine_Stock WHERE Med_Code = @MedCode;

    INSERT INTO PurchasedMedicine (PurchaseID, MedCode, Quantity, PricePerUnit)
    VALUES (@PurchaseID, @MedCode, @Quantity, @PricePerUnit);
END

EXEC InsertPurMedi 'PUR705', 'MD1', 103;



--------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE InsertLocalOrder
    @Local_OrderID varchar(30),
    @BCode varchar(30),
    @OrderDate date,
    @OrderTime time
AS
BEGIN
    IF EXISTS (SELECT 1 FROM LocalBranch WHERE BranchCode = @BCode)
    BEGIN
	    declare @Payable_Amount float;
		set  @Payable_Amount=0.0
        INSERT INTO Local_SalesOrder (Local_OrderID, BCode, Payable_Amount, OrderDate, OrderTime)
        VALUES (@Local_OrderID, @BCode, @Payable_Amount, @OrderDate, @OrderTime);
    END
    ELSE
    BEGIN
        PRINT 'Error: Branch code does not exist.';
    END
END;

EXEC InsertLocalOrder @Local_OrderID = 'L_ODR_500', @BCode = 'Branch_1', @OrderDate = '2023-06-01', @OrderTime = '12:00:00';
select *from Local_SalesOrder where Local_OrderID='L_ODR_500'
select*from Loc_Ordered_Medicine where LOrderID='L_ODR_500'
select*from Medicine_Stock



CREATE PROCEDURE InsertLocalSalMed
    @LOrderID varchar(30),
    @MedCode varchar(30),
    @Quantity int
AS
BEGIN
    DECLARE @PricePerUnit float;
    SELECT @PricePerUnit = CostPrice FROM Medicine_Stock WHERE Med_Code = @MedCode;

    INSERT INTO Loc_Ordered_Medicine (LOrderID, MedCode, Quantity, PricePerUnit)
    VALUES (@LOrderID, @MedCode, @Quantity, @PricePerUnit);
END;


EXEC InsertLocalSalMed 'L_ODR_500', 'MD1', 52;












---------------------------------------------------------------------------------------------------------------------------------------------
--DELETION  Procedures

CREATE PROCEDURE DeleteOrdMed
    @COrderID VARCHAR(30),
    @MedCode VARCHAR(30)
AS
BEGIN
    DELETE FROM Ordered_Medicine
    WHERE COrderID = @COrderID AND MedCode = @MedCode;
END;

EXEC DeleteOrdMed @COrderID = 'ODR1', @MedCode = 'MD118';



CREATE PROCEDURE DeletePurMed
    @PurchaseID VARCHAR(30),
    @MedCode VARCHAR(30)
AS
BEGIN
        DELETE FROM PurchasedMedicine
        WHERE PurchaseID = @PurchaseID AND MedCode = @MedCode;
    
END;

EXEC DeletePurMed @PurchaseID = 'PUR33', @MedCode = 'MD244';


--testing
select*from Medicine_Stock where Med_Code='MD244' --8276
select*from PurchasedMedicine where PurchaseID='PUR33'  --7
select*from PurchaseOrder where PurchaseID='PUR33'  --405159.84
select*from PurchasedMedicine_Audit


----------------------------------------------------------------------------------------------------------------------------------------------------
--Updation Procedures



CREATE PROCEDURE UpdateOrderedMedQuantityOfAnyOdr
    @COrderID VARCHAR(30),
    @MedCode VARCHAR(30),
    @NewQuantity INT
AS
BEGIN
    Declare @OldQuantity INT;
    Declare @PricePerUnit FLOAT;
    Declare @Difference INT;
	Declare @Difference2 INT;
    Declare @OldTotalPrice FLOAT;
    Declare @NewTotalPrice FLOAT;
	declare @TotalBill FLOAT;
	DECLARE @CNIC VARCHAR(50);
	DECLARE @Discount FLOAT;
	DECLARE @PayAble_Amount FLOAT;
	
    SELECT @OldQuantity = Quantity, @PricePerUnit = PricePerUnit FROM Ordered_Medicine WHERE COrderID = @COrderID AND MedCode = @MedCode;

    SET @Difference = @NewQuantity - @OldQuantity;
	set @Difference2=@OldQuantity-@NewQuantity;

    UPDATE Ordered_Medicine SET Quantity = @NewQuantity WHERE COrderID = @COrderID AND MedCode = @MedCode;

    IF @Difference > 0 
    BEGIN
        UPDATE Medicine_Stock SET Quantity = Quantity - @Difference WHERE Med_Code = @MedCode;
    END
    ELSE IF @Difference < 0 
    BEGIN
        UPDATE Medicine_Stock SET Quantity = Quantity + @Difference2 WHERE Med_Code = @MedCode;
    END

    SET @OldTotalPrice = @OldQuantity * @PricePerUnit;
    SET @NewTotalPrice = @NewQuantity * @PricePerUnit;

    UPDATE Cus_SalesOrder SET PurMed_Price = (PurMed_Price - @OldTotalPrice) + @NewTotalPrice WHERE Cus_OrderID = @COrderID;

	SELECT @CNIC = Cus_CNIC FROM Cus_SalesOrder WHERE Cus_OrderID = @COrderID;
	SELECT @TotalBill = PurMed_Price FROM Cus_SalesOrder WHERE Cus_OrderID = @COrderID;
	IF (SELECT COUNT(*) FROM Cus_SalesOrder WHERE Cus_CNIC = @CNIC) > 3
		BEGIN
            SET @Discount = @TotalBill *  0.10;
		END
        ELSE
		BEGIN
            SET @Discount = 0;
        END;

        SET @PayAble_Amount = @TotalBill - @Discount;


END;

EXEC UpdateOrderedMedQuantityOfAnyOdr @COrderID = 'ODR1', @MedCode = 'MD185', @NewQuantity = 1;


























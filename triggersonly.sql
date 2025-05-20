--Triggers to manage customer Orders

CREATE TRIGGER Update_Medicine_Stock_OnCusOrders
ON Ordered_Medicine
AFTER INSERT
AS
BEGIN
    DECLARE @MedCode varchar(30);
    DECLARE @Quantity int;
	 
    SELECT @MedCode = i.MedCode, @Quantity = i.Quantity
    FROM inserted i;

    UPDATE Medicine_Stock
    SET Quantity = Quantity - @Quantity
    WHERE Med_Code = @MedCode;
END

CREATE TRIGGER UpdatePurchasePriceOnMedicineAdded
ON Ordered_Medicine
AFTER INSERT
AS
BEGIN
     DECLARE @tempID varchar(30);
	 DECLARE @COrderID2 varchar(30);
	 DECLARE @Quantity int;
	 DECLARE @PricePerUnit float;


	 SELECT @tempID = i.COrderID FROM inserted i;
	 select @COrderID2=Cus_OrderID  FROM Cus_SalesOrder WHERE Cus_OrderID=@tempID

	 SELECT @Quantity = i.Quantity FROM inserted i;
	 SELECT @PricePerUnit = i.PricePerUnit FROM inserted i;
     UPDATE Cus_SalesOrder SET PurMed_Price = PurMed_Price +( @Quantity * @PricePerUnit ) where Cus_OrderID=@COrderID2

END


CREATE TRIGGER cretebillOnPlacingOrder
ON Cus_SalesOrder
AFTER INSERT
AS
BEGIN
    DECLARE @Cus_OrderID varchar(30);
    DECLARE @Cus_CNIC varchar(50);
    DECLARE @CusType varchar(20);
    DECLARE @DeliveryCharges int;

    SELECT @Cus_OrderID = i.Cus_OrderID, @Cus_CNIC = i.Cus_CNIC FROM inserted i;

    SELECT @CusType = Cus_Type FROM Customer WHERE CNIC = @Cus_CNIC;

    IF @CusType = 'Remote'
    BEGIN
        SET @DeliveryCharges = 200;
    END
    ELSE
    BEGIN
        SET @DeliveryCharges = 0;
    END

    INSERT INTO Cus_Invoice (COrderID, Cus_CNIC, DeliveryCharges, TotalBill, Discount, PayAble_Amount)
    VALUES (@Cus_OrderID, @Cus_CNIC, @DeliveryCharges, 0, 0, 0);
END
GO



CREATE TRIGGER UpdateCusInvoiceOninsertingNewMed
ON Ordered_Medicine
AFTER INSERT
AS
BEGIN
    DECLARE @COrderID varchar(30);
    DECLARE @CNIC varchar(50);
    DECLARE @PurMed_Price float;
    DECLARE @TotalBill float;
    DECLARE @DeliveryCharges int;
    DECLARE @Discount float;
    DECLARE @PayAble_Amount float;

    SELECT @COrderID = i.COrderID FROM inserted i;

    SELECT @CNIC = Cus_CNIC, @PurMed_Price = PurMed_Price  FROM Cus_SalesOrder  WHERE Cus_OrderID = @COrderID;

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

    IF (SELECT COUNT(*) FROM Cus_SalesOrder WHERE Cus_CNIC = @CNIC) > 5
    BEGIN
        SET @Discount = @TotalBill * 0.10;
    END
    ELSE
    BEGIN
        SET @Discount = 0;
    END;

    SET @PayAble_Amount = @TotalBill - @Discount;

    UPDATE Cus_Invoice SET TotalBill = @TotalBill, DeliveryCharges = @DeliveryCharges, Discount = @Discount, PayAble_Amount = @PayAble_Amount WHERE COrderID = @COrderID;
END



----------------------------------------------------------------------------------------------------------------------------
--Triggers to manage supplier purchases


CREATE TRIGGER UpdateStockAndBill
ON PurchasedMedicine
AFTER INSERT
AS
BEGIN
    DECLARE @MedCode varchar(30);
    DECLARE @Quantity int;
    DECLARE @PricePerUnit float;
    DECLARE @PurchaseID varchar(30);

    SELECT @MedCode =i.MedCode, @Quantity =i.Quantity, @PurchaseID = i.PurchaseID FROM inserted i;
    SELECT @PricePerUnit = CostPrice FROM Medicine_Stock WHERE Med_Code = @MedCode;

    UPDATE Medicine_Stock SET Quantity = Quantity + @Quantity WHERE Med_Code = @MedCode;

    -- Update PayAble_Amount in PurchaseOrders
    UPDATE PurchaseOrder  SET PayAble_Amount = PayAble_Amount + (@Quantity * @PricePerUnit) WHERE PurchaseID = @PurchaseID;
END

drop trigger UpdateStockAndBill







-------------------------------------------------------------------------------------------------------------------------------------

CREATE TRIGGER UpdateStockAndBillonLocalOrders
ON Loc_Ordered_Medicine
AFTER INSERT
AS
BEGIN
    DECLARE @MedCode varchar(30);
    DECLARE @Quantity int;
    DECLARE @PricePerUnit float;
    DECLARE @LOrderID varchar(30);

    SELECT @MedCode =i.MedCode, @Quantity =i.Quantity, @LOrderID = i.LOrderID FROM inserted i;
    SELECT @PricePerUnit = CostPrice FROM Medicine_Stock WHERE Med_Code = @MedCode;

    UPDATE Medicine_Stock SET Quantity = Quantity - @Quantity WHERE Med_Code = @MedCode;

    UPDATE Local_SalesOrder  SET PayAble_Amount = PayAble_Amount + (@Quantity * @PricePerUnit) WHERE Local_OrderID = @LOrderID;
END

drop trigger UpdateStockAndBill



----------------------------------------------------------------------------------------------------------------------------
--deletion triggers

CREATE TRIGGER Update_Medicine_Stock_OnDelete
ON Ordered_Medicine
AFTER DELETE
AS
BEGIN
    Declare @COrderID varchar(30);
    DECLARE @MedCode VARCHAR(30);
    DECLARE @Quantity INT;
	Declare @PricePerUnit float;
	Declare @TotalBill float;
	declare @Discount float;
	declare @DeliveryCharges float;
	declare @PayAble_Amount float;
	declare @CNIC varchar(50);

	SELECT @CNIC = Cus_CNIC FROM Cus_SalesOrder WHERE Cus_OrderID = @COrderID;
    SELECT @COrderID=d.COrderID,@MedCode = d.MedCode, @Quantity = d.Quantity,@PricePerUnit=d.PricePerUnit
    FROM deleted d;
    insert into Cus_Ordered_Medicine_Audit (COrderID,MedCode,Quantity,PricePerUnit,auditDate) select d.COrderID,d.MedCode,d.Quantity,d.PricePerUnit,GETDATE() FROM deleted d;
   
    UPDATE Medicine_Stock
    SET Quantity = Quantity + @Quantity
    WHERE Med_Code = @MedCode;

	Update Cus_SalesOrder
	set PurMed_Price=PurMed_Price - (@Quantity*@PricePerUnit) where Cus_OrderID=@COrderID

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

END;
select *from Cus_Ordered_Medicine_Audit




CREATE TRIGGER Update_Medicine_Stock_OnPurDelete
ON PurchasedMedicine
AFTER DELETE
AS
BEGIN
    DECLARE @PurchaseID VARCHAR(30);
    DECLARE @MedCode VARCHAR(30);
    DECLARE @Quantity INT;
    DECLARE @PricePerUnit FLOAT;
    DECLARE @TotalBill FLOAT;

    SELECT @PurchaseID = d.PurchaseID, @MedCode = d.MedCode, @Quantity = d.Quantity, @PricePerUnit = d.PricePerUnit FROM deleted d;

    INSERT INTO PurchasedMedicine_Audit (PurchaseID, MedCode, Quantity, PricePerUnit, auditdate)
    SELECT d.PurchaseID, d.MedCode, d.Quantity, d.PricePerUnit, GETDATE() FROM deleted d;

    UPDATE Medicine_Stock SET Quantity = Quantity - @Quantity WHERE Med_Code = @MedCode;

    UPDATE PurchaseOrder
    SET PayAble_Amount = PayAble_Amount - (@Quantity * @PricePerUnit)
    WHERE PurchaseID = @PurchaseID;
END;

----------------------------------------



SELECT 
    name AS TriggerName,
    type_desc AS TriggerType,
    OBJECT_NAME(parent_id) AS TableName,
    create_date AS CreationDate,
    modify_date AS LastModifiedDate,
    OBJECT_SCHEMA_NAME(parent_id) AS Project_Schema
FROM 
    sys.triggers;











































DROP TRIGGER Update_Medicine_Stock;

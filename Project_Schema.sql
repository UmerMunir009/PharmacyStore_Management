create database project;

use project;

create table Customer(
CNIC varchar(50) constraint pk_customer Primary key,
Cus_Name varchar(50) not null,
CusAddress nvarchar(100),
Ph_Number varchar(30),
Cus_Type varchar(20)
);

select distinct  CNIC from Customer ;
select *from Customer;
delete from Customer

create table EmployeeInfo(
Emp_Type varchar(30) constraint pk_EmpInfo primary key,
Salary int 
);
select *from EmployeeInfo

create table Employee(
EmpID varchar(30) constraint pk_Employee Primary Key,
Emp_Name varchar(50) Not null,
Ph_Number1 varchar(30) not null,
EmpAddress nvarchar(100),
JoiningDate date Not Null,
Emp_Type varchar(30) constraint fk_Employee foreign key  references EmployeeInfo(Emp_Type)
);
select *from Employee

create table Medicine_Stock(
Med_Code varchar(30) constraint pk_MedStock primary key,
Med_Name varchar(50) not null,
Quantity int ,
CostPrice float not null,
SalePrice float not null,
Manu_Date date,
ExpiryDate date
);


create table Cus_SalesOrder(
Cus_OrderID VARCHAR(30) constraint pk_CusOrders primary key,
Emp_ID varchar(30),
Cus_CNIC varchar(50) constraint fk_cusSales foreign key references Customer(CNIC),
HC_Services1 varchar(15),
HC_Services2 varchar(15), 
PurMed_Price float,
OrderDate date,
OrderTime time
);

ALTER TABLE Cus_SalesOrder
ADD CONSTRAINT fk_CusSales_EmpID
FOREIGN KEY (Emp_ID) REFERENCES Employee(EmpID);



select*from Medicine_Stock
select *from Cus_SalesOrder where Cus_OrderID='ODR1797'
SELECT*FROM Ordered_Medicine where COrderID='ODR2506'



select *from Cus_Invoice where COrderID='ODR1653'
delete from Cus_Invoice
select *from Cus_SalesOrder where Cus_OrderID='ODR1653'
select*from Ordered_Medicine where COrderID='ODR1653'
select*from Customer where CNIC='352022822204'





create table Ordered_Medicine(
COrderID varchar(30) constraint fk_CusOrders foreign key references Cus_SalesOrder(Cus_OrderID),
MedCode varchar(30) constraint fk_MedStock foreign key references Medicine_Stock(Med_Code),
Quantity int not null,
PricePerUnit float
);

create table Cus_Ordered_Medicine_Audit(
COrderID varchar(30)  foreign key references Cus_SalesOrder(Cus_OrderID),
MedCode varchar(30)  foreign key references Medicine_Stock(Med_Code),
Quantity int not null,
PricePerUnit float,
auditDate date
);




create table Cus_Invoice(
COrderID varchar(30) constraint fk_cusID foreign key references Cus_SalesOrder(Cus_OrderID),
Cus_CNIC varchar(50) constraint fk_Invoice foreign key references Customer(CNIC),
DeliveryCharges int,
TotalBill float,
Discount float,
PayAble_Amount float,
);





-----------------------------------------------------------------
create table Supplier(
CompanyID varchar(30) constraint pk_supplier primary key,
CompanyName varchar(50) not null, 
Email varchar(30),
Sup_Address varchar(50)
);
select *from Supplier



create table PurchaseOrder(
PurchaseID varchar(30) constraint pk_POrders primary key,
Companyid varchar(30) constraint fk_sup foreign key references Supplier(CompanyID),
PayAble_Amount float not null,
OrderDate date,
OrderTime time
);


select*from PurchaseOrder where PurchaseID='PUR705'



create table PurchasedMedicine(
PurchaseID varchar(30) constraint fk_pruOrders references PurchaseOrder(PurchaseID),
MedCode varchar(30) constraint fk_pruMedstock references Medicine_Stock(Med_Code),
Quantity int not null,
PricePerUnit float,
);

create table PurchasedMedicine_Audit(
PurchaseID varchar(30) references PurchaseOrder(PurchaseID),
MedCode varchar(30)  references Medicine_Stock(Med_Code),
Quantity int not null,
PricePerUnit float,
auditdate date
);
select*from PurchasedMedicine where PurchaseID='PUR1'
select*from Medicine_Stock where Med_Code='MD39'




-------------------------------------------------------------------------------
create table LocalBranch(
BranchCode varchar(30) constraint pk_LBrances primary key,
BranchName varchar(50),
Email varchar(30),
BranchAddress varchar(50)
);
select*from LocalBranch


create table Local_SalesOrder(
Local_OrderID varchar(30) constraint pk_LSOrders primary key,
BCode varchar(30) constraint fk_Lbranches foreign key references LocalBranch(BranchCode),
Payable_Amount float ,
OrderDate date,
OrderTime time
);

select*from Local_SalesOrder


 



create table Loc_Ordered_Medicine(
LOrderID varchar(30)   foreign key references Local_SalesOrder(Local_OrderID),
MedCode varchar(30)   foreign key references Medicine_Stock(Med_Code),
Quantity int not null,
PricePerUnit float
);

select*from Medicine_Stock
select*from Local_SalesOrder where Local_OrderID='L_ODR_1'
select*from Loc_Ordered_Medicine where LOrderID='L_ODR_1'
select top 1 Emp_ID,count(Cus_OrderID) From Cus_SalesOrder group by Emp_ID order by count(Cus_OrderID) desc

DELETE FROM Cus_Ordered_Medicine_Audit
delete from PurchasedMedicine_Audit
delete from Cus_Invoice
delete from Ordered_Medicine
delete from PurchasedMedicine
delete from Loc_Ordered_Medicine
delete from Cus_SalesOrder
delete from Customer
delete from Employee
delete from EmployeeInfo
delete from Medicine_Stock
delete from PurchaseOrder
delete from Supplier
delete from Local_SalesOrder
delete from LocalBranch


select*from Customer
select*from Ordered_Medicine
select*from Cus_SalesOrder
select*FROM Employee
select*from Medicine_Stock
select *from Supplier
select*from Loc_Ordered_Medicine
select*from PurchasedMedicine where PurchaseID='PUR1'
select*from PurchaseOrder where PurchaseID='PUR1'
SELECT *FROM Cus_Invoice
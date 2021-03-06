USE [master]
GO
/****** Object:  Database [QuickySaleOnlineStore]    Script Date: 25/10/2017 11:46:14 ******/
CREATE DATABASE [QuickySaleOnlineStore]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'QuickySaleOnlineStore', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQL2012\MSSQL\DATA\QuickySaleOnlineStore.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'QuickySaleOnlineStore_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQL2012\MSSQL\DATA\QuickySaleOnlineStore_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [QuickySaleOnlineStore] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [QuickySaleOnlineStore].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [QuickySaleOnlineStore] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [QuickySaleOnlineStore] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [QuickySaleOnlineStore] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [QuickySaleOnlineStore] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [QuickySaleOnlineStore] SET ARITHABORT OFF 
GO
ALTER DATABASE [QuickySaleOnlineStore] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [QuickySaleOnlineStore] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [QuickySaleOnlineStore] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [QuickySaleOnlineStore] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [QuickySaleOnlineStore] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [QuickySaleOnlineStore] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [QuickySaleOnlineStore] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [QuickySaleOnlineStore] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [QuickySaleOnlineStore] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [QuickySaleOnlineStore] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [QuickySaleOnlineStore] SET  DISABLE_BROKER 
GO
ALTER DATABASE [QuickySaleOnlineStore] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [QuickySaleOnlineStore] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [QuickySaleOnlineStore] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [QuickySaleOnlineStore] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [QuickySaleOnlineStore] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [QuickySaleOnlineStore] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [QuickySaleOnlineStore] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [QuickySaleOnlineStore] SET RECOVERY FULL 
GO
ALTER DATABASE [QuickySaleOnlineStore] SET  MULTI_USER 
GO
ALTER DATABASE [QuickySaleOnlineStore] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [QuickySaleOnlineStore] SET DB_CHAINING OFF 
GO
ALTER DATABASE [QuickySaleOnlineStore] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [QuickySaleOnlineStore] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [QuickySaleOnlineStore]
GO
/****** Object:  User [quickysale]    Script Date: 25/10/2017 11:46:14 ******/
CREATE USER [quickysale] FOR LOGIN [quickysale] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [NT AUTHORITY\SYSTEM]    Script Date: 25/10/2017 11:46:14 ******/
CREATE USER [NT AUTHORITY\SYSTEM] FOR LOGIN [NT AUTHORITY\SYSTEM] WITH DEFAULT_SCHEMA=[NT AUTHORITY\SYSTEM]
GO
ALTER ROLE [db_owner] ADD MEMBER [quickysale]
GO
ALTER ROLE [db_owner] ADD MEMBER [NT AUTHORITY\SYSTEM]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [NT AUTHORITY\SYSTEM]
GO
/****** Object:  Schema [NT AUTHORITY\SYSTEM]    Script Date: 25/10/2017 11:46:15 ******/
CREATE SCHEMA [NT AUTHORITY\SYSTEM]
GO
/****** Object:  StoredProcedure [dbo].[spAddCartItems]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spAddCartItems]
	@StoreCartId varchar(150),
	@FoodItemId decimal(18,0),
	@Count bigint

	AS
BEGIN

Declare @Ifstorecart varchar(150)=null;
Declare @Iffooditem decimal(18,0)=0;

/* check if they exist */
select @Ifstorecart=StoreCartId , @Iffooditem=FoodItemId  from tblStoreCart
where StoreCartId=@StoreCartId and FoodItemId=@FoodItemId;

/*act based on existance*/
if (@Ifstorecart is null) and ( @Iffooditem = 0)
	 begin 
		insert into tblStoreCart(StoreCartId,
		FoodItemId,
		Count, DateCreated) values(@StoreCartId,
		@FoodItemId,
		@Count, getdate());
	end
	else
	begin
		update tblStoreCart set Count= count + 1 where FoodItemId=@FoodItemId;
	end;

	
END

GO
/****** Object:  StoredProcedure [dbo].[spAddCustomerDetail]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spAddCustomerDetail]
	@Username varchar(200),
	@password varchar(50),
	@FirstName varchar(150),
	@LastName varchar(150),
	@Address varchar(500),
	@StateId decimal(18,0),
	@Phone varchar(15),
	@Email varchar(200)
	

	AS
BEGIN
	Insert into tblCustomerDetail (Username ,
	password ,
	FirstName,
	LastName,
	Address ,
	StateId ,
	Phone ,
	Email,
	DateCreated, Total) values(@Username ,
	@password ,
	@FirstName,
	@LastName,
	@Address ,
	@StateId ,
	@Phone ,
	@Email,
	getdate(), 0);
END

GO
/****** Object:  StoredProcedure [dbo].[spAddEnquiryToDB]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spAddEnquiryToDB]
	@Comment varchar(500),
	@Email varchar(100),
	@FirstName varchar(50),
	@LastName varchar(50)
	AS
BEGIN
	Insert into tblContactUs(Comment,
	Email,
	FirstName,
	LastName, EnquiryDate) values(@Comment,
	@Email,
	@FirstName,
	@LastName,
	getdate());
END

GO
/****** Object:  StoredProcedure [dbo].[spAddFoodGroup]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spAddFoodGroup]
	@FoodName varchar(150)
	AS
BEGIN
	Insert into tblFoodGroup(FoodGroupName) values(@FoodName);
END

GO
/****** Object:  StoredProcedure [dbo].[spAddFoodItems]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spAddFoodItems]
	@FoodName varchar(500),
	@FoodGroupId decimal(18,0),
	@FoodCost decimal(18,0),
	@FoodWeightTypeId decimal(18,0),
	@QuantityAvailable int,
	@SellerId decimal(18,0),
	@SubFoodGroupId decimal(18,0),
	@BuyingPrice decimal(18,0),
	@AlternteText varchar(100),
	@FoodPicture varchar(250)
	AS
BEGIN
	insert into tblFoodItem (FoodName,
	FoodGroupId,
	FoodCost,
	FoodWeightTypeId,
	QuantityAvailable,
	SellerId,
	SubFoodGroupId, BuyingPrice, AlternateText, FoodPicture)
	values(@FoodName,
	@FoodGroupId,
	@FoodCost,
	@FoodWeightTypeId,
	@QuantityAvailable,
	@SellerId,
	@SubFoodGroupId, @BuyingPrice, @AlternteText, @FoodPicture);
END

GO
/****** Object:  StoredProcedure [dbo].[spAddFoodWeightType]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spAddFoodWeightType]
	@FoodName varchar(150)
	AS
BEGIN
	Insert into tblFoodWeightType(FoodWeightTypeName) values(@FoodName);
END

GO
/****** Object:  StoredProcedure [dbo].[spAddGuestLoginDetail]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spAddGuestLoginDetail]
	@StoreCartId varchar(150)
	
	AS
BEGIN

insert into tblUserProfile(StoreCartId, UserName, DateCreated) Values(@StoreCartId, 'Guest', getdate());
END

GO
/****** Object:  StoredProcedure [dbo].[spAddMemberToCustomerDB]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spAddMemberToCustomerDB]
	@Username varchar(200),
	@password varchar(20),
	@FirstName varchar(150),
	@LastName varchar(150),
	@Address varchar(500),
	@StateId decimal(18,0),
	@Phone varchar(15),
	@Email varchar(500)
	AS
BEGIN
	insert into tblCustomerDetail(Username,
	password,
	FirstName ,
	LastName,
	Address,
	StateId ,
	Phone ,
	Email, DateCreated, Total) values(@Username,
	@password,
	@FirstName ,
	@LastName,
	@Address,
	@StateId ,
	@Phone ,
	@Email, getdate(), 0);
END

GO
/****** Object:  StoredProcedure [dbo].[spAddOrderToCustomerDB]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spAddOrderToCustomerDB] 
	@StoreCartId varchar(500),
	@FoodItemId decimal(18,0),
	@Quantity int,
	@UserName varchar(200)

AS
BEGIN
Declare @CustomerDetail decimal(18,0)=0;
Declare @FoodUnitPrice decimal(18,2)=0;
Declare @Fee decimal(18,2) =0;

Select @CustomerDetail= CustomerDetailId from tblCustomerDetail where Username= @UserName;
Select @FoodUnitPrice=FoodCost  from tblFoodItem where FoodItemId= @FoodItemId;
Select @Fee = Fee from tblSellerFee;

insert into tblCustomerOrderDetail(StoreCartId,
	FoodItemId,
	Quantity,
	UnitPrice,
	CustomerDetailId, OrderDate, SellerFeePaid) values(@StoreCartId,
	@FoodItemId,
	@Quantity,
	@FoodUnitPrice,
	@CustomerDetail,
	getdate(), (@FoodUnitPrice * @Fee / 100.0 * @Quantity));
	
	--insert into tblOrderNumber(StoreCartId, UserName) values(@StoreCartId, @UserName)

	--delete from tblStoreCart where StoreCartId=@StoreCartId;

	--select OrderNumberId from tblOrderNumber where StoreCartId=@StoreCartId;
END

GO
/****** Object:  StoredProcedure [dbo].[spAddSellerDetail]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spAddSellerDetail]
	@SellerName varchar(150),
    @SellerState varchar(50),
    @SellerAddress varchar(500),
    @SellerPhoneNumber varchar(15),
    @SellerEmail varchar(50),
    @SellerAccountNumber varchar(20),
    @BankId decimal(18,0),
    @SellerAccountName varchar(200)
	AS
BEGIN
	Insert into tblSellerDetails(SellerName, SellerState,
    SellerAddress,
	SellerPhoneNumber,
    SellerEmail,
    SellerAccountNumber,
    BankId,
    SellerAccountName, DateJoined) values(@SellerName, @SellerState,
    @SellerAddress,
    @SellerPhoneNumber,
    @SellerEmail,
    @SellerAccountNumber,
    @BankId,
    @SellerAccountName, getdate());
END

GO
/****** Object:  StoredProcedure [dbo].[spAddSubFoodGroup]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spAddSubFoodGroup]
	@FoodName varchar(150),
	@FoodGroupId decimal(18,0)
	AS
BEGIN
	Insert into tblSubFoodGroup(SubFoodGroupName,FoodGroupId ) values(@FoodName, @FoodGroupId);
END

GO
/****** Object:  StoredProcedure [dbo].[spConfirmAlreadyLoggedIN]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spConfirmAlreadyLoggedIN]
	@StoreCartId varchar(150)
AS
BEGIN
	select * from tblUserProfile where StoreCartId= @StoreCartId;
END

GO
/****** Object:  StoredProcedure [dbo].[spConfirmMemberExists]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spConfirmMemberExists]
	@UserName varchar(50),
	@password varchar(20)
	AS
BEGIN
	select * from tblCustomerDetail where Username=@UserName and password= @password;
END

GO
/****** Object:  StoredProcedure [dbo].[spDecreaseOneCartItem]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spDecreaseOneCartItem]
	@RecordId decimal(18,0)
		AS
BEGIN

Declare @Ifcount int=null;

select @Ifcount=Count from tblStoreCart
where RecordId=@RecordId ;

if(@Ifcount <= 1)
	begin
		
			delete from tblStoreCart where RecordId = @RecordId;
		end;
else
		begin
			update tblStoreCart set Count = count - 1 where RecordId = @RecordId;
		end;

END

GO
/****** Object:  StoredProcedure [dbo].[spDeleteCartItem]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spDeleteCartItem]
	@RecordId decimal(18,0),
	@StoreCartId varchar(150),
	@TotalCount int OUTPUT
	AS
BEGIN
Declare @Ifrecordid decimal(18,0)=null;
Declare @Ifcount int=null;

select @Ifrecordid=RecordId , @Ifcount=Count from tblStoreCart
where RecordId=@RecordId ;

if(@Ifrecordid != 0)
	begin
		if (@Ifcount <= 1)
		begin
			delete from tblStoreCart where RecordId = @RecordId;
		end;
		else
		begin
			update tblStoreCart set Count = count - 1 where RecordId = @RecordId;
		end;
	end;
else
	begin
		delete from tblStoreCart where RecordId = @RecordId;
	end;

Select @TotalCount=sum(Count) from tblStoreCart where StoreCartId= @StoreCartId;
END

GO
/****** Object:  StoredProcedure [dbo].[spDeleteFoodItem]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spDeleteFoodItem]
	@FoodItemId decimal(18,0)
	AS
BEGIN
	delete from tblFoodItem where FoodItemId=@FoodItemId;

END

GO
/****** Object:  StoredProcedure [dbo].[spDeleteOneCartItem]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spDeleteOneCartItem] 
	@RecordID decimal(18,0)
	AS
BEGIN
	Delete from tblStoreCart where RecordID=@RecordID;
END

GO
/****** Object:  StoredProcedure [dbo].[spEmptyCart]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spEmptyCart] 
	@StoreCartId varchar(150)
	AS
BEGIN
	
    -- Insert statements for procedure here
	delete from tblStoreCart where StoreCartId = @StoreCartId;

END

GO
/****** Object:  StoredProcedure [dbo].[spGetAdminDetails]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spGetAdminDetails] 
	
AS
BEGIN
	Select * from tblAdminLogon;
END

GO
/****** Object:  StoredProcedure [dbo].[spGetAllBankDetails]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spGetAllBankDetails]
	AS
BEGIN
	Select * from tblBankDetails;
END

GO
/****** Object:  StoredProcedure [dbo].[spGetAllCustomerDetails]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetAllCustomerDetails]
	AS
BEGIN
	select * from tblCustomerDetail;
END

GO
/****** Object:  StoredProcedure [dbo].[spGetAllFoodGroups]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spGetAllFoodGroups]
	
	AS
BEGIN
	select *  from tblFoodGroup ;

END

GO
/****** Object:  StoredProcedure [dbo].[spGetAllFoodItems]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetAllFoodItems] 
	AS
BEGIN
	
	SELECT * from tblFoodItem;
END

GO
/****** Object:  StoredProcedure [dbo].[spGetAllFoodWeightType]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spGetAllFoodWeightType]
	
	AS
BEGIN
	select *  from tblFoodWeightType;

END

GO
/****** Object:  StoredProcedure [dbo].[spGetAllSubFoodGroups]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spGetAllSubFoodGroups]
	
	AS
BEGIN
	select *  from tblSubFoodGroup;

END

GO
/****** Object:  StoredProcedure [dbo].[spGetLoginDetail]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spGetLoginDetail]
	@StoreCartId varchar(150),
	@UserName varchar(150) OUTPUT
	AS
BEGIN

Select @UserName=UserName from tblUserProfile where StoreCartId= @StoreCartId;
END

GO
/****** Object:  StoredProcedure [dbo].[spGetParticularFoodGroups]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spGetParticularFoodGroups]
	@FoodGroupId decimal(18,0)
	AS
BEGIN
	select *  from tblFoodGroup where FoodGroupId=@FoodGroupId;

END

GO
/****** Object:  StoredProcedure [dbo].[spGetPassowrdForemail]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spGetPassowrdForemail] 
	@Email varchar(200)
AS
BEGIN
	select password from tblCustomerDetail where Username = @Email;
END

GO
/****** Object:  StoredProcedure [dbo].[spGetSearchFoodItems]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spGetSearchFoodItems] 
	@FoodName varchar(150)
	AS
BEGIN
	select * from tblFoodItem where Upper(FoodName) like '%' + Upper(@FoodName) +'%';
END

GO
/****** Object:  StoredProcedure [dbo].[spGetSellerDetail]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spGetSellerDetail]
	
	AS
BEGIN
	select *  from tblSellerDetails;

END

GO
/****** Object:  StoredProcedure [dbo].[spGetStates]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spGetStates]
	AS
BEGIN
	Select * from tblState;
END

GO
/****** Object:  StoredProcedure [dbo].[spGetStoreCartItems]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spGetStoreCartItems] 
	@StoreCartId varchar(150)
	AS
BEGIN
	
    -- Insert statements for procedure here
	Select * from tblStoreCart where StoreCartId = @StoreCartId ;

END

GO
/****** Object:  StoredProcedure [dbo].[spGetTotalCartAmount]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spGetTotalCartAmount]
	@StoreCartId varchar(150),
	@TotalCount varchar(150)  OUTPUT
	AS
BEGIN
Declare @CostPerItem decimal(18,0)=null;
Declare @CountperOrder decimal(18,0)=null;

SELECT 
   @TotalCount=CAST( sum(CONVERT(decimal(14,2), a.FoodCost) * CONVERT(decimal(14,2), b.Count)) as varchar(18))
FROM
	tblStoreCart b join tblFoodItem a on a.FoodItemId = b.FoodItemId and b.StoreCartId =@StoreCartId
    --(SELECT FoodCost AS FoodPrice from tblFoodItem where FoodItemId= b.FoodItemId ) a
    --, (SELECT COUNT as countperOrder  from tblStoreCart) b
END

GO
/****** Object:  StoredProcedure [dbo].[spGetTotalCartCount]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spGetTotalCartCount]
	@StoreCartId varchar(150),
	@TotalCount int OUTPUT
	AS
BEGIN

Select @TotalCount=sum(Count) from tblStoreCart where StoreCartId= @StoreCartId;
END

GO
/****** Object:  StoredProcedure [dbo].[spGetUserNameAfterCheckOut]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spGetUserNameAfterCheckOut]
	@cartId varchar(300)
	AS
BEGIN
	select * from tblOrderNumber where StoreCartId =@cartId;
END

GO
/****** Object:  StoredProcedure [dbo].[spIncreaseOneCartItem]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spIncreaseOneCartItem]
	@RecordId decimal(18,0)
		AS
BEGIN
	begin
			update tblStoreCart set Count = count + 1 where RecordId = @RecordId;
		end;

end;

GO
/****** Object:  StoredProcedure [dbo].[spInsertIntoTblOrderNumber]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spInsertIntoTblOrderNumber]
	@StoreCartId varchar(500),
	@UserName varchar(200)
AS
BEGIN
	insert into tblOrderNumber(StoreCartId, UserName, DateCreated) values(@StoreCartId, @UserName, getdate())

	delete from tblStoreCart where StoreCartId=@StoreCartId;

	select OrderNumberId from tblOrderNumber where StoreCartId=@StoreCartId;
END

GO
/****** Object:  StoredProcedure [dbo].[spMigrateCart]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spMigrateCart] 
	@userName varchar(150),
	@ShoppingCartId varchar(150)
	AS
BEGIN
	UPDATE tblStoreCart
SET UserName = @userName
where StoreCartId=@ShoppingCartId
END

GO
/****** Object:  StoredProcedure [dbo].[spOrdersToSendViaEmail]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spOrdersToSendViaEmail] 
	@CartId varchar(500)
	AS
BEGIN
	select (d.FirstName + ' ' + d.LastName) as CustomerName, d.Email, d.Address, e.OrderNumberId,
	d.Phone, c.SellerEmail, c.SellerName,a.StoreCartId, a.UnitPrice, b.BuyingPrice, a.Quantity, a.OrderDate,b.FoodName, a.SellerFeePaid 
	from tblCustomerOrderDetail a 
	inner join tblFoodItem b on StoreCartId = @CartId and a.FoodItemId = b.FoodItemId 
	inner join tblSellerDetails c on b.SellerId = c.SellerId 
	inner join tblCustomerDetail d on a.CustomerDetailId = d.CustomerDetailId
	inner join tblOrderNumber e on e.StoreCartId = @CartId
;
END

GO
/****** Object:  StoredProcedure [dbo].[spSaveChangesCustomerDetail]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spSaveChangesCustomerDetail]
	@password varchar(20),
	@FirstName varchar(150),
	@LastName varchar(150),
	@Address varchar(500),
	@StateId decimal(18,0),
	@Phone varchar(20),
	@Email varchar(200)
	AS
BEGIN
	insert into tblCustomerDetail(password,
	FirstName,
	LastName,
	Address,
	StateId,
	Phone,
	Email) values(@password,
	@FirstName,
	@LastName,
	@Address,
	@StateId,
	@Phone,
	@Email);	
END

GO
/****** Object:  StoredProcedure [dbo].[spSaveChangesFoodGroup]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spSaveChangesFoodGroup] 
	@FoodName varchar(150),
	@FoodGroupId decimal(18,0)
	AS
BEGIN
	update tblFoodGroup set FoodGroupName=@FoodName where FoodGroupId =@FoodGroupId;
END

GO
/****** Object:  StoredProcedure [dbo].[spSaveChangesFoodItem]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spSaveChangesFoodItem] 
	@FoodItemId decimal(18,0),
	@FoodName varchar(500),
	@FoodGroupId decimal(18,0),
	@FoodCost decimal(18,0),
	@FoodWeightTypeId decimal(18,0),
	@QuantityAvailable int,
	@SellerId decimal(18,0),
	@SubFoodGroupId decimal(18,0),
	@FoodPicture varchar(300),
	@BuyingPrice decimal(18,0)
	AS
BEGIN
update tblFoodItem Set FoodName= @FoodName ,FoodGroupId =@FoodGroupId,
	FoodCost=@FoodCost, FoodWeightTypeId=@FoodWeightTypeId, QuantityAvailable=@QuantityAvailable,
	SellerId=@SellerId, SubFoodGroupId=@SubFoodGroupId, FoodPicture=@FoodPicture, BuyingPrice= @BuyingPrice
	where FoodItemId=@FoodItemId
END

GO
/****** Object:  StoredProcedure [dbo].[spSaveChangesFoodWeightType]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spSaveChangesFoodWeightType] 
	@FoodName varchar(150),
	@FoodGroupId decimal(18,0)
	AS
BEGIN
	update tblFoodWeightType set FoodWeightTypeName = @FoodName where FoodWeightTypeId =@FoodGroupId;
END

GO
/****** Object:  StoredProcedure [dbo].[spSaveChangesSellerDetail]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spSaveChangesSellerDetail] 
	@SellerName varchar(150),
	@SellerId decimal(18,0),
	@SellerState varchar(50),
    @SellerAddress varchar(500),
    @SellerPhoneNumber varchar(15),
    @SellerEmail varchar(50),
    @SellerAccountNumber varchar(20),
    @BankId decimal(18,0),
    @SellerAccountName varchar(200)
	AS
BEGIN
	update tblSellerDetails set SellerName = @SellerName, SellerState= @SellerState,
    SellerAddress=@SellerAddress,
    SellerPhoneNumber=@SellerPhoneNumber,
    SellerEmail=@SellerEmail,
    SellerAccountNumber=@SellerAccountNumber,
    BankId=@BankId,
    SellerAccountName=@SellerAccountName where SellerId =@SellerId; 
END

GO
/****** Object:  StoredProcedure [dbo].[spSaveChangesSubFoodGroup]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spSaveChangesSubFoodGroup] 
	@FoodName varchar(150),
	@FoodGroupId decimal(18,0),
	@GroupId decimal(18,0)
	AS
BEGIN
	update tblSubFoodGroup set SubFoodGroupName=@FoodName, FoodGroupId= @GroupId where SubFoodGroupId =@FoodGroupId;
END

GO
/****** Object:  StoredProcedure [dbo].[spUniqueEmail]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spUniqueEmail]
	@email varchar(200)
AS
BEGIN
	select (LastName + ' ' + FirstName ) as CustomerName from tblCustomerDetail where upper(Email) = upper(@email);
END

GO
/****** Object:  StoredProcedure [dbo].[spUpdateLoginDetailWithCurrentUserName]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spUpdateLoginDetailWithCurrentUserName]
	@StoreCartId varchar(150),
	@UserName varchar(150)
	AS
BEGIN

update tblUserProfile set UserName = @UserName where StoreCartId=@StoreCartId;
END

GO
/****** Object:  Table [dbo].[tblAdminLogon]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblAdminLogon](
	[AdminEmail] [varchar](250) NULL,
	[LoginEmail] [varchar](250) NULL,
	[LoginPwd] [varchar](250) NULL,
	[TPCondition] [int] NULL,
	[MaximumTP] [decimal](18, 2) NULL,
	[MinimumTP] [decimal](18, 2) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblBankDetails]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblBankDetails](
	[BankId] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[BankName] [varchar](250) NULL,
 CONSTRAINT [PK_tblBankDetails] PRIMARY KEY CLUSTERED 
(
	[BankId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblContactUs]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblContactUs](
	[ContactUsId] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[EnquiryDate] [smalldatetime] NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[Email] [varchar](150) NULL,
	[Comment] [varchar](500) NULL,
 CONSTRAINT [PK_tblContactUs] PRIMARY KEY CLUSTERED 
(
	[ContactUsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCustomerDetail]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCustomerDetail](
	[Username] [varchar](150) NULL,
	[password] [varchar](20) NULL,
	[FirstName] [varchar](150) NULL,
	[LastName] [varchar](150) NULL,
	[Address] [varchar](500) NULL,
	[StateId] [decimal](18, 0) NOT NULL,
	[Phone] [varchar](15) NULL,
	[Email] [varchar](150) NULL,
	[DateCreated] [smalldatetime] NULL,
	[CustomerDetailId] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[Total] [decimal](18, 0) NULL,
 CONSTRAINT [PK_tblCustomerDetail] PRIMARY KEY CLUSTERED 
(
	[CustomerDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCustomerOrderDetail]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCustomerOrderDetail](
	[StoreCartId] [varchar](500) NULL,
	[CustomerOrderDetailId] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[FoodItemId] [decimal](18, 0) NULL,
	[Quantity] [int] NULL,
	[UnitPrice] [decimal](18, 0) NULL,
	[CustomerDetailId] [decimal](18, 0) NULL,
	[OrderDate] [smalldatetime] NULL,
	[SellerFeePaid] [decimal](18, 2) NULL,
 CONSTRAINT [PK_tblCustomerOrderDetail] PRIMARY KEY CLUSTERED 
(
	[CustomerOrderDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblFoodGroup]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblFoodGroup](
	[FoodGroupId] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[FoodGroupName] [varchar](250) NULL,
 CONSTRAINT [PK_tblFoodGroup] PRIMARY KEY CLUSTERED 
(
	[FoodGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblFoodItem]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblFoodItem](
	[FoodItemId] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[FoodName] [varchar](500) NULL,
	[SubFoodGroupId] [decimal](18, 0) NULL,
	[FoodCost] [decimal](18, 2) NULL,
	[BuyingPrice] [decimal](18, 2) NULL,
	[SuleimanWholeSalePrice] [decimal](18, 2) NULL,
	[MarketSellingPrice] [decimal](18, 2) NULL,
	[QuantityAvailable] [int] NULL,
	[FoodPicture] [nvarchar](100) NULL,
	[AlternateText] [nvarchar](100) NULL,
	[FoodGroupId] [decimal](18, 0) NULL,
	[FoodWeightTypeId] [decimal](18, 0) NULL,
	[SellerId] [decimal](18, 0) NULL,
 CONSTRAINT [PK_tblFoodItem] PRIMARY KEY CLUSTERED 
(
	[FoodItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblFoodWeightType]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblFoodWeightType](
	[FoodWeightTypeId] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[FoodWeightTypeName] [varchar](100) NULL,
 CONSTRAINT [PK_tblFoodWeightType] PRIMARY KEY CLUSTERED 
(
	[FoodWeightTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblOrderNumber]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblOrderNumber](
	[StoreCartId] [varchar](500) NULL,
	[OrderNumberId] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](150) NULL,
	[DateCreated] [smalldatetime] NULL,
 CONSTRAINT [PK_tblOrderNumber] PRIMARY KEY CLUSTERED 
(
	[OrderNumberId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblSellerDetails]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblSellerDetails](
	[SellerId] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[SellerName] [varchar](250) NULL,
	[SellerState] [varchar](50) NULL,
	[SellerAddress] [varchar](500) NULL,
	[SellerPhoneNumber] [varchar](15) NULL,
	[SellerEmail] [varchar](50) NULL,
	[SellerAccountNumber] [varchar](13) NULL,
	[BankId] [decimal](18, 0) NULL,
	[SellerAccountName] [varchar](250) NULL,
	[DateJoined] [smalldatetime] NULL,
 CONSTRAINT [PK_tblSellerDetails] PRIMARY KEY CLUSTERED 
(
	[SellerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblSellerFee]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblSellerFee](
	[Fee] [decimal](18, 2) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblState]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblState](
	[StateName] [varchar](100) NULL,
	[StateId] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_State] PRIMARY KEY CLUSTERED 
(
	[StateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblStoreCart]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblStoreCart](
	[StoreCartId] [varchar](500) NULL,
	[Count] [int] NULL,
	[DateCreated] [smalldatetime] NULL,
	[RecordId] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[FoodItemId] [decimal](18, 0) NULL,
	[UserName] [varchar](100) NULL,
 CONSTRAINT [PK_tblStoreCart] PRIMARY KEY CLUSTERED 
(
	[RecordId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblSubFoodGroup]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblSubFoodGroup](
	[SubFoodGroupId] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[SubFoodGroupName] [varchar](150) NULL,
	[FoodGroupId] [decimal](18, 0) NULL,
 CONSTRAINT [PK_tblSubFoodGroup] PRIMARY KEY CLUSTERED 
(
	[SubFoodGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblUserProfile]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblUserProfile](
	[UserId] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](50) NULL,
	[StoreCartId] [varchar](500) NULL,
	[DateCreated] [smalldatetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [NT AUTHORITY\SYSTEM].[UserProfile]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NT AUTHORITY\SYSTEM].[UserProfile](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](56) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [NT AUTHORITY\SYSTEM].[webpages_Membership]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NT AUTHORITY\SYSTEM].[webpages_Membership](
	[UserId] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[ConfirmationToken] [nvarchar](128) NULL,
	[IsConfirmed] [bit] NULL,
	[LastPasswordFailureDate] [datetime] NULL,
	[PasswordFailuresSinceLastSuccess] [int] NOT NULL,
	[Password] [nvarchar](128) NOT NULL,
	[PasswordChangedDate] [datetime] NULL,
	[PasswordSalt] [nvarchar](128) NOT NULL,
	[PasswordVerificationToken] [nvarchar](128) NULL,
	[PasswordVerificationTokenExpirationDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [NT AUTHORITY\SYSTEM].[webpages_OAuthMembership]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NT AUTHORITY\SYSTEM].[webpages_OAuthMembership](
	[Provider] [nvarchar](30) NOT NULL,
	[ProviderUserId] [nvarchar](100) NOT NULL,
	[UserId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Provider] ASC,
	[ProviderUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [NT AUTHORITY\SYSTEM].[webpages_Roles]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NT AUTHORITY\SYSTEM].[webpages_Roles](
	[RoleId] [int] IDENTITY(1,1) NOT NULL,
	[RoleName] [nvarchar](256) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [NT AUTHORITY\SYSTEM].[webpages_UsersInRoles]    Script Date: 25/10/2017 11:46:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NT AUTHORITY\SYSTEM].[webpages_UsersInRoles](
	[UserId] [int] NOT NULL,
	[RoleId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
INSERT [dbo].[tblAdminLogon] ([AdminEmail], [LoginEmail], [LoginPwd], [TPCondition], [MaximumTP], [MinimumTP]) VALUES (N'contactus@quickysale.com', N'contactus@quickysale.com', N'Asd123!@#', 2, CAST(1000.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)))
SET IDENTITY_INSERT [dbo].[tblBankDetails] ON 

INSERT [dbo].[tblBankDetails] ([BankId], [BankName]) VALUES (CAST(1 AS Decimal(18, 0)), N'Diamond Bank')
INSERT [dbo].[tblBankDetails] ([BankId], [BankName]) VALUES (CAST(2 AS Decimal(18, 0)), N'Zenith Bank')
INSERT [dbo].[tblBankDetails] ([BankId], [BankName]) VALUES (CAST(3 AS Decimal(18, 0)), N'UBA Bank')
INSERT [dbo].[tblBankDetails] ([BankId], [BankName]) VALUES (CAST(4 AS Decimal(18, 0)), N'Unity Bank')
INSERT [dbo].[tblBankDetails] ([BankId], [BankName]) VALUES (CAST(5 AS Decimal(18, 0)), N'Union Bank')
INSERT [dbo].[tblBankDetails] ([BankId], [BankName]) VALUES (CAST(6 AS Decimal(18, 0)), N'First Bank')
INSERT [dbo].[tblBankDetails] ([BankId], [BankName]) VALUES (CAST(7 AS Decimal(18, 0)), N'GT Bank')
INSERT [dbo].[tblBankDetails] ([BankId], [BankName]) VALUES (CAST(8 AS Decimal(18, 0)), N'Key Stone Bank')
SET IDENTITY_INSERT [dbo].[tblBankDetails] OFF
SET IDENTITY_INSERT [dbo].[tblContactUs] ON 

INSERT [dbo].[tblContactUs] ([ContactUsId], [EnquiryDate], [FirstName], [LastName], [Email], [Comment]) VALUES (CAST(1 AS Decimal(18, 0)), CAST(0xA547021B AS SmallDateTime), N'test', N'test', N'test@test.com', N'test')
INSERT [dbo].[tblContactUs] ([ContactUsId], [EnquiryDate], [FirstName], [LastName], [Email], [Comment]) VALUES (CAST(2 AS Decimal(18, 0)), CAST(0xA547021B AS SmallDateTime), N'test', N'test', N'test@test.com', N'test')
INSERT [dbo].[tblContactUs] ([ContactUsId], [EnquiryDate], [FirstName], [LastName], [Email], [Comment]) VALUES (CAST(3 AS Decimal(18, 0)), CAST(0xA5470235 AS SmallDateTime), N'test2', N'test2', N'test2@test.com', N'dsadasd')
INSERT [dbo].[tblContactUs] ([ContactUsId], [EnquiryDate], [FirstName], [LastName], [Email], [Comment]) VALUES (CAST(4 AS Decimal(18, 0)), CAST(0xA547023B AS SmallDateTime), N'test3', N'test3', N'test3@test.com', N'test3')
INSERT [dbo].[tblContactUs] ([ContactUsId], [EnquiryDate], [FirstName], [LastName], [Email], [Comment]) VALUES (CAST(5 AS Decimal(18, 0)), CAST(0xA547027B AS SmallDateTime), N'test4', N'tst3', N'test4@test.com', N'sdsdsf')
INSERT [dbo].[tblContactUs] ([ContactUsId], [EnquiryDate], [FirstName], [LastName], [Email], [Comment]) VALUES (CAST(6 AS Decimal(18, 0)), CAST(0xA54702BA AS SmallDateTime), N'test6', N'test6', N'test6@test6.cpm', N'test6')
INSERT [dbo].[tblContactUs] ([ContactUsId], [EnquiryDate], [FirstName], [LastName], [Email], [Comment]) VALUES (CAST(7 AS Decimal(18, 0)), CAST(0xA549034E AS SmallDateTime), N'test', N'test', N'rest@tresj.com', N'hbjhhjhj')
INSERT [dbo].[tblContactUs] ([ContactUsId], [EnquiryDate], [FirstName], [LastName], [Email], [Comment]) VALUES (CAST(8 AS Decimal(18, 0)), CAST(0xA549034F AS SmallDateTime), N'mobiletest', N'mobiletest', N'mobiletest@mobiletest.com', N'mobiletest')
INSERT [dbo].[tblContactUs] ([ContactUsId], [EnquiryDate], [FirstName], [LastName], [Email], [Comment]) VALUES (CAST(9 AS Decimal(18, 0)), CAST(0xA549046F AS SmallDateTime), N'tester45', N'tester45', N'tester45@tester45.com', N'tester45')
INSERT [dbo].[tblContactUs] ([ContactUsId], [EnquiryDate], [FirstName], [LastName], [Email], [Comment]) VALUES (CAST(10 AS Decimal(18, 0)), CAST(0xA5490481 AS SmallDateTime), N'tester4587', N'tester4587', N'tester4587@tester.com', N'tester4587')
INSERT [dbo].[tblContactUs] ([ContactUsId], [EnquiryDate], [FirstName], [LastName], [Email], [Comment]) VALUES (CAST(11 AS Decimal(18, 0)), CAST(0xA54D0453 AS SmallDateTime), N'dfdsfd', N'dsfdsfsdf', N'sadasd@dsfdsf.com', N'sfdsfdsfds')
INSERT [dbo].[tblContactUs] ([ContactUsId], [EnquiryDate], [FirstName], [LastName], [Email], [Comment]) VALUES (CAST(12 AS Decimal(18, 0)), CAST(0xA54D0454 AS SmallDateTime), N'jhgjgjg', N'khjkhjh', N'kjkjhkh@jkbghjghj.com', N'hgfhfghff')
INSERT [dbo].[tblContactUs] ([ContactUsId], [EnquiryDate], [FirstName], [LastName], [Email], [Comment]) VALUES (CAST(13 AS Decimal(18, 0)), CAST(0xA54D0459 AS SmallDateTime), N'dddddddddddd', N'dddddddddddd', N'dddddd@ddddddd.com', N'dddddddddddddddddddddddddddddddddddddddddddddddddddddd')
INSERT [dbo].[tblContactUs] ([ContactUsId], [EnquiryDate], [FirstName], [LastName], [Email], [Comment]) VALUES (CAST(14 AS Decimal(18, 0)), CAST(0xA55E0488 AS SmallDateTime), N'testmain', N'testmain', N'testmain@testmain.com', N'testmain')
INSERT [dbo].[tblContactUs] ([ContactUsId], [EnquiryDate], [FirstName], [LastName], [Email], [Comment]) VALUES (CAST(15 AS Decimal(18, 0)), CAST(0xA56003E0 AS SmallDateTime), N'TestMe', N'TestMe o', N'Testme@Testme.com', N'Testme o')
INSERT [dbo].[tblContactUs] ([ContactUsId], [EnquiryDate], [FirstName], [LastName], [Email], [Comment]) VALUES (CAST(16 AS Decimal(18, 0)), CAST(0xA56003E3 AS SmallDateTime), N'Tester', N'Tester', N'Tester@Tester.com', N'TesterTesterTesterTester')
INSERT [dbo].[tblContactUs] ([ContactUsId], [EnquiryDate], [FirstName], [LastName], [Email], [Comment]) VALUES (CAST(10014 AS Decimal(18, 0)), CAST(0xA66403F1 AS SmallDateTime), N'localtest', N'localtest', N'zimpik@yahoo.com', N'local test')
INSERT [dbo].[tblContactUs] ([ContactUsId], [EnquiryDate], [FirstName], [LastName], [Email], [Comment]) VALUES (CAST(10015 AS Decimal(18, 0)), CAST(0xA66403F1 AS SmallDateTime), N'localtest', N'localtest', N'none@none.com', N'local test')
SET IDENTITY_INSERT [dbo].[tblContactUs] OFF
SET IDENTITY_INSERT [dbo].[tblCustomerDetail] ON 

INSERT [dbo].[tblCustomerDetail] ([Username], [password], [FirstName], [LastName], [Address], [StateId], [Phone], [Email], [DateCreated], [CustomerDetailId], [Total]) VALUES (N'zimpik@yahoo.com', N'testpwd', N'Zimpi', N'Zimpi', N'Abuja', CAST(1 AS Decimal(18, 0)), N'08099664343', N'zimpik@yahoo.com', CAST(0xA54303B3 AS SmallDateTime), CAST(3 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)))
INSERT [dbo].[tblCustomerDetail] ([Username], [password], [FirstName], [LastName], [Address], [StateId], [Phone], [Email], [DateCreated], [CustomerDetailId], [Total]) VALUES (N'UmartaxUmartax@UmartaxUmartax.com', N'UmartaxUmartax', N'UmartaxUmartax', N'UmartaxUmartax', N'UmartaxUmartax', CAST(1 AS Decimal(18, 0)), N'33333333333', N'UmartaxUmartax@UmartaxUmartax.com', CAST(0xA5670492 AS SmallDateTime), CAST(20 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)))
INSERT [dbo].[tblCustomerDetail] ([Username], [password], [FirstName], [LastName], [Address], [StateId], [Phone], [Email], [DateCreated], [CustomerDetailId], [Total]) VALUES (N'textheragaintextheragain@textheragain.com', N'textheragain', N'textheragain', N'textheragain', N'textheragain', CAST(1 AS Decimal(18, 0)), N'22222222222', N'textheragaintextheragain@textheragain.com', CAST(0xA5670497 AS SmallDateTime), CAST(21 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)))
INSERT [dbo].[tblCustomerDetail] ([Username], [password], [FirstName], [LastName], [Address], [StateId], [Phone], [Email], [DateCreated], [CustomerDetailId], [Total]) VALUES (N'Shewhomustbeobeyed@Shewhomustbeobeyed.com', N'Shewhomustbeobeyed', N'Shewhomustbeobeyed', N'Shewhomustbeobeyed', N'Shewhomustbeobeyed', CAST(1 AS Decimal(18, 0)), N'22222222222', N'Shewhomustbeobeyed@Shewhomustbeobeyed.com', CAST(0xA56704E0 AS SmallDateTime), CAST(22 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)))
INSERT [dbo].[tblCustomerDetail] ([Username], [password], [FirstName], [LastName], [Address], [StateId], [Phone], [Email], [DateCreated], [CustomerDetailId], [Total]) VALUES (N'continuetester@continuetester.com', N'continuetester', N'continuetester', N'continuetester', N'continuetester', CAST(1 AS Decimal(18, 0)), N'22244444321', N'continuetester@continuetester.com', CAST(0xA5680225 AS SmallDateTime), CAST(23 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)))
SET IDENTITY_INSERT [dbo].[tblCustomerDetail] OFF
SET IDENTITY_INSERT [dbo].[tblCustomerOrderDetail] ON 

INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'875dec72-e261-4509-a3a5-20d6c13e2a04', CAST(10064 AS Decimal(18, 0)), CAST(89 AS Decimal(18, 0)), 1, CAST(1200 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5670444 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'875dec72-e261-4509-a3a5-20d6c13e2a04', CAST(10065 AS Decimal(18, 0)), CAST(24 AS Decimal(18, 0)), 1, CAST(4600 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5670444 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'875dec72-e261-4509-a3a5-20d6c13e2a04', CAST(10066 AS Decimal(18, 0)), CAST(68 AS Decimal(18, 0)), 1, CAST(150 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5670444 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'a06e6958-b70e-4b23-bdf4-010ef23f09f1', CAST(10067 AS Decimal(18, 0)), CAST(28 AS Decimal(18, 0)), 1, CAST(100 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA567044B AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'a06e6958-b70e-4b23-bdf4-010ef23f09f1', CAST(10068 AS Decimal(18, 0)), CAST(24 AS Decimal(18, 0)), 1, CAST(4600 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA567044B AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'a06e6958-b70e-4b23-bdf4-010ef23f09f1', CAST(10069 AS Decimal(18, 0)), CAST(68 AS Decimal(18, 0)), 1, CAST(150 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA567044B AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'bf5fcaf2-5312-4599-93d9-f789eeea1490', CAST(10070 AS Decimal(18, 0)), CAST(24 AS Decimal(18, 0)), 1, CAST(4600 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA567044C AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'bf5fcaf2-5312-4599-93d9-f789eeea1490', CAST(10071 AS Decimal(18, 0)), CAST(23 AS Decimal(18, 0)), 1, CAST(1900 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA567044C AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'bf5fcaf2-5312-4599-93d9-f789eeea1490', CAST(10072 AS Decimal(18, 0)), CAST(99 AS Decimal(18, 0)), 1, CAST(800 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA567044C AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'cfb766b8-5d3b-4dfa-8418-629478257322', CAST(10073 AS Decimal(18, 0)), CAST(68 AS Decimal(18, 0)), 1, CAST(150 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5670450 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'cfb766b8-5d3b-4dfa-8418-629478257322', CAST(10074 AS Decimal(18, 0)), CAST(44 AS Decimal(18, 0)), 1, CAST(400 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5670450 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'cfb766b8-5d3b-4dfa-8418-629478257322', CAST(10075 AS Decimal(18, 0)), CAST(49 AS Decimal(18, 0)), 1, CAST(150 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5670450 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'cfb766b8-5d3b-4dfa-8418-629478257322', CAST(10076 AS Decimal(18, 0)), CAST(50 AS Decimal(18, 0)), 1, CAST(500 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5670450 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'36155a4e-5133-413a-b5bc-76f65e405201', CAST(10077 AS Decimal(18, 0)), CAST(24 AS Decimal(18, 0)), 1, CAST(4600 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(0xA567045E AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'36155a4e-5133-413a-b5bc-76f65e405201', CAST(10078 AS Decimal(18, 0)), CAST(53 AS Decimal(18, 0)), 1, CAST(1000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(0xA567045E AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'0ca124a9-622b-4d43-97ba-74e8a9cbbcf7', CAST(10079 AS Decimal(18, 0)), CAST(52 AS Decimal(18, 0)), 1, CAST(1000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(0xA5670470 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'0ca124a9-622b-4d43-97ba-74e8a9cbbcf7', CAST(10080 AS Decimal(18, 0)), CAST(49 AS Decimal(18, 0)), 1, CAST(150 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(0xA5670470 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'0ca124a9-622b-4d43-97ba-74e8a9cbbcf7', CAST(10081 AS Decimal(18, 0)), CAST(51 AS Decimal(18, 0)), 1, CAST(500 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(0xA5670470 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'da8f120d-596c-44f4-af04-440c83159ea0', CAST(10082 AS Decimal(18, 0)), CAST(24 AS Decimal(18, 0)), 1, CAST(4600 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(0xA567047C AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'da8f120d-596c-44f4-af04-440c83159ea0', CAST(10083 AS Decimal(18, 0)), CAST(49 AS Decimal(18, 0)), 1, CAST(150 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(0xA567047C AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'977cd740-c7c2-4206-99be-005dcfee552f', CAST(10084 AS Decimal(18, 0)), CAST(68 AS Decimal(18, 0)), 1, CAST(150 AS Decimal(18, 0)), CAST(19 AS Decimal(18, 0)), CAST(0xA567048D AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'977cd740-c7c2-4206-99be-005dcfee552f', CAST(10085 AS Decimal(18, 0)), CAST(38 AS Decimal(18, 0)), 1, CAST(500 AS Decimal(18, 0)), CAST(19 AS Decimal(18, 0)), CAST(0xA567048D AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'977cd740-c7c2-4206-99be-005dcfee552f', CAST(10086 AS Decimal(18, 0)), CAST(43 AS Decimal(18, 0)), 1, CAST(400 AS Decimal(18, 0)), CAST(19 AS Decimal(18, 0)), CAST(0xA567048D AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'45b08119-965b-47fd-aeb3-50e02ddb22bd', CAST(10087 AS Decimal(18, 0)), CAST(28 AS Decimal(18, 0)), 1, CAST(100 AS Decimal(18, 0)), CAST(20 AS Decimal(18, 0)), CAST(0xA5670493 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'45b08119-965b-47fd-aeb3-50e02ddb22bd', CAST(10088 AS Decimal(18, 0)), CAST(59 AS Decimal(18, 0)), 1, CAST(200 AS Decimal(18, 0)), CAST(20 AS Decimal(18, 0)), CAST(0xA5670493 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'45b08119-965b-47fd-aeb3-50e02ddb22bd', CAST(10089 AS Decimal(18, 0)), CAST(55 AS Decimal(18, 0)), 1, CAST(300 AS Decimal(18, 0)), CAST(20 AS Decimal(18, 0)), CAST(0xA5670493 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'82ef20e2-0169-48a2-9f63-fadfbe35d290', CAST(10090 AS Decimal(18, 0)), CAST(40 AS Decimal(18, 0)), 1, CAST(100 AS Decimal(18, 0)), CAST(22 AS Decimal(18, 0)), CAST(0xA56704E0 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'82ef20e2-0169-48a2-9f63-fadfbe35d290', CAST(10091 AS Decimal(18, 0)), CAST(70 AS Decimal(18, 0)), 1, CAST(1000 AS Decimal(18, 0)), CAST(22 AS Decimal(18, 0)), CAST(0xA56704E0 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'82ef20e2-0169-48a2-9f63-fadfbe35d290', CAST(10092 AS Decimal(18, 0)), CAST(114 AS Decimal(18, 0)), 1, CAST(500 AS Decimal(18, 0)), CAST(22 AS Decimal(18, 0)), CAST(0xA56704E0 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'1d41dc63-6dc0-4b9f-aa35-14e786254979', CAST(10093 AS Decimal(18, 0)), CAST(38 AS Decimal(18, 0)), 1, CAST(500 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA568021B AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'1d41dc63-6dc0-4b9f-aa35-14e786254979', CAST(10094 AS Decimal(18, 0)), CAST(58 AS Decimal(18, 0)), 1, CAST(250 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA568021B AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'46bf8bb4-1f35-4b9a-b110-112dd3b280f9', CAST(10095 AS Decimal(18, 0)), CAST(38 AS Decimal(18, 0)), 1, CAST(500 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5680220 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'46bf8bb4-1f35-4b9a-b110-112dd3b280f9', CAST(10096 AS Decimal(18, 0)), CAST(58 AS Decimal(18, 0)), 1, CAST(250 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5680220 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'51aedaee-0954-46a3-8bba-7c3e2dd4f21a', CAST(10097 AS Decimal(18, 0)), CAST(89 AS Decimal(18, 0)), 1, CAST(1200 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5680222 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'51aedaee-0954-46a3-8bba-7c3e2dd4f21a', CAST(10098 AS Decimal(18, 0)), CAST(33 AS Decimal(18, 0)), 1, CAST(0 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5680222 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'51aedaee-0954-46a3-8bba-7c3e2dd4f21a', CAST(10099 AS Decimal(18, 0)), CAST(33 AS Decimal(18, 0)), 1, CAST(0 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5680230 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'877f527a-a6cf-4947-acb8-7e617cbdba43', CAST(10100 AS Decimal(18, 0)), CAST(28 AS Decimal(18, 0)), 1, CAST(100 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5680546 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'877f527a-a6cf-4947-acb8-7e617cbdba43', CAST(10101 AS Decimal(18, 0)), CAST(38 AS Decimal(18, 0)), 1, CAST(500 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5680546 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'877f527a-a6cf-4947-acb8-7e617cbdba43', CAST(10102 AS Decimal(18, 0)), CAST(58 AS Decimal(18, 0)), 1, CAST(250 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5680546 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'89c5a601-88b2-4c9e-857a-35e2ac83450e', CAST(10103 AS Decimal(18, 0)), CAST(38 AS Decimal(18, 0)), 1, CAST(500 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5690210 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'e34221b8-1983-4344-b39d-0764d465d540', CAST(10104 AS Decimal(18, 0)), CAST(58 AS Decimal(18, 0)), 1, CAST(250 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5690244 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'bc6b2468-bbcf-4021-88a6-90ae537a3d71', CAST(10105 AS Decimal(18, 0)), CAST(58 AS Decimal(18, 0)), 1, CAST(250 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA569031A AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'bc6b2468-bbcf-4021-88a6-90ae537a3d71', CAST(10106 AS Decimal(18, 0)), CAST(59 AS Decimal(18, 0)), 1, CAST(200 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA569031A AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'bc6b2468-bbcf-4021-88a6-90ae537a3d71', CAST(10107 AS Decimal(18, 0)), CAST(54 AS Decimal(18, 0)), 1, CAST(350 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA569031A AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'359d16a9-f17b-4eb4-9248-c3d0b0169de1', CAST(10108 AS Decimal(18, 0)), CAST(58 AS Decimal(18, 0)), 1, CAST(250 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA569034A AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'359d16a9-f17b-4eb4-9248-c3d0b0169de1', CAST(10109 AS Decimal(18, 0)), CAST(38 AS Decimal(18, 0)), 1, CAST(500 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA569034A AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'359d16a9-f17b-4eb4-9248-c3d0b0169de1', CAST(10110 AS Decimal(18, 0)), CAST(116 AS Decimal(18, 0)), 1, CAST(300 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA569034A AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'19b49871-e99e-40a4-8520-1512ab35cac5', CAST(10111 AS Decimal(18, 0)), CAST(58 AS Decimal(18, 0)), 1, CAST(250 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA569034F AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'19b49871-e99e-40a4-8520-1512ab35cac5', CAST(10112 AS Decimal(18, 0)), CAST(38 AS Decimal(18, 0)), 1, CAST(500 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA569034F AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'03cabb75-7673-4408-87e2-1902a82a5ee3', CAST(10113 AS Decimal(18, 0)), CAST(58 AS Decimal(18, 0)), 1, CAST(250 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5690386 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'03cabb75-7673-4408-87e2-1902a82a5ee3', CAST(10114 AS Decimal(18, 0)), CAST(38 AS Decimal(18, 0)), 1, CAST(500 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5690386 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'2ee67f81-9481-407c-bf12-498a07c4fa43', CAST(10115 AS Decimal(18, 0)), CAST(38 AS Decimal(18, 0)), 1, CAST(500 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA56903A7 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'2ee67f81-9481-407c-bf12-498a07c4fa43', CAST(10116 AS Decimal(18, 0)), CAST(116 AS Decimal(18, 0)), 1, CAST(300 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA56903A7 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'4efe1c9c-1c46-4553-82d2-3a51bab6747f', CAST(10117 AS Decimal(18, 0)), CAST(38 AS Decimal(18, 0)), 1, CAST(500 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA56903BC AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'9e86ad1c-a9c3-41df-b043-a39ffab20ec2', CAST(10118 AS Decimal(18, 0)), CAST(38 AS Decimal(18, 0)), 1, CAST(500 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA56903C1 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'998dc515-0c07-4949-b559-a51dcfaf903e', CAST(10119 AS Decimal(18, 0)), CAST(38 AS Decimal(18, 0)), 1, CAST(500 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA56903C9 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'3264a445-20ca-446d-9685-5a5e2c510853', CAST(10120 AS Decimal(18, 0)), CAST(58 AS Decimal(18, 0)), 1, CAST(250 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA56903EC AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'e800d4f6-4610-45c5-af18-c13c9e158c66', CAST(10121 AS Decimal(18, 0)), CAST(58 AS Decimal(18, 0)), 1, CAST(250 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA56903EF AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'94042ba2-452f-4940-870c-3d138a90ae9b', CAST(10122 AS Decimal(18, 0)), CAST(58 AS Decimal(18, 0)), 1, CAST(250 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA56903F9 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'6cfd843a-5522-444d-afe0-a80e8969b6a1', CAST(10123 AS Decimal(18, 0)), CAST(58 AS Decimal(18, 0)), 1, CAST(250 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA569040D AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'5970d356-0c43-47c3-9344-a0abfd000df6', CAST(10124 AS Decimal(18, 0)), CAST(58 AS Decimal(18, 0)), 1, CAST(250 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5690410 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'30f7871c-18a0-43bd-91a7-90b1652fc56a', CAST(10125 AS Decimal(18, 0)), CAST(58 AS Decimal(18, 0)), 1, CAST(250 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5690419 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'fe3ea306-a083-4c33-b2a2-3806e2eb7246', CAST(10126 AS Decimal(18, 0)), CAST(68 AS Decimal(18, 0)), 1, CAST(150 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5690424 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'51edb225-b2ab-42ec-a5c7-65ed5707b293', CAST(10127 AS Decimal(18, 0)), CAST(24 AS Decimal(18, 0)), 1, CAST(4600 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5690441 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'51edb225-b2ab-42ec-a5c7-65ed5707b293', CAST(10128 AS Decimal(18, 0)), CAST(68 AS Decimal(18, 0)), 1, CAST(150 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5690441 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'51edb225-b2ab-42ec-a5c7-65ed5707b293', CAST(10129 AS Decimal(18, 0)), CAST(58 AS Decimal(18, 0)), 1, CAST(250 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5690441 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'51edb225-b2ab-42ec-a5c7-65ed5707b293', CAST(10130 AS Decimal(18, 0)), CAST(41 AS Decimal(18, 0)), 1, CAST(300 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5690441 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'72abb869-47f1-4f89-b7f4-1438789c0ae5', CAST(10131 AS Decimal(18, 0)), CAST(58 AS Decimal(18, 0)), 1, CAST(250 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA569045E AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'72abb869-47f1-4f89-b7f4-1438789c0ae5', CAST(10132 AS Decimal(18, 0)), CAST(116 AS Decimal(18, 0)), 1, CAST(300 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA569045E AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'64b171cd-febf-4f73-977e-0c3cda46b74a', CAST(10133 AS Decimal(18, 0)), CAST(38 AS Decimal(18, 0)), 1, CAST(500 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA569046D AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'a4157a4d-f44d-484a-8275-844be713293a', CAST(10134 AS Decimal(18, 0)), CAST(38 AS Decimal(18, 0)), 1, CAST(500 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5690476 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'7ee5bc58-bda9-4782-be0d-177fc363e5b8', CAST(10135 AS Decimal(18, 0)), CAST(24 AS Decimal(18, 0)), 1, CAST(4600 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5690507 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'7ee5bc58-bda9-4782-be0d-177fc363e5b8', CAST(10136 AS Decimal(18, 0)), CAST(58 AS Decimal(18, 0)), 1, CAST(250 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5690507 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'7ee5bc58-bda9-4782-be0d-177fc363e5b8', CAST(10137 AS Decimal(18, 0)), CAST(37 AS Decimal(18, 0)), 1, CAST(150 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5690507 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'7ee5bc58-bda9-4782-be0d-177fc363e5b8', CAST(10138 AS Decimal(18, 0)), CAST(72 AS Decimal(18, 0)), 1, CAST(8000 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5690507 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'9f1295b7-1bb7-47c7-bf1c-6fff17f037ba', CAST(10139 AS Decimal(18, 0)), CAST(24 AS Decimal(18, 0)), 1, CAST(4600 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5690510 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'9f1295b7-1bb7-47c7-bf1c-6fff17f037ba', CAST(10140 AS Decimal(18, 0)), CAST(116 AS Decimal(18, 0)), 1, CAST(300 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5690510 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'9f1295b7-1bb7-47c7-bf1c-6fff17f037ba', CAST(10141 AS Decimal(18, 0)), CAST(57 AS Decimal(18, 0)), 1, CAST(150 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5690510 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'9f1295b7-1bb7-47c7-bf1c-6fff17f037ba', CAST(10142 AS Decimal(18, 0)), CAST(44 AS Decimal(18, 0)), 1, CAST(400 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5690510 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'9f1295b7-1bb7-47c7-bf1c-6fff17f037ba', CAST(10143 AS Decimal(18, 0)), CAST(40 AS Decimal(18, 0)), 1, CAST(100 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5690510 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'aaae5e04-9b77-4902-b54a-6cc990276130', CAST(10144 AS Decimal(18, 0)), CAST(58 AS Decimal(18, 0)), 1, CAST(250 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5690527 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'aaae5e04-9b77-4902-b54a-6cc990276130', CAST(10145 AS Decimal(18, 0)), CAST(45 AS Decimal(18, 0)), 1, CAST(100 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5690527 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'aaae5e04-9b77-4902-b54a-6cc990276130', CAST(10146 AS Decimal(18, 0)), CAST(28 AS Decimal(18, 0)), 1, CAST(100 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5690527 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'aaae5e04-9b77-4902-b54a-6cc990276130', CAST(10147 AS Decimal(18, 0)), CAST(82 AS Decimal(18, 0)), 1, CAST(300 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5690527 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'aaae5e04-9b77-4902-b54a-6cc990276130', CAST(10148 AS Decimal(18, 0)), CAST(79 AS Decimal(18, 0)), 1, CAST(100 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA5690527 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'e95dc5e2-90f9-404f-a973-789aa3f88a33', CAST(10149 AS Decimal(18, 0)), CAST(38 AS Decimal(18, 0)), 1, CAST(500 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA56A0224 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'e95dc5e2-90f9-404f-a973-789aa3f88a33', CAST(10150 AS Decimal(18, 0)), CAST(67 AS Decimal(18, 0)), 1, CAST(200 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA56A0224 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'e95dc5e2-90f9-404f-a973-789aa3f88a33', CAST(10151 AS Decimal(18, 0)), CAST(56 AS Decimal(18, 0)), 1, CAST(300 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA56A0224 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'e95dc5e2-90f9-404f-a973-789aa3f88a33', CAST(10152 AS Decimal(18, 0)), CAST(67 AS Decimal(18, 0)), 1, CAST(200 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA56A0228 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'e95dc5e2-90f9-404f-a973-789aa3f88a33', CAST(10153 AS Decimal(18, 0)), CAST(38 AS Decimal(18, 0)), 1, CAST(500 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA56A0228 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'e95dc5e2-90f9-404f-a973-789aa3f88a33', CAST(10154 AS Decimal(18, 0)), CAST(44 AS Decimal(18, 0)), 1, CAST(400 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA56A0228 AS SmallDateTime), NULL)
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'e5e69d14-3d54-4274-be30-fb32eefd9cf0', CAST(10155 AS Decimal(18, 0)), CAST(58 AS Decimal(18, 0)), 1, CAST(250 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA59B02D4 AS SmallDateTime), CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'e5e69d14-3d54-4274-be30-fb32eefd9cf0', CAST(10156 AS Decimal(18, 0)), CAST(57 AS Decimal(18, 0)), 1, CAST(150 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA59B02D4 AS SmallDateTime), CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'e5e69d14-3d54-4274-be30-fb32eefd9cf0', CAST(10157 AS Decimal(18, 0)), CAST(111 AS Decimal(18, 0)), 1, CAST(1000 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA59B02D4 AS SmallDateTime), CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'e5e69d14-3d54-4274-be30-fb32eefd9cf0', CAST(10158 AS Decimal(18, 0)), CAST(117 AS Decimal(18, 0)), 1, CAST(250 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA59B02D4 AS SmallDateTime), CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'e5e69d14-3d54-4274-be30-fb32eefd9cf0', CAST(10159 AS Decimal(18, 0)), CAST(69 AS Decimal(18, 0)), 1, CAST(1000 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA59B02D4 AS SmallDateTime), CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'e5e69d14-3d54-4274-be30-fb32eefd9cf0', CAST(10160 AS Decimal(18, 0)), CAST(103 AS Decimal(18, 0)), 1, CAST(200 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA59B02D4 AS SmallDateTime), CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'14e2ef8b-62e6-405d-92ff-7c168047bcf5', CAST(10161 AS Decimal(18, 0)), CAST(38 AS Decimal(18, 0)), 1, CAST(500 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA59B02E1 AS SmallDateTime), CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'14e2ef8b-62e6-405d-92ff-7c168047bcf5', CAST(10162 AS Decimal(18, 0)), CAST(69 AS Decimal(18, 0)), 1, CAST(1000 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA59B02E1 AS SmallDateTime), CAST(10.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'fe4b8f1f-c28a-4f22-baf4-0be6f18466ff', CAST(10163 AS Decimal(18, 0)), CAST(116 AS Decimal(18, 0)), 1, CAST(300 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA59B02EE AS SmallDateTime), CAST(3.00 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'fe4b8f1f-c28a-4f22-baf4-0be6f18466ff', CAST(10164 AS Decimal(18, 0)), CAST(111 AS Decimal(18, 0)), 1, CAST(1000 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA59B02EE AS SmallDateTime), CAST(10.00 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'2ef86d9b-ba76-41f2-b9ed-c4e946bc6257', CAST(10165 AS Decimal(18, 0)), CAST(68 AS Decimal(18, 0)), 1, CAST(150 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA59B0331 AS SmallDateTime), CAST(0.75 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'2ef86d9b-ba76-41f2-b9ed-c4e946bc6257', CAST(10166 AS Decimal(18, 0)), CAST(58 AS Decimal(18, 0)), 1, CAST(250 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA59B0331 AS SmallDateTime), CAST(1.25 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'2ef86d9b-ba76-41f2-b9ed-c4e946bc6257', CAST(10167 AS Decimal(18, 0)), CAST(111 AS Decimal(18, 0)), 1, CAST(1000 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA59B0331 AS SmallDateTime), CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'97806656-029e-48cc-8178-375c7463b24d', CAST(20155 AS Decimal(18, 0)), CAST(58 AS Decimal(18, 0)), 2, CAST(250 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA661039D AS SmallDateTime), CAST(2.50 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'97806656-029e-48cc-8178-375c7463b24d', CAST(20156 AS Decimal(18, 0)), CAST(59 AS Decimal(18, 0)), 1, CAST(200 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA661039D AS SmallDateTime), CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'97806656-029e-48cc-8178-375c7463b24d', CAST(20157 AS Decimal(18, 0)), CAST(28 AS Decimal(18, 0)), 4, CAST(100 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA661039D AS SmallDateTime), CAST(2.00 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'97806656-029e-48cc-8178-375c7463b24d', CAST(20158 AS Decimal(18, 0)), CAST(53 AS Decimal(18, 0)), 1, CAST(1000 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA661039D AS SmallDateTime), CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'0cd3e521-254e-4141-9170-6b9709294803', CAST(20159 AS Decimal(18, 0)), CAST(28 AS Decimal(18, 0)), 1, CAST(100 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA66103B4 AS SmallDateTime), CAST(0.50 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'0cd3e521-254e-4141-9170-6b9709294803', CAST(20160 AS Decimal(18, 0)), CAST(25 AS Decimal(18, 0)), 2, CAST(8100 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA66103B4 AS SmallDateTime), CAST(81.00 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'0cd3e521-254e-4141-9170-6b9709294803', CAST(20161 AS Decimal(18, 0)), CAST(67 AS Decimal(18, 0)), 1, CAST(200 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA66103B4 AS SmallDateTime), CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'90493a47-3157-42a6-9b27-639181f8188c', CAST(20162 AS Decimal(18, 0)), CAST(24 AS Decimal(18, 0)), 1, CAST(4600 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA66103BC AS SmallDateTime), CAST(23.00 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'90493a47-3157-42a6-9b27-639181f8188c', CAST(20163 AS Decimal(18, 0)), CAST(76 AS Decimal(18, 0)), 3, CAST(3400 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA66103BC AS SmallDateTime), CAST(51.00 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'04ebfe0c-e0f7-4d55-b7d9-e6dc9b9a50bf', CAST(20164 AS Decimal(18, 0)), CAST(25 AS Decimal(18, 0)), 1, CAST(8100 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA66103C6 AS SmallDateTime), CAST(40.50 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'04ebfe0c-e0f7-4d55-b7d9-e6dc9b9a50bf', CAST(20165 AS Decimal(18, 0)), CAST(58 AS Decimal(18, 0)), 1, CAST(250 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA66103C6 AS SmallDateTime), CAST(1.25 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'04ebfe0c-e0f7-4d55-b7d9-e6dc9b9a50bf', CAST(20166 AS Decimal(18, 0)), CAST(114 AS Decimal(18, 0)), 1, CAST(500 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA66103C6 AS SmallDateTime), CAST(2.50 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'a80775fe-7096-463c-9a2c-ab3dc126f415', CAST(20167 AS Decimal(18, 0)), CAST(25 AS Decimal(18, 0)), 2, CAST(8100 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA66103D8 AS SmallDateTime), CAST(81.00 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'd4cf0bc7-5107-49b0-95ad-c727c604aef0', CAST(20168 AS Decimal(18, 0)), CAST(23 AS Decimal(18, 0)), 3, CAST(1900 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA66103E9 AS SmallDateTime), CAST(28.50 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'a7d62f15-19d3-450b-8494-989b5550fc1c', CAST(20169 AS Decimal(18, 0)), CAST(26 AS Decimal(18, 0)), 4, CAST(1700 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA66403F4 AS SmallDateTime), CAST(34.00 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'b32a4b90-c4d6-40b7-8152-2fb4e73566e1', CAST(20170 AS Decimal(18, 0)), CAST(86 AS Decimal(18, 0)), 1, CAST(1700 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA664040F AS SmallDateTime), CAST(8.50 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'70c22b85-25e8-4c2c-8689-354f26d9d800', CAST(20171 AS Decimal(18, 0)), CAST(87 AS Decimal(18, 0)), 1, CAST(1300 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA6640414 AS SmallDateTime), CAST(6.50 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'8dae8156-6a57-4fa7-8cd7-9948ac4ae371', CAST(20172 AS Decimal(18, 0)), CAST(25 AS Decimal(18, 0)), 1, CAST(8100 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA664041A AS SmallDateTime), CAST(40.50 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'0efb805a-cf0b-4fb7-b122-ac1d3e9a839d', CAST(20173 AS Decimal(18, 0)), CAST(87 AS Decimal(18, 0)), 1, CAST(1300 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA6640425 AS SmallDateTime), CAST(6.50 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'ad5e97aa-a1f4-4a30-9e25-b0d90113a4c8', CAST(20174 AS Decimal(18, 0)), CAST(86 AS Decimal(18, 0)), 1, CAST(1700 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA6640474 AS SmallDateTime), CAST(8.50 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'e6e081ab-a0a1-4e86-a7b8-f4f625b3b174', CAST(20175 AS Decimal(18, 0)), CAST(86 AS Decimal(18, 0)), 1, CAST(1700 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA664047D AS SmallDateTime), CAST(8.50 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'256d79a3-b545-4ed9-936b-24c349955b84', CAST(20176 AS Decimal(18, 0)), CAST(87 AS Decimal(18, 0)), 1, CAST(1300 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA6640488 AS SmallDateTime), CAST(6.50 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'8271b38e-99b3-4132-910d-a97b1a1beb4f', CAST(20177 AS Decimal(18, 0)), CAST(34 AS Decimal(18, 0)), 1, CAST(1100 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA66404AB AS SmallDateTime), CAST(5.50 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'8271b38e-99b3-4132-910d-a97b1a1beb4f', CAST(20178 AS Decimal(18, 0)), CAST(25 AS Decimal(18, 0)), 1, CAST(8100 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA66404AB AS SmallDateTime), CAST(40.50 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'8271b38e-99b3-4132-910d-a97b1a1beb4f', CAST(20179 AS Decimal(18, 0)), CAST(20 AS Decimal(18, 0)), 1, CAST(4900 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA66404AB AS SmallDateTime), CAST(24.50 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'8271b38e-99b3-4132-910d-a97b1a1beb4f', CAST(20180 AS Decimal(18, 0)), CAST(4 AS Decimal(18, 0)), 1, CAST(4000 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA66404AB AS SmallDateTime), CAST(20.00 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'a0f12a7c-ca42-46ea-a29a-eb7e2319e43c', CAST(20181 AS Decimal(18, 0)), CAST(120 AS Decimal(18, 0)), 1, CAST(400 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA66404D1 AS SmallDateTime), CAST(2.00 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'a0f12a7c-ca42-46ea-a29a-eb7e2319e43c', CAST(20182 AS Decimal(18, 0)), CAST(107 AS Decimal(18, 0)), 1, CAST(200 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA66404D1 AS SmallDateTime), CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'a0f12a7c-ca42-46ea-a29a-eb7e2319e43c', CAST(20183 AS Decimal(18, 0)), CAST(83 AS Decimal(18, 0)), 1, CAST(900 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA66404D1 AS SmallDateTime), CAST(4.50 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'a0f12a7c-ca42-46ea-a29a-eb7e2319e43c', CAST(20184 AS Decimal(18, 0)), CAST(80 AS Decimal(18, 0)), 1, CAST(370 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA66404D1 AS SmallDateTime), CAST(1.85 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'a0f12a7c-ca42-46ea-a29a-eb7e2319e43c', CAST(20185 AS Decimal(18, 0)), CAST(28 AS Decimal(18, 0)), 5, CAST(100 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA66404D1 AS SmallDateTime), CAST(2.50 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'a0f12a7c-ca42-46ea-a29a-eb7e2319e43c', CAST(20186 AS Decimal(18, 0)), CAST(22 AS Decimal(18, 0)), 1, CAST(1450 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA66404D1 AS SmallDateTime), CAST(7.25 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'32909afe-735e-42b4-8909-8a2ced94d101', CAST(20187 AS Decimal(18, 0)), CAST(25 AS Decimal(18, 0)), 1, CAST(8100 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA664050A AS SmallDateTime), CAST(40.50 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'c0a8a20f-136e-4e05-951d-cd4d4a0a063c', CAST(20188 AS Decimal(18, 0)), CAST(23 AS Decimal(18, 0)), 1, CAST(1900 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA6760543 AS SmallDateTime), CAST(9.50 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'c0a8a20f-136e-4e05-951d-cd4d4a0a063c', CAST(20189 AS Decimal(18, 0)), CAST(28 AS Decimal(18, 0)), 1, CAST(100 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA6760543 AS SmallDateTime), CAST(0.50 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'c0a8a20f-136e-4e05-951d-cd4d4a0a063c', CAST(20190 AS Decimal(18, 0)), CAST(26 AS Decimal(18, 0)), 1, CAST(1700 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA6760543 AS SmallDateTime), CAST(8.50 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'c0a8a20f-136e-4e05-951d-cd4d4a0a063c', CAST(20191 AS Decimal(18, 0)), CAST(34 AS Decimal(18, 0)), 1, CAST(1100 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA6760549 AS SmallDateTime), CAST(5.50 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'c0a8a20f-136e-4e05-951d-cd4d4a0a063c', CAST(20192 AS Decimal(18, 0)), CAST(67 AS Decimal(18, 0)), 1, CAST(200 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA6760549 AS SmallDateTime), CAST(1.00 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'c0a8a20f-136e-4e05-951d-cd4d4a0a063c', CAST(20193 AS Decimal(18, 0)), CAST(58 AS Decimal(18, 0)), 1, CAST(250 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA6760549 AS SmallDateTime), CAST(1.25 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'a01439a5-b079-465f-b7c9-d6014209252c', CAST(20194 AS Decimal(18, 0)), CAST(23 AS Decimal(18, 0)), 1, CAST(1900 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA67703B1 AS SmallDateTime), CAST(9.50 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'a01439a5-b079-465f-b7c9-d6014209252c', CAST(20195 AS Decimal(18, 0)), CAST(116 AS Decimal(18, 0)), 1, CAST(300 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA67703B1 AS SmallDateTime), CAST(1.50 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'a01439a5-b079-465f-b7c9-d6014209252c', CAST(20196 AS Decimal(18, 0)), CAST(69 AS Decimal(18, 0)), 1, CAST(1000 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA67703B1 AS SmallDateTime), CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'a01439a5-b079-465f-b7c9-d6014209252c', CAST(20197 AS Decimal(18, 0)), CAST(100 AS Decimal(18, 0)), 1, CAST(800 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA67703B2 AS SmallDateTime), CAST(4.00 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'a01439a5-b079-465f-b7c9-d6014209252c', CAST(20198 AS Decimal(18, 0)), CAST(53 AS Decimal(18, 0)), 1, CAST(1000 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA67703B2 AS SmallDateTime), CAST(5.00 AS Decimal(18, 2)))
INSERT [dbo].[tblCustomerOrderDetail] ([StoreCartId], [CustomerOrderDetailId], [FoodItemId], [Quantity], [UnitPrice], [CustomerDetailId], [OrderDate], [SellerFeePaid]) VALUES (N'a01439a5-b079-465f-b7c9-d6014209252c', CAST(20199 AS Decimal(18, 0)), CAST(83 AS Decimal(18, 0)), 1, CAST(900 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)), CAST(0xA67703B2 AS SmallDateTime), CAST(4.50 AS Decimal(18, 2)))
SET IDENTITY_INSERT [dbo].[tblCustomerOrderDetail] OFF
SET IDENTITY_INSERT [dbo].[tblFoodGroup] ON 

INSERT [dbo].[tblFoodGroup] ([FoodGroupId], [FoodGroupName]) VALUES (CAST(1 AS Decimal(18, 0)), N'Grains and Dried Foods')
INSERT [dbo].[tblFoodGroup] ([FoodGroupId], [FoodGroupName]) VALUES (CAST(2 AS Decimal(18, 0)), N'Proteins')
INSERT [dbo].[tblFoodGroup] ([FoodGroupId], [FoodGroupName]) VALUES (CAST(3 AS Decimal(18, 0)), N'Diaries')
INSERT [dbo].[tblFoodGroup] ([FoodGroupId], [FoodGroupName]) VALUES (CAST(4 AS Decimal(18, 0)), N'Fruits and Vegetables')
INSERT [dbo].[tblFoodGroup] ([FoodGroupId], [FoodGroupName]) VALUES (CAST(5 AS Decimal(18, 0)), N'Fats and Oils')
INSERT [dbo].[tblFoodGroup] ([FoodGroupId], [FoodGroupName]) VALUES (CAST(6 AS Decimal(18, 0)), N'Tubers and Root Foods')
INSERT [dbo].[tblFoodGroup] ([FoodGroupId], [FoodGroupName]) VALUES (CAST(8 AS Decimal(18, 0)), N'Snacks and Buiscuits')
INSERT [dbo].[tblFoodGroup] ([FoodGroupId], [FoodGroupName]) VALUES (CAST(9 AS Decimal(18, 0)), N'Drinks')
INSERT [dbo].[tblFoodGroup] ([FoodGroupId], [FoodGroupName]) VALUES (CAST(10 AS Decimal(18, 0)), N'BreakFast and Cereals')
INSERT [dbo].[tblFoodGroup] ([FoodGroupId], [FoodGroupName]) VALUES (CAST(11 AS Decimal(18, 0)), N'Pasta and Noddles')
INSERT [dbo].[tblFoodGroup] ([FoodGroupId], [FoodGroupName]) VALUES (CAST(12 AS Decimal(18, 0)), N'Soups and Spices')
SET IDENTITY_INSERT [dbo].[tblFoodGroup] OFF
SET IDENTITY_INSERT [dbo].[tblFoodItem] ON 

INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(3 AS Decimal(18, 0)), N'Red Beans 5kg', CAST(8 AS Decimal(18, 0)), CAST(3500.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), 7, N'~/Content/Images/redbeans2.png', N'Red Beans Photo', CAST(1 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)), CAST(2 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(4 AS Decimal(18, 0)), N'White Beans 5kg', CAST(9 AS Decimal(18, 0)), CAST(4000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), 24, N'~/Content/Images/whitebeans2.png', N'White Beans Photo', CAST(1 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(9 AS Decimal(18, 0)), N'Egg', CAST(1 AS Decimal(18, 0)), CAST(700.00 AS Decimal(18, 2)), CAST(630.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), CAST(800.00 AS Decimal(18, 2)), 2, N'~/Content/Images/egg2.png', N'Eggs Photo', CAST(2 AS Decimal(18, 0)), CAST(2 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(11 AS Decimal(18, 0)), N'Royal Stallion Rice 10kg', CAST(5 AS Decimal(18, 0)), CAST(2100.00 AS Decimal(18, 2)), CAST(2000.00 AS Decimal(18, 2)), NULL, CAST(2500.00 AS Decimal(18, 2)), 20, N'~/Content/Images/royalstallionrice.png', N'Stallion Rice', CAST(1 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(12 AS Decimal(18, 0)), N'Royal Stallion Rice 5kg', CAST(5 AS Decimal(18, 0)), CAST(1100.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), NULL, CAST(1500.00 AS Decimal(18, 2)), 20, N'~/Content/Images/royalstallionrice.png', N'Stallion Rice', CAST(1 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(13 AS Decimal(18, 0)), N'Royal Stallion Rice 25kg', CAST(5 AS Decimal(18, 0)), CAST(4900.00 AS Decimal(18, 2)), CAST(4800.00 AS Decimal(18, 2)), NULL, CAST(5500.00 AS Decimal(18, 2)), 20, N'~/Content/Images/royalstallionrice.png', N'Stallion Rice', CAST(1 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(14 AS Decimal(18, 0)), N'Royal Stallion Rice 50kg', CAST(5 AS Decimal(18, 0)), CAST(10300.00 AS Decimal(18, 2)), CAST(10200.00 AS Decimal(18, 2)), NULL, CAST(11000.00 AS Decimal(18, 2)), 20, N'~/Content/Images/royalstallionrice.png', N'Stallion Rice', CAST(1 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(15 AS Decimal(18, 0)), N'Mama Gold Rice 50kg', CAST(5 AS Decimal(18, 0)), CAST(10300.00 AS Decimal(18, 2)), CAST(10200.00 AS Decimal(18, 2)), NULL, CAST(10500.00 AS Decimal(18, 2)), 20, N'~/Content/Images/mamagold50kg.png', N'Mama Gold Rice', CAST(1 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(16 AS Decimal(18, 0)), N'Mama Gold Rice 25kg', CAST(5 AS Decimal(18, 0)), CAST(4900.00 AS Decimal(18, 2)), CAST(4800.00 AS Decimal(18, 2)), NULL, CAST(5000.00 AS Decimal(18, 2)), 20, N'~/Content/Images/mamagoldrice.png', N'Mama Gold Rice', CAST(1 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(17 AS Decimal(18, 0)), N'Mama Gold Rice 10kg', CAST(5 AS Decimal(18, 0)), CAST(2100.00 AS Decimal(18, 2)), CAST(2000.00 AS Decimal(18, 2)), NULL, CAST(2500.00 AS Decimal(18, 2)), 20, N'~/Content/Images/mamagoldrice.png', N'Mam Gold Rice', CAST(1 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(18 AS Decimal(18, 0)), N'Mama Gold Rice 5kg', CAST(5 AS Decimal(18, 0)), CAST(1100.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), NULL, CAST(1500.00 AS Decimal(18, 2)), 20, N'~/Content/Images/mamagold5kg.png', N'Mama Gold Rice', CAST(1 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(19 AS Decimal(18, 0)), N'Caprice Gold Rice 25kg', CAST(5 AS Decimal(18, 0)), CAST(4900.00 AS Decimal(18, 2)), CAST(4800.00 AS Decimal(18, 2)), NULL, CAST(5000.00 AS Decimal(18, 2)), 20, N'~/Content/Images/capricerice.png', N'Caprice Rice', CAST(1 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(20 AS Decimal(18, 0)), N'Caprice Rice White 25kg', CAST(5 AS Decimal(18, 0)), CAST(4900.00 AS Decimal(18, 2)), CAST(4800.00 AS Decimal(18, 2)), NULL, CAST(5000.00 AS Decimal(18, 2)), 20, N'~/Content/Images/capricerice.png', N'Caprice Rice white', CAST(1 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(21 AS Decimal(18, 0)), N'Caprice White Rice 50kg', CAST(5 AS Decimal(18, 0)), CAST(10300.00 AS Decimal(18, 2)), CAST(10200.00 AS Decimal(18, 2)), NULL, CAST(11000.00 AS Decimal(18, 2)), 20, N'~/Content/Images/capricerice.png', N'Caprice White Rice', CAST(1 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(22 AS Decimal(18, 0)), N'Grand 2.7ltr ', CAST(10 AS Decimal(18, 0)), CAST(1450.00 AS Decimal(18, 2)), CAST(8400.00 AS Decimal(18, 2)), NULL, CAST(1500.00 AS Decimal(18, 2)), 20, N'~/Content/Images/grandoil2.7litr.png', N'Grand Oil', CAST(5 AS Decimal(18, 0)), CAST(7 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(23 AS Decimal(18, 0)), N'Grand 4ltr', CAST(10 AS Decimal(18, 0)), CAST(1900.00 AS Decimal(18, 2)), CAST(11000.00 AS Decimal(18, 2)), NULL, CAST(2000.00 AS Decimal(18, 2)), 20, N'~/Content/Images/grandoil4ltr.png', N'Grand Oil', CAST(5 AS Decimal(18, 0)), CAST(7 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(24 AS Decimal(18, 0)), N'Grand 10ltr', CAST(10 AS Decimal(18, 0)), CAST(4600.00 AS Decimal(18, 2)), CAST(4500.00 AS Decimal(18, 2)), NULL, CAST(5000.00 AS Decimal(18, 2)), 20, N'~/Content/Images/grandoilbig.png', N'Grand Oil', CAST(5 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(25 AS Decimal(18, 0)), N'Grand 18ltr', CAST(10 AS Decimal(18, 0)), CAST(8100.00 AS Decimal(18, 2)), CAST(8000.00 AS Decimal(18, 2)), NULL, CAST(9000.00 AS Decimal(18, 2)), 20, N'~/Content/Images/grandoilbig.png', N'Grand Oil', CAST(5 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(26 AS Decimal(18, 0)), N'Caprisone', CAST(13 AS Decimal(18, 0)), CAST(1700.00 AS Decimal(18, 2)), CAST(1650.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/caprisone.png', N'Caprisone', CAST(9 AS Decimal(18, 0)), CAST(7 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(27 AS Decimal(18, 0)), N'Ndomie s/size', CAST(15 AS Decimal(18, 0)), CAST(50.00 AS Decimal(18, 2)), CAST(1250.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/NdomieNoodle.png', N'Ndomie Noodle', CAST(11 AS Decimal(18, 0)), CAST(7 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(28 AS Decimal(18, 0)), N'Ndomie b/size', CAST(15 AS Decimal(18, 0)), CAST(100.00 AS Decimal(18, 2)), CAST(2100.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/NdomieNoodle.png', N'Ndomie Noodle', CAST(11 AS Decimal(18, 0)), CAST(7 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(29 AS Decimal(18, 0)), N'Ribena ', CAST(13 AS Decimal(18, 0)), CAST(2000.00 AS Decimal(18, 2)), CAST(1900.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/cartonOfRibena.png', N'Ribena', CAST(9 AS Decimal(18, 0)), CAST(7 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(30 AS Decimal(18, 0)), N'Pepsi Pk', CAST(12 AS Decimal(18, 0)), CAST(1100.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/packofPepsi.png', N'Pepsi', CAST(9 AS Decimal(18, 0)), CAST(8 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(31 AS Decimal(18, 0)), N'Teem Pk', CAST(12 AS Decimal(18, 0)), CAST(1100.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/packOfTeem.png', N'Teem', CAST(9 AS Decimal(18, 0)), CAST(8 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(32 AS Decimal(18, 0)), N'Fanta Pk', CAST(12 AS Decimal(18, 0)), CAST(1200.00 AS Decimal(18, 2)), CAST(1100.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/packofFantaBottle.png', N'Fanta', CAST(9 AS Decimal(18, 0)), CAST(8 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(33 AS Decimal(18, 0)), N'Bottled Swan Water', CAST(12 AS Decimal(18, 0)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/swanwater.png', N'swan water', CAST(9 AS Decimal(18, 0)), CAST(8 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(34 AS Decimal(18, 0)), N'Coca Cola Pk', CAST(12 AS Decimal(18, 0)), CAST(1100.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/packofcocacolabottle.png', N'Coca Cola', CAST(9 AS Decimal(18, 0)), CAST(8 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(35 AS Decimal(18, 0)), N'Sprite Pk', CAST(12 AS Decimal(18, 0)), CAST(1200.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/packofspritebottle.png', N'Sprite', CAST(9 AS Decimal(18, 0)), CAST(8 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(36 AS Decimal(18, 0)), N'Fayrouz Pk', CAST(12 AS Decimal(18, 0)), CAST(1400.00 AS Decimal(18, 2)), CAST(1300.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/fayrouzebottle.png', N'fayrouz', CAST(9 AS Decimal(18, 0)), CAST(8 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(37 AS Decimal(18, 0)), N'Spinach', CAST(17 AS Decimal(18, 0)), CAST(150.00 AS Decimal(18, 2)), CAST(150.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/spinach.png', N'Spinach', CAST(4 AS Decimal(18, 0)), CAST(11 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(38 AS Decimal(18, 0)), N'Pepper (Atarugu)', CAST(17 AS Decimal(18, 0)), CAST(500.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/atarugupepper.png', N'Atarugu', CAST(4 AS Decimal(18, 0)), CAST(12 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(39 AS Decimal(18, 0)), N'Garden Egg', CAST(17 AS Decimal(18, 0)), CAST(150.00 AS Decimal(18, 2)), CAST(150.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/gardenegg.png', N'Garden Egg', CAST(4 AS Decimal(18, 0)), CAST(11 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(40 AS Decimal(18, 0)), N'Green pepper', CAST(17 AS Decimal(18, 0)), CAST(100.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/freshgreenpepper.png', N'Green Pepper', CAST(4 AS Decimal(18, 0)), CAST(11 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(41 AS Decimal(18, 0)), N'Carrot', CAST(17 AS Decimal(18, 0)), CAST(300.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/freshcarrot.png', N'Carrot', CAST(4 AS Decimal(18, 0)), CAST(11 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(42 AS Decimal(18, 0)), N'Green Beans', CAST(17 AS Decimal(18, 0)), CAST(100.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/greenbeans.png', N'Green Beans', CAST(4 AS Decimal(18, 0)), CAST(11 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(43 AS Decimal(18, 0)), N'Watermellon', CAST(16 AS Decimal(18, 0)), CAST(400.00 AS Decimal(18, 2)), CAST(400.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/watermellon.png', N'watermellon', CAST(4 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(44 AS Decimal(18, 0)), N'Pineapple', CAST(16 AS Decimal(18, 0)), CAST(400.00 AS Decimal(18, 2)), CAST(400.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/pineapple.png', N'Pineapple', CAST(4 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(45 AS Decimal(18, 0)), N'Spring Onions', CAST(17 AS Decimal(18, 0)), CAST(100.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/springonions.png', N'Spring Onions', CAST(4 AS Decimal(18, 0)), CAST(11 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(46 AS Decimal(18, 0)), N'ScruptiousFood(5in1)', CAST(19 AS Decimal(18, 0)), CAST(350.00 AS Decimal(18, 2)), CAST(350.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/mrsdafur5in1.png', N'ScruptiousFood 5in1 Snacks', CAST(8 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(47 AS Decimal(18, 0)), N'ScruptiousFood(3in1)', CAST(19 AS Decimal(18, 0)), CAST(250.00 AS Decimal(18, 2)), CAST(250.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/mrsdafur3in1.png', N'ScruptiousFood 3in1', CAST(8 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(48 AS Decimal(18, 0)), N'ScruptiousFood Rect', CAST(19 AS Decimal(18, 0)), CAST(200.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/mrsdafurrectangle.png', N'ScruptiousFood Rectangle', CAST(8 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(49 AS Decimal(18, 0)), N'ScruptiousFoodSingle', CAST(19 AS Decimal(18, 0)), CAST(150.00 AS Decimal(18, 2)), CAST(120.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/mrsdafurSnack1.png', N'ScruptiousFoodSingle', CAST(8 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(3 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(50 AS Decimal(18, 0)), N'MamaSpecial Uncooked Samosa(5)', CAST(11 AS Decimal(18, 0)), CAST(500.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/samosa.png', N'Samosa', CAST(8 AS Decimal(18, 0)), CAST(13 AS Decimal(18, 0)), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(51 AS Decimal(18, 0)), N'MamaSpecial Uncooked SpringRoll(5)', CAST(11 AS Decimal(18, 0)), CAST(500.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/springrolls.png', N'SpringRoll', CAST(8 AS Decimal(18, 0)), CAST(13 AS Decimal(18, 0)), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(52 AS Decimal(18, 0)), N'MamaSpecial Unccoked Samosa(10)', CAST(11 AS Decimal(18, 0)), CAST(1000.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/samosa.png', N'samosa', CAST(8 AS Decimal(18, 0)), CAST(14 AS Decimal(18, 0)), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(53 AS Decimal(18, 0)), N'MamaSpecial Uncooked Springroll(10)', CAST(11 AS Decimal(18, 0)), CAST(1000.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/springrolls.png', N'SpringRoll', CAST(8 AS Decimal(18, 0)), CAST(14 AS Decimal(18, 0)), CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(54 AS Decimal(18, 0)), N'Tomatoes', CAST(17 AS Decimal(18, 0)), CAST(350.00 AS Decimal(18, 2)), CAST(350.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/tomatoes.png', N'Tomatoes', CAST(4 AS Decimal(18, 0)), CAST(12 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(55 AS Decimal(18, 0)), N'Pepper Tatase', CAST(17 AS Decimal(18, 0)), CAST(300.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/tatasepepper.png', N'Tatase Pepper', CAST(4 AS Decimal(18, 0)), CAST(12 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(56 AS Decimal(18, 0)), N'Pepper Shombo', CAST(17 AS Decimal(18, 0)), CAST(300.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/shombopepper.png', N'Shombo Pepper', CAST(4 AS Decimal(18, 0)), CAST(12 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(57 AS Decimal(18, 0)), N'Ugu Leaves', CAST(17 AS Decimal(18, 0)), CAST(150.00 AS Decimal(18, 2)), CAST(150.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/uguleaves.png', N'Ugu Leaves', CAST(4 AS Decimal(18, 0)), CAST(11 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(58 AS Decimal(18, 0)), N'Onions', CAST(17 AS Decimal(18, 0)), CAST(250.00 AS Decimal(18, 2)), CAST(250.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/onion.png', N'Onions', CAST(4 AS Decimal(18, 0)), CAST(12 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(59 AS Decimal(18, 0)), N'Okro', CAST(17 AS Decimal(18, 0)), CAST(200.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/okro.png', N'Okro', CAST(4 AS Decimal(18, 0)), CAST(11 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(60 AS Decimal(18, 0)), N'Dried Pepper', CAST(21 AS Decimal(18, 0)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/driedpepper.png', N'Dried Pepper', CAST(1 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(61 AS Decimal(18, 0)), N'Ogbono grounded (mudu)', CAST(21 AS Decimal(18, 0)), CAST(2600.00 AS Decimal(18, 2)), CAST(2600.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/ogbono.png', N'Ogbono', CAST(12 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(62 AS Decimal(18, 0)), N'Ogbono grounded (cup)', CAST(21 AS Decimal(18, 0)), CAST(350.00 AS Decimal(18, 2)), CAST(350.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/ogbono.png', N'Ogbono', CAST(12 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(63 AS Decimal(18, 0)), N'Egusi grounded (mudu)', CAST(21 AS Decimal(18, 0)), CAST(600.00 AS Decimal(18, 2)), CAST(600.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/egusi.png', N'Egusi', CAST(12 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(64 AS Decimal(18, 0)), N'Egusi ungrounded', CAST(21 AS Decimal(18, 0)), CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/egusi.png', N'Egusi', CAST(1 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(65 AS Decimal(18, 0)), N'Yam Tubers', CAST(22 AS Decimal(18, 0)), CAST(500.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/yam.png', N'Yam', CAST(6 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(66 AS Decimal(18, 0)), N'Sweet Potatoes', CAST(23 AS Decimal(18, 0)), CAST(200.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/sweetpotatoe.png', N'Sweet Potatoes', CAST(6 AS Decimal(18, 0)), CAST(12 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(67 AS Decimal(18, 0)), N'Apple small(3perPack)', CAST(16 AS Decimal(18, 0)), CAST(200.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/applesmall.png', N'Apple', CAST(4 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(68 AS Decimal(18, 0)), N'Apple big(single)', CAST(16 AS Decimal(18, 0)), CAST(150.00 AS Decimal(18, 2)), CAST(150.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/singleapple.png', N'Apple', CAST(4 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(69 AS Decimal(18, 0)), N'Cow Meat unpieced', CAST(2 AS Decimal(18, 0)), CAST(1000.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/meatwhole.png', N'Beef', CAST(2 AS Decimal(18, 0)), CAST(15 AS Decimal(18, 0)), CAST(2 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(70 AS Decimal(18, 0)), N'Cow Meat piecesed', CAST(2 AS Decimal(18, 0)), CAST(1000.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/meatpieces.png', N'Beef', CAST(2 AS Decimal(18, 0)), CAST(15 AS Decimal(18, 0)), CAST(2 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(71 AS Decimal(18, 0)), N'Cow Tail small', CAST(2 AS Decimal(18, 0)), CAST(5000.00 AS Decimal(18, 2)), CAST(5000.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/cowtail.png', N'Cow Tail', CAST(2 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(2 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(72 AS Decimal(18, 0)), N'Cow Tail big', CAST(2 AS Decimal(18, 0)), CAST(8000.00 AS Decimal(18, 2)), CAST(8000.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/cowtail.png', N'Cow Tail', CAST(2 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(2 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(73 AS Decimal(18, 0)), N'MaiSuya Roasted Broiler Chicken(Frozen)', CAST(3 AS Decimal(18, 0)), CAST(1250.00 AS Decimal(18, 2)), CAST(1200.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/roastedChicken.png', N'Roasted Chicken', CAST(2 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(74 AS Decimal(18, 0)), N'MaiSuya Roasted Local Chicken(Frozen)', CAST(3 AS Decimal(18, 0)), CAST(1250.00 AS Decimal(18, 2)), CAST(1250.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/roastedChicken.png', N'Roasted Chicken', CAST(2 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(75 AS Decimal(18, 0)), N'Wesson Oil', CAST(10 AS Decimal(18, 0)), CAST(3200.00 AS Decimal(18, 2)), CAST(3099.00 AS Decimal(18, 2)), NULL, CAST(3200.00 AS Decimal(18, 2)), 20, N'~/Content/Images/wessonoil.png', N'Wesson Oil', CAST(5 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(76 AS Decimal(18, 0)), N'Laser Olive Oil', CAST(10 AS Decimal(18, 0)), CAST(3400.00 AS Decimal(18, 2)), CAST(3250.00 AS Decimal(18, 2)), NULL, CAST(3800.00 AS Decimal(18, 2)), 20, N'~/Content/Images/laseroliveoil.png', N'Laser olive Oil', CAST(5 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(77 AS Decimal(18, 0)), N'Laser Oil', CAST(10 AS Decimal(18, 0)), CAST(3350.00 AS Decimal(18, 2)), CAST(3250.00 AS Decimal(18, 2)), NULL, CAST(3700.00 AS Decimal(18, 2)), 20, N'~/Content/Images/laseroil.png', N'Laser Oil', CAST(5 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(78 AS Decimal(18, 0)), N'Dangote Salt small', CAST(24 AS Decimal(18, 0)), CAST(50.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), NULL, CAST(50.00 AS Decimal(18, 2)), 20, N'~/Content/Images/dangotesaltsmall.png', N'Salt', CAST(12 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(79 AS Decimal(18, 0)), N'Dangote Salt Big', CAST(24 AS Decimal(18, 0)), CAST(100.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), NULL, CAST(100.00 AS Decimal(18, 2)), 20, N'~/Content/Images/dangotesaltbig.png', N'Salt', CAST(12 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(80 AS Decimal(18, 0)), N'Know Chicken Cubes pack', CAST(24 AS Decimal(18, 0)), CAST(370.00 AS Decimal(18, 2)), CAST(370.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/knowchickenpk.png', N'Know Chicken', CAST(12 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(81 AS Decimal(18, 0)), N'Royco Cubes Pack', CAST(24 AS Decimal(18, 0)), CAST(250.00 AS Decimal(18, 2)), CAST(250.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/roycopk.png', N'Royco', CAST(12 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(82 AS Decimal(18, 0)), N'Maggi Cubes', CAST(24 AS Decimal(18, 0)), CAST(300.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/maggipk.png', N'Maggi', CAST(12 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(83 AS Decimal(18, 0)), N'Curry Big', CAST(24 AS Decimal(18, 0)), CAST(900.00 AS Decimal(18, 2)), CAST(900.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/currybig.png', N'Curry', CAST(12 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(84 AS Decimal(18, 0)), N'Thyme Big', CAST(24 AS Decimal(18, 0)), CAST(900.00 AS Decimal(18, 2)), CAST(900.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/thymebig.png', N'Thyme', CAST(12 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(85 AS Decimal(18, 0)), N'Ayoola Pounded Yam big', CAST(22 AS Decimal(18, 0)), CAST(1000.00 AS Decimal(18, 2)), CAST(950.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/ayoolapandoyam.png', N'Pando yam', CAST(1 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(86 AS Decimal(18, 0)), N'Kellogs Cornflakes large', CAST(18 AS Decimal(18, 0)), CAST(1700.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/kellogscornflakes.png', N'Kellogs Cornflakes', CAST(10 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(87 AS Decimal(18, 0)), N'Kellogs Cornflakes Medium', CAST(18 AS Decimal(18, 0)), CAST(1300.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/kellogscornflakes.png', N'Kellogs', CAST(10 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(88 AS Decimal(18, 0)), N'Kellogs Cornflakes Small', CAST(18 AS Decimal(18, 0)), CAST(1000.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/kellogscornflakes.png', N'Kellogs', CAST(10 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(89 AS Decimal(18, 0)), N'Kellogs CocoPops', CAST(18 AS Decimal(18, 0)), CAST(1200.00 AS Decimal(18, 2)), CAST(1200.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/cocopopscereal.png', N'Cocopops', CAST(10 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(90 AS Decimal(18, 0)), N'Nasco Cornflakes', CAST(18 AS Decimal(18, 0)), CAST(400.00 AS Decimal(18, 2)), CAST(400.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/nascocornflakes.png', N'NascoCornflakes', CAST(10 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(91 AS Decimal(18, 0)), N'Milo Cereal', CAST(18 AS Decimal(18, 0)), CAST(700.00 AS Decimal(18, 2)), CAST(700.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/milocereal.png', N'Milo Cereal', CAST(10 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(92 AS Decimal(18, 0)), N'Quaker Oats', CAST(25 AS Decimal(18, 0)), CAST(350.00 AS Decimal(18, 2)), CAST(350.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/quakeroats.png', N'Quaker Oats', CAST(10 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(93 AS Decimal(18, 0)), N'Millville Oats', CAST(25 AS Decimal(18, 0)), CAST(1200.00 AS Decimal(18, 2)), CAST(1200.00 AS Decimal(18, 2)), NULL, CAST(0.00 AS Decimal(18, 2)), 20, N'~/Content/Images/millvilleoats.png', N'MillvilleOats', CAST(10 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(94 AS Decimal(18, 0)), N'Ogbono (mudu)', CAST(21 AS Decimal(18, 0)), CAST(2600.00 AS Decimal(18, 2)), CAST(2600.00 AS Decimal(18, 2)), NULL, NULL, 20, N'~/Content/Images/ogbono.png', N'Ogbono', CAST(12 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(95 AS Decimal(18, 0)), N'Ogbono (cup) ', CAST(21 AS Decimal(18, 0)), CAST(350.00 AS Decimal(18, 2)), CAST(350.00 AS Decimal(18, 2)), NULL, NULL, 20, N'~/Content/Images/ogbono.png', N'Ogbono', CAST(12 AS Decimal(18, 0)), CAST(16 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(96 AS Decimal(18, 0)), N'Egusi (mudu)', CAST(21 AS Decimal(18, 0)), CAST(600.00 AS Decimal(18, 2)), CAST(600.00 AS Decimal(18, 2)), NULL, NULL, 20, N'~/Content/Images/egusi.png', N'Egusi', CAST(12 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(97 AS Decimal(18, 0)), N'CrayFish (mudu)', CAST(4 AS Decimal(18, 0)), CAST(1000.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), NULL, NULL, 20, N'~/Content/Images/crayfish.png', N'Cray Fish', CAST(2 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(98 AS Decimal(18, 0)), N'Dried Cat Fish', CAST(4 AS Decimal(18, 0)), CAST(1500.00 AS Decimal(18, 2)), CAST(1500.00 AS Decimal(18, 2)), NULL, NULL, 50, N'~/Content/Images/driedcatfish.png', N'Cat Fish', CAST(2 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(99 AS Decimal(18, 0)), N'Iced Fish small size(kilo)', CAST(4 AS Decimal(18, 0)), CAST(800.00 AS Decimal(18, 2)), CAST(800.00 AS Decimal(18, 2)), NULL, NULL, 20, N'~/Content/Images/icedfish.png', N'iced Fish', CAST(2 AS Decimal(18, 0)), CAST(15 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(100 AS Decimal(18, 0)), N'Iced Fish big(kilo)', CAST(4 AS Decimal(18, 0)), CAST(800.00 AS Decimal(18, 2)), CAST(800.00 AS Decimal(18, 2)), NULL, NULL, 20, N'~/Content/Images/icedfish.png', N'iced fish', CAST(2 AS Decimal(18, 0)), CAST(15 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(101 AS Decimal(18, 0)), N'Stock Fish Big pack', CAST(4 AS Decimal(18, 0)), CAST(1000.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), NULL, NULL, 20, N'~/Content/Images/stockfish.png', N'Stock Fish', CAST(2 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(102 AS Decimal(18, 0)), N'Stock Fish Med pack', CAST(4 AS Decimal(18, 0)), CAST(500.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), NULL, NULL, 20, N'~/Content/Images/stockfish.png', N'stock fish', CAST(2 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(103 AS Decimal(18, 0)), N'Stock Fish small pack', CAST(4 AS Decimal(18, 0)), CAST(200.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), NULL, NULL, 20, N'~/Content/Images/stockfish.png', N'stock fish', CAST(2 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(104 AS Decimal(18, 0)), N'Stock Fish Head', CAST(4 AS Decimal(18, 0)), CAST(600.00 AS Decimal(18, 2)), CAST(600.00 AS Decimal(18, 2)), NULL, NULL, 20, N'~/Content/Images/stockfishhead.png', N'stock fish', CAST(2 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(105 AS Decimal(18, 0)), N'Stock Fish Full body', CAST(4 AS Decimal(18, 0)), CAST(3000.00 AS Decimal(18, 2)), CAST(3000.00 AS Decimal(18, 2)), NULL, NULL, 20, N'~/Content/Images/stockfishbody.png', N'stock fish', CAST(2 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(106 AS Decimal(18, 0)), N'Cameroun pepper big pk', CAST(24 AS Decimal(18, 0)), CAST(500.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), NULL, NULL, 20, N'~/Content/Images/camerounpepper.png', N'pepper', CAST(12 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)))
GO
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(107 AS Decimal(18, 0)), N'Cameroun pepper small pk', CAST(24 AS Decimal(18, 0)), CAST(200.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), NULL, NULL, 20, N'~/Content/Images/camerounpepper.png', N'pepper', CAST(12 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(108 AS Decimal(18, 0)), N'White Gari (mudu)', CAST(7 AS Decimal(18, 0)), CAST(120.00 AS Decimal(18, 2)), CAST(120.00 AS Decimal(18, 2)), NULL, NULL, 20, N'~/Content/Images/whitegari.png', N'Gari', CAST(1 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(109 AS Decimal(18, 0)), N'Yellow Gari', CAST(7 AS Decimal(18, 0)), CAST(150.00 AS Decimal(18, 2)), CAST(150.00 AS Decimal(18, 2)), NULL, NULL, 20, N'~/Content/Images/redgari.png', N'Gari', CAST(1 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(110 AS Decimal(18, 0)), N'Honey Red Beans (mudu)', CAST(8 AS Decimal(18, 0)), CAST(350.00 AS Decimal(18, 2)), CAST(350.00 AS Decimal(18, 2)), NULL, NULL, 20, N'~/Content/Images/redbeans2.png', N'Honey red beans', CAST(1 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(111 AS Decimal(18, 0)), N'Plantain bunch', CAST(17 AS Decimal(18, 0)), CAST(1000.00 AS Decimal(18, 2)), CAST(1000.00 AS Decimal(18, 2)), NULL, NULL, 20, N'~/Content/Images/plantain.png', N'plantain', CAST(4 AS Decimal(18, 0)), CAST(11 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(112 AS Decimal(18, 0)), N'Plantain Unripe', CAST(17 AS Decimal(18, 0)), CAST(600.00 AS Decimal(18, 2)), CAST(600.00 AS Decimal(18, 2)), NULL, NULL, 20, N'~/Content/Images/unripeplantain.png', N'plantain', CAST(4 AS Decimal(18, 0)), CAST(11 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(113 AS Decimal(18, 0)), N'Yam 5 a bundle', CAST(22 AS Decimal(18, 0)), CAST(2000.00 AS Decimal(18, 2)), CAST(2000.00 AS Decimal(18, 2)), NULL, NULL, 20, N'~/Content/Images/yam5tuber.png', N'Yam', CAST(6 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(114 AS Decimal(18, 0)), N'Cow Skin (Kpomo x2)', CAST(2 AS Decimal(18, 0)), CAST(500.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), NULL, NULL, 20, N'~/Content/Images/kpomo.png', N'cow skin', CAST(2 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(6 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(115 AS Decimal(18, 0)), N'Ayoola Pounded Yam small', CAST(22 AS Decimal(18, 0)), CAST(500.00 AS Decimal(18, 2)), CAST(475.00 AS Decimal(18, 2)), NULL, NULL, 20, N'~/Content/Images/ayoolapandoyam.png', N'Pounded yam', CAST(6 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(116 AS Decimal(18, 0)), N'Cabbage', CAST(17 AS Decimal(18, 0)), CAST(300.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), NULL, NULL, 20, N'~/Content/Images/cabbage.png', N'cabbage', CAST(4 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(117 AS Decimal(18, 0)), N'WaterMellon', CAST(16 AS Decimal(18, 0)), CAST(250.00 AS Decimal(18, 2)), CAST(250.00 AS Decimal(18, 2)), NULL, NULL, 20, N'~/Content/Images/watermellon.png', N'watermellon', CAST(4 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(118 AS Decimal(18, 0)), N'Yam single', CAST(22 AS Decimal(18, 0)), CAST(300.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), NULL, NULL, 20, N'~/Content/Images/yamsingle.png', N'Yam', CAST(6 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(119 AS Decimal(18, 0)), N'Cucumber', CAST(17 AS Decimal(18, 0)), CAST(200.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), NULL, NULL, 20, N'~/Content/Images/cucumber.png', N'Cucumber', CAST(4 AS Decimal(18, 0)), CAST(1 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)))
INSERT [dbo].[tblFoodItem] ([FoodItemId], [FoodName], [SubFoodGroupId], [FoodCost], [BuyingPrice], [SuleimanWholeSalePrice], [MarketSellingPrice], [QuantityAvailable], [FoodPicture], [AlternateText], [FoodGroupId], [FoodWeightTypeId], [SellerId]) VALUES (CAST(120 AS Decimal(18, 0)), N'Irish Potatoes small basket', CAST(23 AS Decimal(18, 0)), CAST(400.00 AS Decimal(18, 2)), CAST(400.00 AS Decimal(18, 2)), NULL, NULL, 20, N'~/Content/Images/irishpotatoe.png', N'irish potatoes', CAST(6 AS Decimal(18, 0)), CAST(12 AS Decimal(18, 0)), CAST(5 AS Decimal(18, 0)))
SET IDENTITY_INSERT [dbo].[tblFoodItem] OFF
SET IDENTITY_INSERT [dbo].[tblFoodWeightType] ON 

INSERT [dbo].[tblFoodWeightType] ([FoodWeightTypeId], [FoodWeightTypeName]) VALUES (CAST(1 AS Decimal(18, 0)), N'None')
INSERT [dbo].[tblFoodWeightType] ([FoodWeightTypeId], [FoodWeightTypeName]) VALUES (CAST(2 AS Decimal(18, 0)), N'per Crate')
INSERT [dbo].[tblFoodWeightType] ([FoodWeightTypeId], [FoodWeightTypeName]) VALUES (CAST(3 AS Decimal(18, 0)), N'per Bundle')
INSERT [dbo].[tblFoodWeightType] ([FoodWeightTypeId], [FoodWeightTypeName]) VALUES (CAST(4 AS Decimal(18, 0)), N'per Weight')
INSERT [dbo].[tblFoodWeightType] ([FoodWeightTypeId], [FoodWeightTypeName]) VALUES (CAST(5 AS Decimal(18, 0)), N'per Mudu')
INSERT [dbo].[tblFoodWeightType] ([FoodWeightTypeId], [FoodWeightTypeName]) VALUES (CAST(6 AS Decimal(18, 0)), N'per Bag')
INSERT [dbo].[tblFoodWeightType] ([FoodWeightTypeId], [FoodWeightTypeName]) VALUES (CAST(7 AS Decimal(18, 0)), N'per Carton')
INSERT [dbo].[tblFoodWeightType] ([FoodWeightTypeId], [FoodWeightTypeName]) VALUES (CAST(8 AS Decimal(18, 0)), N'per pack of 12')
INSERT [dbo].[tblFoodWeightType] ([FoodWeightTypeId], [FoodWeightTypeName]) VALUES (CAST(9 AS Decimal(18, 0)), N'per pack of 24')
INSERT [dbo].[tblFoodWeightType] ([FoodWeightTypeId], [FoodWeightTypeName]) VALUES (CAST(10 AS Decimal(18, 0)), N'per pack of 6')
INSERT [dbo].[tblFoodWeightType] ([FoodWeightTypeId], [FoodWeightTypeName]) VALUES (CAST(11 AS Decimal(18, 0)), N'per Bunch')
INSERT [dbo].[tblFoodWeightType] ([FoodWeightTypeId], [FoodWeightTypeName]) VALUES (CAST(12 AS Decimal(18, 0)), N'per Small Basket')
INSERT [dbo].[tblFoodWeightType] ([FoodWeightTypeId], [FoodWeightTypeName]) VALUES (CAST(13 AS Decimal(18, 0)), N'per pack of 5')
INSERT [dbo].[tblFoodWeightType] ([FoodWeightTypeId], [FoodWeightTypeName]) VALUES (CAST(14 AS Decimal(18, 0)), N'per pack of 10')
INSERT [dbo].[tblFoodWeightType] ([FoodWeightTypeId], [FoodWeightTypeName]) VALUES (CAST(15 AS Decimal(18, 0)), N'per Kilo')
INSERT [dbo].[tblFoodWeightType] ([FoodWeightTypeId], [FoodWeightTypeName]) VALUES (CAST(16 AS Decimal(18, 0)), N'per Cup')
SET IDENTITY_INSERT [dbo].[tblFoodWeightType] OFF
SET IDENTITY_INSERT [dbo].[tblOrderNumber] ON 

INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'5354007a-15d1-46e7-8e35-9f7943bc5e28', CAST(1 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'5354007a-15d1-46e7-8e35-9f7943bc5e28', CAST(2 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'77d22fb3-12cd-4b22-8d28-dc4d83c7bc87', CAST(3 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'77d22fb3-12cd-4b22-8d28-dc4d83c7bc87', CAST(4 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'4a4aa40c-b124-4208-9427-3aaab8e2d4c0', CAST(5 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'4a4aa40c-b124-4208-9427-3aaab8e2d4c0', CAST(6 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'af0f82ff-f557-4c2d-be98-265fead56805', CAST(7 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'af0f82ff-f557-4c2d-be98-265fead56805', CAST(8 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'387dd300-d090-4497-a5cd-18ee6d62bca9', CAST(9 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'387dd300-d090-4497-a5cd-18ee6d62bca9', CAST(10 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'1f99c813-d3ba-472e-ac96-f2059897d87a', CAST(11 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'4d3a3e1d-a6d0-47ea-b6fa-00546007b8e0', CAST(12 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'2e38f341-cec4-4113-baa5-aca42038a7de', CAST(13 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'de835f13-d580-42ec-9d0f-bfaf09b4f187', CAST(14 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'23f1b8b1-36ea-44ef-ad82-956407b71a2b', CAST(15 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'234ef731-17c5-4dbd-83ad-2d83d59eb105', CAST(16 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'bf9bbf9b-124a-4991-ad81-0db1f6221a81', CAST(17 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'bf9bbf9b-124a-4991-ad81-0db1f6221a81', CAST(18 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'bf9bbf9b-124a-4991-ad81-0db1f6221a81', CAST(19 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'bf9bbf9b-124a-4991-ad81-0db1f6221a81', CAST(20 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'5f02234b-ebee-4310-b295-0beccf0365f5', CAST(21 AS Decimal(18, 0)), N'zomoad@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'1c448bb1-0413-46c1-bf92-773480134ef1', CAST(22 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'e3b41816-82e7-49e4-a5bd-69db8669b9a4', CAST(23 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'933a28f5-4645-46c3-81b1-b1125bfcf330', CAST(24 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'ee7140ad-ce0e-4b7e-b07a-4197d9833fb6', CAST(25 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'28723db2-a77a-4b54-85a4-04fc549d20bb', CAST(26 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'28723db2-a77a-4b54-85a4-04fc549d20bb', CAST(27 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'28723db2-a77a-4b54-85a4-04fc549d20bb', CAST(28 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'581f33e5-6d0b-4c96-8ad3-726d619c4e61', CAST(29 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'581f33e5-6d0b-4c96-8ad3-726d619c4e61', CAST(30 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'581f33e5-6d0b-4c96-8ad3-726d619c4e61', CAST(31 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'df44ad7d-203e-4726-a094-e6c530fd55e5', CAST(32 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'641cd830-39dd-4c93-bf8e-1d8d39023d35', CAST(33 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'e615fbf3-3744-4e59-99d6-d82885323cd2', CAST(34 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'177d6b26-89c7-4514-8551-0a7d3f886b44', CAST(35 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'e1980e20-42fa-4003-96fa-5367cd1ae64b', CAST(36 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'3ce172b8-d967-462e-a963-cd0e79f46f89', CAST(37 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'48174d66-2d67-4c2d-a1f7-836e9355a619', CAST(38 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'48174d66-2d67-4c2d-a1f7-836e9355a619', CAST(39 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'48174d66-2d67-4c2d-a1f7-836e9355a619', CAST(40 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'0d260af4-7e01-471b-a252-ad4bf8254aef', CAST(41 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'd855cd48-9e70-412d-972d-0e2c192ec71b', CAST(42 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'3ed369fd-09c1-4c38-887f-f078180ca771', CAST(43 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'b1d1bc08-de16-41e8-b7db-42d253b324a0', CAST(44 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'b1d1bc08-de16-41e8-b7db-42d253b324a0', CAST(45 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'125d6830-eca2-4dab-800d-0c6d19ecf688', CAST(46 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'aef78e5e-b158-45b0-a253-dd940d7eecf8', CAST(47 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'21848689-fb0b-4770-a0ef-61761bf4756f', CAST(48 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'21848689-fb0b-4770-a0ef-61761bf4756f', CAST(49 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'21848689-fb0b-4770-a0ef-61761bf4756f', CAST(50 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'c251d617-f8c1-4ac9-b87f-37075b426b05', CAST(51 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'c251d617-f8c1-4ac9-b87f-37075b426b05', CAST(52 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'dd56a3f9-5eda-41ad-94f0-4994138af390', CAST(53 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'dd56a3f9-5eda-41ad-94f0-4994138af390', CAST(54 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'14af14c2-2f89-40fb-a8f9-28821288e7da', CAST(55 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'b560a84b-ab0f-4a15-aaa8-d1eeda2cac3d', CAST(56 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'6a93f7c8-de00-4dfd-b90c-c108a9c3d2e1', CAST(57 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'6a93f7c8-de00-4dfd-b90c-c108a9c3d2e1', CAST(58 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'e228d509-2ae8-4486-9610-d8a901c2398a', CAST(59 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'e228d509-2ae8-4486-9610-d8a901c2398a', CAST(60 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'3295f482-a9bd-471e-a193-23dcb6d761e9', CAST(61 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'3295f482-a9bd-471e-a193-23dcb6d761e9', CAST(62 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'17895699-f0e0-4da7-891b-4ad83e267200', CAST(63 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'8ad835a1-6067-46aa-bf64-7d6cede68c35', CAST(64 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'8ad835a1-6067-46aa-bf64-7d6cede68c35', CAST(65 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'fec467aa-4297-4c04-8d39-535497d043b6', CAST(66 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'89ca2cd4-5d59-4a6b-ab76-9545a17a50e3', CAST(67 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'58e4b599-4e68-4330-b5c1-e5558d68906f', CAST(68 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'5a1c37c3-036a-47c7-b9fa-259204c492bf', CAST(69 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'cfb766b8-5d3b-4dfa-8418-629478257322', CAST(10064 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'36155a4e-5133-413a-b5bc-76f65e405201', CAST(10065 AS Decimal(18, 0)), N'testermeagain@testermeagain.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'0ca124a9-622b-4d43-97ba-74e8a9cbbcf7', CAST(10066 AS Decimal(18, 0)), N'chkitagain@chkitagain.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'da8f120d-596c-44f4-af04-440c83159ea0', CAST(10067 AS Decimal(18, 0)), N'umarwithumarwith@umarwith.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'977cd740-c7c2-4206-99be-005dcfee552f', CAST(10068 AS Decimal(18, 0)), N'UmartaxUmartax@UmartaxUmartax.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'45b08119-965b-47fd-aeb3-50e02ddb22bd', CAST(10069 AS Decimal(18, 0)), N'UmartaxUmartax@UmartaxUmartax.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'82ef20e2-0169-48a2-9f63-fadfbe35d290', CAST(10070 AS Decimal(18, 0)), N'Shewhomustbeobeyed@Shewhomustbeobeyed.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'1d41dc63-6dc0-4b9f-aa35-14e786254979', CAST(10071 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'46bf8bb4-1f35-4b9a-b110-112dd3b280f9', CAST(10072 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'51aedaee-0954-46a3-8bba-7c3e2dd4f21a', CAST(10073 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'51aedaee-0954-46a3-8bba-7c3e2dd4f21a', CAST(10074 AS Decimal(18, 0)), N'zimpik@yahoo.com', NULL)
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'877f527a-a6cf-4947-acb8-7e617cbdba43', CAST(10075 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA5680546 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'89c5a601-88b2-4c9e-857a-35e2ac83450e', CAST(10076 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA5690210 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'e34221b8-1983-4344-b39d-0764d465d540', CAST(10077 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA5690244 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'bc6b2468-bbcf-4021-88a6-90ae537a3d71', CAST(10078 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA569031A AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'359d16a9-f17b-4eb4-9248-c3d0b0169de1', CAST(10079 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA569034A AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'19b49871-e99e-40a4-8520-1512ab35cac5', CAST(10080 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA569034F AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'03cabb75-7673-4408-87e2-1902a82a5ee3', CAST(10081 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA5690386 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'2ee67f81-9481-407c-bf12-498a07c4fa43', CAST(10082 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA56903A7 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'4efe1c9c-1c46-4553-82d2-3a51bab6747f', CAST(10083 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA56903BC AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'9e86ad1c-a9c3-41df-b043-a39ffab20ec2', CAST(10084 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA56903C1 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'998dc515-0c07-4949-b559-a51dcfaf903e', CAST(10085 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA56903C9 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'3264a445-20ca-446d-9685-5a5e2c510853', CAST(10086 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA56903EC AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'e800d4f6-4610-45c5-af18-c13c9e158c66', CAST(10087 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA56903EF AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'94042ba2-452f-4940-870c-3d138a90ae9b', CAST(10088 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA56903F9 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'6cfd843a-5522-444d-afe0-a80e8969b6a1', CAST(10089 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA569040D AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'5970d356-0c43-47c3-9344-a0abfd000df6', CAST(10090 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA5690410 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'30f7871c-18a0-43bd-91a7-90b1652fc56a', CAST(10091 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA5690419 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'fe3ea306-a083-4c33-b2a2-3806e2eb7246', CAST(10092 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA5690424 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'51edb225-b2ab-42ec-a5c7-65ed5707b293', CAST(10093 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA5690441 AS SmallDateTime))
GO
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'72abb869-47f1-4f89-b7f4-1438789c0ae5', CAST(10094 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA569045E AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'64b171cd-febf-4f73-977e-0c3cda46b74a', CAST(10095 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA569046D AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'a4157a4d-f44d-484a-8275-844be713293a', CAST(10096 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA5690476 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'7ee5bc58-bda9-4782-be0d-177fc363e5b8', CAST(10097 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA5690507 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'9f1295b7-1bb7-47c7-bf1c-6fff17f037ba', CAST(10098 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA5690510 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'aaae5e04-9b77-4902-b54a-6cc990276130', CAST(10099 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA5690527 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'e95dc5e2-90f9-404f-a973-789aa3f88a33', CAST(10100 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA56A0224 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'e95dc5e2-90f9-404f-a973-789aa3f88a33', CAST(10101 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA56A0228 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'e5e69d14-3d54-4274-be30-fb32eefd9cf0', CAST(10102 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA59B02D4 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'14e2ef8b-62e6-405d-92ff-7c168047bcf5', CAST(10103 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA59B02E1 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'fe4b8f1f-c28a-4f22-baf4-0be6f18466ff', CAST(10104 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA59B02EE AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'2ef86d9b-ba76-41f2-b9ed-c4e946bc6257', CAST(10105 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA59B0331 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'97806656-029e-48cc-8178-375c7463b24d', CAST(20097 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA661039D AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'0cd3e521-254e-4141-9170-6b9709294803', CAST(20098 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA66103B4 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'90493a47-3157-42a6-9b27-639181f8188c', CAST(20099 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA66103BC AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'04ebfe0c-e0f7-4d55-b7d9-e6dc9b9a50bf', CAST(20100 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA66103C6 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'a80775fe-7096-463c-9a2c-ab3dc126f415', CAST(20101 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA66103D8 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'a80775fe-7096-463c-9a2c-ab3dc126f415', CAST(20102 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA66103E3 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'd4cf0bc7-5107-49b0-95ad-c727c604aef0', CAST(20103 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA66103E9 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'a7d62f15-19d3-450b-8494-989b5550fc1c', CAST(20104 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA66403F4 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'a7d62f15-19d3-450b-8494-989b5550fc1c', CAST(20105 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA66403F9 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'b32a4b90-c4d6-40b7-8152-2fb4e73566e1', CAST(20106 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA664040F AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'70c22b85-25e8-4c2c-8689-354f26d9d800', CAST(20107 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA6640414 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'8dae8156-6a57-4fa7-8cd7-9948ac4ae371', CAST(20108 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA664041A AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'0efb805a-cf0b-4fb7-b122-ac1d3e9a839d', CAST(20109 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA6640425 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'ad5e97aa-a1f4-4a30-9e25-b0d90113a4c8', CAST(20110 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA6640474 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'e6e081ab-a0a1-4e86-a7b8-f4f625b3b174', CAST(20111 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA664047D AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'256d79a3-b545-4ed9-936b-24c349955b84', CAST(20112 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA6640488 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'8271b38e-99b3-4132-910d-a97b1a1beb4f', CAST(20113 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA66404AB AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'a0f12a7c-ca42-46ea-a29a-eb7e2319e43c', CAST(20114 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA66404D1 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'32909afe-735e-42b4-8909-8a2ced94d101', CAST(20115 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA664050A AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'c0a8a20f-136e-4e05-951d-cd4d4a0a063c', CAST(20116 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA6760543 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'c0a8a20f-136e-4e05-951d-cd4d4a0a063c', CAST(20117 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA6760543 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'c0a8a20f-136e-4e05-951d-cd4d4a0a063c', CAST(20118 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA6760549 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'c0a8a20f-136e-4e05-951d-cd4d4a0a063c', CAST(20119 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA676054B AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'a01439a5-b079-465f-b7c9-d6014209252c', CAST(20120 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA67703B1 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'a01439a5-b079-465f-b7c9-d6014209252c', CAST(20121 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA67703B2 AS SmallDateTime))
INSERT [dbo].[tblOrderNumber] ([StoreCartId], [OrderNumberId], [UserName], [DateCreated]) VALUES (N'a01439a5-b079-465f-b7c9-d6014209252c', CAST(20122 AS Decimal(18, 0)), N'zimpik@yahoo.com', CAST(0xA67703B4 AS SmallDateTime))
SET IDENTITY_INSERT [dbo].[tblOrderNumber] OFF
SET IDENTITY_INSERT [dbo].[tblSellerDetails] ON 

INSERT [dbo].[tblSellerDetails] ([SellerId], [SellerName], [SellerState], [SellerAddress], [SellerPhoneNumber], [SellerEmail], [SellerAccountNumber], [BankId], [SellerAccountName], [DateJoined]) VALUES (CAST(1 AS Decimal(18, 0)), N'Quicky Sale', N'Abuja', N'Apo Leg Qtrs', N'080999999', N'zimpik@yahoo.com', N'0345555666', CAST(1 AS Decimal(18, 0)), N'Quicky Sale Ltd', NULL)
INSERT [dbo].[tblSellerDetails] ([SellerId], [SellerName], [SellerState], [SellerAddress], [SellerPhoneNumber], [SellerEmail], [SellerAccountNumber], [BankId], [SellerAccountName], [DateJoined]) VALUES (CAST(2 AS Decimal(18, 0)), N'Dele MeatShop', N'Abuja', N'Garki Market', N'09999999', N'zimpik@yahoo.com', N'546465464', CAST(5 AS Decimal(18, 0)), N'Dele MeatShop', NULL)
INSERT [dbo].[tblSellerDetails] ([SellerId], [SellerName], [SellerState], [SellerAddress], [SellerPhoneNumber], [SellerEmail], [SellerAccountNumber], [BankId], [SellerAccountName], [DateJoined]) VALUES (CAST(3 AS Decimal(18, 0)), N'Mrs Dafur', N'Abuja', N'Apo Abuja', N'08033463062', N'scruptiousfoodsandbakes@yahoo.com', N'878788', CAST(7 AS Decimal(18, 0)), N'Mrs Dafur', CAST(0xA5460501 AS SmallDateTime))
INSERT [dbo].[tblSellerDetails] ([SellerId], [SellerName], [SellerState], [SellerAddress], [SellerPhoneNumber], [SellerEmail], [SellerAccountNumber], [BankId], [SellerAccountName], [DateJoined]) VALUES (CAST(4 AS Decimal(18, 0)), N'Mrs J Komo', N'Plateau', N'Jos', N'07056538681', N'jumkomo@gmail.com', N'435435345', CAST(6 AS Decimal(18, 0)), N'Mrs Komo', CAST(0xA5460504 AS SmallDateTime))
INSERT [dbo].[tblSellerDetails] ([SellerId], [SellerName], [SellerState], [SellerAddress], [SellerPhoneNumber], [SellerEmail], [SellerAccountNumber], [BankId], [SellerAccountName], [DateJoined]) VALUES (CAST(5 AS Decimal(18, 0)), N'Victoria Store ', N'Abuja', N'Apo Lokogoma', N'0999999999', N'zimpik@yahoo.com', N'8989898989', CAST(1 AS Decimal(18, 0)), N'Victoria Lokogoma', CAST(0xA55004E4 AS SmallDateTime))
INSERT [dbo].[tblSellerDetails] ([SellerId], [SellerName], [SellerState], [SellerAddress], [SellerPhoneNumber], [SellerEmail], [SellerAccountNumber], [BankId], [SellerAccountName], [DateJoined]) VALUES (CAST(6 AS Decimal(18, 0)), N'Ijeoma Store', N'Abuja', N'Nyanya', N'09999999999', N'zimpik@yahoo.com', N'99999999', CAST(1 AS Decimal(18, 0)), N'Ijeoma Store', CAST(0xA55402B9 AS SmallDateTime))
SET IDENTITY_INSERT [dbo].[tblSellerDetails] OFF
INSERT [dbo].[tblSellerFee] ([Fee]) VALUES (CAST(0.50 AS Decimal(18, 2)))
SET IDENTITY_INSERT [dbo].[tblState] ON 

INSERT [dbo].[tblState] ([StateName], [StateId]) VALUES (N'Abuja', CAST(1 AS Decimal(18, 0)))
SET IDENTITY_INSERT [dbo].[tblState] OFF
SET IDENTITY_INSERT [dbo].[tblStoreCart] ON 

INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'082e39f2-3f7a-4659-906b-1bd9e3a3cc4a', 1, CAST(0xA5670319 AS SmallDateTime), CAST(10230 AS Decimal(18, 0)), CAST(13 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'082e39f2-3f7a-4659-906b-1bd9e3a3cc4a', 1, CAST(0xA5670319 AS SmallDateTime), CAST(10231 AS Decimal(18, 0)), CAST(19 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'082e39f2-3f7a-4659-906b-1bd9e3a3cc4a', 1, CAST(0xA5670319 AS SmallDateTime), CAST(10232 AS Decimal(18, 0)), CAST(16 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'3822a8c0-c4e0-4933-9acc-5bf10d2751af', 1, CAST(0xA5670320 AS SmallDateTime), CAST(10233 AS Decimal(18, 0)), CAST(13 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'3822a8c0-c4e0-4933-9acc-5bf10d2751af', 1, CAST(0xA5670320 AS SmallDateTime), CAST(10234 AS Decimal(18, 0)), CAST(19 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'1dc82e1b-7c70-4544-9019-76e543662bd7', 1, CAST(0xA5670324 AS SmallDateTime), CAST(10235 AS Decimal(18, 0)), CAST(9 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'875dec72-e261-4509-a3a5-20d6c13e2a04', 1, CAST(0xA5670442 AS SmallDateTime), CAST(10236 AS Decimal(18, 0)), CAST(89 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'875dec72-e261-4509-a3a5-20d6c13e2a04', 1, CAST(0xA5670442 AS SmallDateTime), CAST(10237 AS Decimal(18, 0)), CAST(24 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'875dec72-e261-4509-a3a5-20d6c13e2a04', 2, CAST(0xA5670443 AS SmallDateTime), CAST(10238 AS Decimal(18, 0)), CAST(68 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'a06e6958-b70e-4b23-bdf4-010ef23f09f1', 1, CAST(0xA5670449 AS SmallDateTime), CAST(10239 AS Decimal(18, 0)), CAST(28 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'a06e6958-b70e-4b23-bdf4-010ef23f09f1', 1, CAST(0xA567044A AS SmallDateTime), CAST(10240 AS Decimal(18, 0)), CAST(24 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'a06e6958-b70e-4b23-bdf4-010ef23f09f1', 2, CAST(0xA567044A AS SmallDateTime), CAST(10241 AS Decimal(18, 0)), CAST(68 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'bf5fcaf2-5312-4599-93d9-f789eeea1490', 1, CAST(0xA567044B AS SmallDateTime), CAST(10242 AS Decimal(18, 0)), CAST(24 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'bf5fcaf2-5312-4599-93d9-f789eeea1490', 1, CAST(0xA567044B AS SmallDateTime), CAST(10243 AS Decimal(18, 0)), CAST(23 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'bf5fcaf2-5312-4599-93d9-f789eeea1490', 1, CAST(0xA567044B AS SmallDateTime), CAST(10244 AS Decimal(18, 0)), CAST(99 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'e26acb76-0291-4285-9ee4-6a44c6097bef', 2, CAST(0xA5670457 AS SmallDateTime), CAST(10249 AS Decimal(18, 0)), CAST(68 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'bf3bcc33-3aa9-4bdd-ad3f-24377d68fb14', 2, CAST(0xA567045A AS SmallDateTime), CAST(10250 AS Decimal(18, 0)), CAST(68 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'bf3bcc33-3aa9-4bdd-ad3f-24377d68fb14', 1, CAST(0xA567045A AS SmallDateTime), CAST(10251 AS Decimal(18, 0)), CAST(50 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'284d340d-e4e9-4058-a12d-b910b2466aae', 1, CAST(0xA567047F AS SmallDateTime), CAST(10259 AS Decimal(18, 0)), CAST(23 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'284d340d-e4e9-4058-a12d-b910b2466aae', 1, CAST(0xA567047F AS SmallDateTime), CAST(10260 AS Decimal(18, 0)), CAST(75 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'1b780ff0-90b9-4dd0-9e2f-05705589755e', 1, CAST(0xA5670494 AS SmallDateTime), CAST(10267 AS Decimal(18, 0)), CAST(24 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'1b780ff0-90b9-4dd0-9e2f-05705589755e', 1, CAST(0xA5670495 AS SmallDateTime), CAST(10268 AS Decimal(18, 0)), CAST(39 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'1b780ff0-90b9-4dd0-9e2f-05705589755e', 1, CAST(0xA5670495 AS SmallDateTime), CAST(10269 AS Decimal(18, 0)), CAST(76 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'72f66c2d-e853-47e9-8d26-fed00787d965', 2, CAST(0xA5680224 AS SmallDateTime), CAST(10279 AS Decimal(18, 0)), CAST(68 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'72f66c2d-e853-47e9-8d26-fed00787d965', 1, CAST(0xA5680224 AS SmallDateTime), CAST(10280 AS Decimal(18, 0)), CAST(37 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'72f66c2d-e853-47e9-8d26-fed00787d965', 1, CAST(0xA5680224 AS SmallDateTime), CAST(10281 AS Decimal(18, 0)), CAST(119 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'a491aabc-781b-4c9c-8beb-2bbc4dadcbba', 1, CAST(0xA569031F AS SmallDateTime), CAST(10291 AS Decimal(18, 0)), CAST(38 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'a491aabc-781b-4c9c-8beb-2bbc4dadcbba', 1, CAST(0xA569031F AS SmallDateTime), CAST(10292 AS Decimal(18, 0)), CAST(116 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'59145d02-ceed-4b15-a765-e213038879c1', 1, CAST(0xA5690327 AS SmallDateTime), CAST(10293 AS Decimal(18, 0)), CAST(38 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'da927af8-39ed-4373-9544-0b8846233bce', 1, CAST(0xA569034E AS SmallDateTime), CAST(10297 AS Decimal(18, 0)), CAST(58 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'da927af8-39ed-4373-9544-0b8846233bce', 1, CAST(0xA569034E AS SmallDateTime), CAST(10298 AS Decimal(18, 0)), CAST(116 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'1b4773bf-759e-4a76-9f4c-e61130671d0f', 1, CAST(0xA56903C6 AS SmallDateTime), CAST(10307 AS Decimal(18, 0)), CAST(38 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'478abd6f-cc02-4983-97ac-eb59cb49e319', 1, CAST(0xA56903E9 AS SmallDateTime), CAST(10309 AS Decimal(18, 0)), CAST(58 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'a4c14dbf-8b8f-4664-bb2e-5e93fdf21de1', 1, CAST(0xA569042C AS SmallDateTime), CAST(10317 AS Decimal(18, 0)), CAST(24 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'e37b8234-4378-4670-902e-c8ffa167ec6c', 2, CAST(0xA56904F9 AS SmallDateTime), CAST(10326 AS Decimal(18, 0)), CAST(68 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'e37b8234-4378-4670-902e-c8ffa167ec6c', 1, CAST(0xA56904F9 AS SmallDateTime), CAST(10327 AS Decimal(18, 0)), CAST(58 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'5d0dd198-73c1-41d6-b3d5-ab2388944f2c', 1, CAST(0xA5A10321 AS SmallDateTime), CAST(20328 AS Decimal(18, 0)), CAST(116 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'5d0dd198-73c1-41d6-b3d5-ab2388944f2c', 1, CAST(0xA5A10321 AS SmallDateTime), CAST(20329 AS Decimal(18, 0)), CAST(41 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'5d0dd198-73c1-41d6-b3d5-ab2388944f2c', 1, CAST(0xA5A10322 AS SmallDateTime), CAST(20330 AS Decimal(18, 0)), CAST(54 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'ed02ccc6-85e4-4b37-888b-791002cfe92c', 2, CAST(0xA5B60312 AS SmallDateTime), CAST(20331 AS Decimal(18, 0)), CAST(68 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'e09aab7a-7e68-4fcd-b271-67fa186df1bf', 1, CAST(0xA5B60313 AS SmallDateTime), CAST(20332 AS Decimal(18, 0)), CAST(38 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'5661f8ef-a507-4a51-8e17-6c242050476e', 1, CAST(0xA5B60322 AS SmallDateTime), CAST(20333 AS Decimal(18, 0)), CAST(58 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'65b23e67-434c-4c26-8b81-c53ddc99c5e6', 1, CAST(0xA5B6033A AS SmallDateTime), CAST(20334 AS Decimal(18, 0)), CAST(58 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'70ab5cd3-d0db-4124-a707-43d179267245', 1, CAST(0xA5B80246 AS SmallDateTime), CAST(20335 AS Decimal(18, 0)), CAST(38 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'56090918-ae1a-4d3e-a54a-1fc597cacb3b', 1, CAST(0xA5BF0291 AS SmallDateTime), CAST(20336 AS Decimal(18, 0)), CAST(68 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'dae6d1b7-7d1f-4667-b017-ee1ca26fd925', 1, CAST(0xA5BF0291 AS SmallDateTime), CAST(20337 AS Decimal(18, 0)), CAST(39 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'dae6d1b7-7d1f-4667-b017-ee1ca26fd925', 1, CAST(0xA5BF0293 AS SmallDateTime), CAST(20338 AS Decimal(18, 0)), CAST(41 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'2b49bc0a-c76b-44cb-85d4-caad45b09c4d', 1, CAST(0xA5BF02BF AS SmallDateTime), CAST(20339 AS Decimal(18, 0)), CAST(44 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'2b49bc0a-c76b-44cb-85d4-caad45b09c4d', 1, CAST(0xA5BF02BF AS SmallDateTime), CAST(20340 AS Decimal(18, 0)), CAST(27 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'2b49bc0a-c76b-44cb-85d4-caad45b09c4d', 1, CAST(0xA5BF02BF AS SmallDateTime), CAST(20341 AS Decimal(18, 0)), CAST(89 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'cc7f888d-36e3-44b6-888f-5d02247c5b3f', 2, CAST(0xA5BF02C0 AS SmallDateTime), CAST(20342 AS Decimal(18, 0)), CAST(38 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'cc7f888d-36e3-44b6-888f-5d02247c5b3f', 1, CAST(0xA5BF02C0 AS SmallDateTime), CAST(20343 AS Decimal(18, 0)), CAST(59 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'cc7f888d-36e3-44b6-888f-5d02247c5b3f', 1, CAST(0xA5BF02C0 AS SmallDateTime), CAST(20344 AS Decimal(18, 0)), CAST(55 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'cc7f888d-36e3-44b6-888f-5d02247c5b3f', 1, CAST(0xA5BF02C0 AS SmallDateTime), CAST(20345 AS Decimal(18, 0)), CAST(43 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'cc7f888d-36e3-44b6-888f-5d02247c5b3f', 1, CAST(0xA5BF02C0 AS SmallDateTime), CAST(20346 AS Decimal(18, 0)), CAST(114 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'37e27529-57a4-41a9-aded-343437c99bc0', 1, CAST(0xA5BF02C6 AS SmallDateTime), CAST(20347 AS Decimal(18, 0)), CAST(116 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'37e27529-57a4-41a9-aded-343437c99bc0', 1, CAST(0xA5BF02C6 AS SmallDateTime), CAST(20348 AS Decimal(18, 0)), CAST(119 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'37e27529-57a4-41a9-aded-343437c99bc0', 1, CAST(0xA5BF02C6 AS SmallDateTime), CAST(20349 AS Decimal(18, 0)), CAST(68 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'a8bc9519-8006-4b5c-8f2d-3c720dd9c2ef', 1, CAST(0xA5BF0302 AS SmallDateTime), CAST(20350 AS Decimal(18, 0)), CAST(58 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'a8bc9519-8006-4b5c-8f2d-3c720dd9c2ef', 1, CAST(0xA5BF0302 AS SmallDateTime), CAST(20351 AS Decimal(18, 0)), CAST(102 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'3aa8b30c-a171-4676-aa57-cf825c0ae18f', 1, CAST(0xA5BF03F8 AS SmallDateTime), CAST(20352 AS Decimal(18, 0)), CAST(67 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'00faf049-2f97-4bf4-9826-41325dfbc973', 1, CAST(0xA6090452 AS SmallDateTime), CAST(20353 AS Decimal(18, 0)), CAST(38 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'007a5d2e-8116-4811-b0cd-2e08c518c4d9', 1, CAST(0xA66404A7 AS SmallDateTime), CAST(30375 AS Decimal(18, 0)), CAST(87 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'007a5d2e-8116-4811-b0cd-2e08c518c4d9', 1, CAST(0xA66404A7 AS SmallDateTime), CAST(30376 AS Decimal(18, 0)), CAST(26 AS Decimal(18, 0)), NULL)
INSERT [dbo].[tblStoreCart] ([StoreCartId], [Count], [DateCreated], [RecordId], [FoodItemId], [UserName]) VALUES (N'007a5d2e-8116-4811-b0cd-2e08c518c4d9', 1, CAST(0xA66404A7 AS SmallDateTime), CAST(30377 AS Decimal(18, 0)), CAST(22 AS Decimal(18, 0)), NULL)
SET IDENTITY_INSERT [dbo].[tblStoreCart] OFF
SET IDENTITY_INSERT [dbo].[tblSubFoodGroup] ON 

INSERT [dbo].[tblSubFoodGroup] ([SubFoodGroupId], [SubFoodGroupName], [FoodGroupId]) VALUES (CAST(1 AS Decimal(18, 0)), N'Eggs', CAST(2 AS Decimal(18, 0)))
INSERT [dbo].[tblSubFoodGroup] ([SubFoodGroupId], [SubFoodGroupName], [FoodGroupId]) VALUES (CAST(2 AS Decimal(18, 0)), N'Beef/Cow Meat', CAST(2 AS Decimal(18, 0)))
INSERT [dbo].[tblSubFoodGroup] ([SubFoodGroupId], [SubFoodGroupName], [FoodGroupId]) VALUES (CAST(3 AS Decimal(18, 0)), N'Chicken', CAST(2 AS Decimal(18, 0)))
INSERT [dbo].[tblSubFoodGroup] ([SubFoodGroupId], [SubFoodGroupName], [FoodGroupId]) VALUES (CAST(4 AS Decimal(18, 0)), N'Fish', CAST(2 AS Decimal(18, 0)))
INSERT [dbo].[tblSubFoodGroup] ([SubFoodGroupId], [SubFoodGroupName], [FoodGroupId]) VALUES (CAST(5 AS Decimal(18, 0)), N'Rice', CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblSubFoodGroup] ([SubFoodGroupId], [SubFoodGroupName], [FoodGroupId]) VALUES (CAST(6 AS Decimal(18, 0)), N'Corn', CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblSubFoodGroup] ([SubFoodGroupId], [SubFoodGroupName], [FoodGroupId]) VALUES (CAST(7 AS Decimal(18, 0)), N'Cassava', CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblSubFoodGroup] ([SubFoodGroupId], [SubFoodGroupName], [FoodGroupId]) VALUES (CAST(8 AS Decimal(18, 0)), N'Red Beans', CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblSubFoodGroup] ([SubFoodGroupId], [SubFoodGroupName], [FoodGroupId]) VALUES (CAST(9 AS Decimal(18, 0)), N'White Beans', CAST(1 AS Decimal(18, 0)))
INSERT [dbo].[tblSubFoodGroup] ([SubFoodGroupId], [SubFoodGroupName], [FoodGroupId]) VALUES (CAST(10 AS Decimal(18, 0)), N'Oils', CAST(5 AS Decimal(18, 0)))
INSERT [dbo].[tblSubFoodGroup] ([SubFoodGroupId], [SubFoodGroupName], [FoodGroupId]) VALUES (CAST(11 AS Decimal(18, 0)), N'Small Chops', CAST(8 AS Decimal(18, 0)))
INSERT [dbo].[tblSubFoodGroup] ([SubFoodGroupId], [SubFoodGroupName], [FoodGroupId]) VALUES (CAST(12 AS Decimal(18, 0)), N'NonAlcoholic', CAST(9 AS Decimal(18, 0)))
INSERT [dbo].[tblSubFoodGroup] ([SubFoodGroupId], [SubFoodGroupName], [FoodGroupId]) VALUES (CAST(13 AS Decimal(18, 0)), N'Kids Drinks', CAST(9 AS Decimal(18, 0)))
INSERT [dbo].[tblSubFoodGroup] ([SubFoodGroupId], [SubFoodGroupName], [FoodGroupId]) VALUES (CAST(14 AS Decimal(18, 0)), N'Pasta', CAST(11 AS Decimal(18, 0)))
INSERT [dbo].[tblSubFoodGroup] ([SubFoodGroupId], [SubFoodGroupName], [FoodGroupId]) VALUES (CAST(15 AS Decimal(18, 0)), N'Noodles', CAST(11 AS Decimal(18, 0)))
INSERT [dbo].[tblSubFoodGroup] ([SubFoodGroupId], [SubFoodGroupName], [FoodGroupId]) VALUES (CAST(16 AS Decimal(18, 0)), N'Fruits', CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[tblSubFoodGroup] ([SubFoodGroupId], [SubFoodGroupName], [FoodGroupId]) VALUES (CAST(17 AS Decimal(18, 0)), N'Vegetables', CAST(4 AS Decimal(18, 0)))
INSERT [dbo].[tblSubFoodGroup] ([SubFoodGroupId], [SubFoodGroupName], [FoodGroupId]) VALUES (CAST(18 AS Decimal(18, 0)), N'Cereals', CAST(10 AS Decimal(18, 0)))
INSERT [dbo].[tblSubFoodGroup] ([SubFoodGroupId], [SubFoodGroupName], [FoodGroupId]) VALUES (CAST(19 AS Decimal(18, 0)), N'Bakery', CAST(8 AS Decimal(18, 0)))
INSERT [dbo].[tblSubFoodGroup] ([SubFoodGroupId], [SubFoodGroupName], [FoodGroupId]) VALUES (CAST(20 AS Decimal(18, 0)), N'Biscuits', CAST(8 AS Decimal(18, 0)))
INSERT [dbo].[tblSubFoodGroup] ([SubFoodGroupId], [SubFoodGroupName], [FoodGroupId]) VALUES (CAST(21 AS Decimal(18, 0)), N'Dried Food for Soups', CAST(12 AS Decimal(18, 0)))
INSERT [dbo].[tblSubFoodGroup] ([SubFoodGroupId], [SubFoodGroupName], [FoodGroupId]) VALUES (CAST(22 AS Decimal(18, 0)), N'Tubers', CAST(6 AS Decimal(18, 0)))
INSERT [dbo].[tblSubFoodGroup] ([SubFoodGroupId], [SubFoodGroupName], [FoodGroupId]) VALUES (CAST(23 AS Decimal(18, 0)), N'Other Root Foods', CAST(6 AS Decimal(18, 0)))
INSERT [dbo].[tblSubFoodGroup] ([SubFoodGroupId], [SubFoodGroupName], [FoodGroupId]) VALUES (CAST(24 AS Decimal(18, 0)), N'Cooking Spice', CAST(12 AS Decimal(18, 0)))
INSERT [dbo].[tblSubFoodGroup] ([SubFoodGroupId], [SubFoodGroupName], [FoodGroupId]) VALUES (CAST(25 AS Decimal(18, 0)), N'Oats and Others', CAST(10 AS Decimal(18, 0)))
SET IDENTITY_INSERT [dbo].[tblSubFoodGroup] OFF
SET IDENTITY_INSERT [dbo].[tblUserProfile] ON 

INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10355 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'082e39f2-3f7a-4659-906b-1bd9e3a3cc4a', NULL)
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10365 AS Decimal(18, 0)), N'Guest', N'a719cdb4-dd9f-4b42-866e-2f426612fb65', NULL)
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10366 AS Decimal(18, 0)), N'umarwithumarwith@umarwith.com', N'da8f120d-596c-44f4-af04-440c83159ea0', NULL)
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10367 AS Decimal(18, 0)), N'UmartaxUmartax@Umartax.com', N'284d340d-e4e9-4058-a12d-b910b2466aae', NULL)
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10378 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'89c5a601-88b2-4c9e-857a-35e2ac83450e', CAST(0xA569020C AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10379 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'e34221b8-1983-4344-b39d-0764d465d540', CAST(0xA5690242 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10380 AS Decimal(18, 0)), N'Guest', N'a9b2746b-549d-4ff8-b6eb-4f99487523a5', CAST(0xA5690308 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10381 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'bc6b2468-bbcf-4021-88a6-90ae537a3d71', CAST(0xA5690316 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10382 AS Decimal(18, 0)), N'Guest', N'a491aabc-781b-4c9c-8beb-2bbc4dadcbba', CAST(0xA569031E AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10383 AS Decimal(18, 0)), N'Guest', N'59145d02-ceed-4b15-a765-e213038879c1', CAST(0xA5690324 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10384 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'359d16a9-f17b-4eb4-9248-c3d0b0169de1', CAST(0xA5690349 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10385 AS Decimal(18, 0)), N'Guest', N'da927af8-39ed-4373-9544-0b8846233bce', CAST(0xA569034E AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10386 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'19b49871-e99e-40a4-8520-1512ab35cac5', CAST(0xA569034F AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10387 AS Decimal(18, 0)), N'Guest', N'e95c2906-a184-4dd9-b1a5-407040f88f3d', CAST(0xA5690352 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10388 AS Decimal(18, 0)), N'Guest', N'8dc37b2e-c9b5-42ec-b01a-3d8efaa4a31b', CAST(0xA5690394 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10390 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'4efe1c9c-1c46-4553-82d2-3a51bab6747f', CAST(0xA56903B9 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10391 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'9e86ad1c-a9c3-41df-b043-a39ffab20ec2', CAST(0xA56903BF AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10392 AS Decimal(18, 0)), N'Guest', N'1b4773bf-759e-4a76-9f4c-e61130671d0f', CAST(0xA56903C5 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10393 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'998dc515-0c07-4949-b559-a51dcfaf903e', CAST(0xA56903C8 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10394 AS Decimal(18, 0)), N'Guest', N'478abd6f-cc02-4983-97ac-eb59cb49e319', CAST(0xA56903E4 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10395 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'3264a445-20ca-446d-9685-5a5e2c510853', CAST(0xA56903EA AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10396 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'e800d4f6-4610-45c5-af18-c13c9e158c66', CAST(0xA56903EE AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10397 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'94042ba2-452f-4940-870c-3d138a90ae9b', CAST(0xA56903F5 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10398 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'6cfd843a-5522-444d-afe0-a80e8969b6a1', CAST(0xA5690409 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10399 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'5970d356-0c43-47c3-9344-a0abfd000df6', CAST(0xA569040F AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10400 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'30f7871c-18a0-43bd-91a7-90b1652fc56a', CAST(0xA5690418 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10401 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'fe3ea306-a083-4c33-b2a2-3806e2eb7246', CAST(0xA5690422 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10402 AS Decimal(18, 0)), N'Guest', N'a4c14dbf-8b8f-4664-bb2e-5e93fdf21de1', CAST(0xA569042B AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10403 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'51edb225-b2ab-42ec-a5c7-65ed5707b293', CAST(0xA5690438 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10404 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'72abb869-47f1-4f89-b7f4-1438789c0ae5', CAST(0xA569045D AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10405 AS Decimal(18, 0)), N'Guest', N'8cdf5ff7-a34e-4e18-b3f1-e0eccb56922e', CAST(0xA5690467 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10406 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'64b171cd-febf-4f73-977e-0c3cda46b74a', CAST(0xA569046B AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10407 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'a4157a4d-f44d-484a-8275-844be713293a', CAST(0xA5690474 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10408 AS Decimal(18, 0)), N'Guest', N'e37b8234-4378-4670-902e-c8ffa167ec6c', CAST(0xA56904F5 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10409 AS Decimal(18, 0)), N'Guest', N'e6516a06-e8da-4a11-b3fb-33889664ec54', CAST(0xA56904FE AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10410 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'7ee5bc58-bda9-4782-be0d-177fc363e5b8', CAST(0xA5690503 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10411 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'9f1295b7-1bb7-47c7-bf1c-6fff17f037ba', CAST(0xA569050C AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10412 AS Decimal(18, 0)), N'Guest', N'44181f25-05be-4e6d-b8ab-b65f40ac3a68', CAST(0xA5690518 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10413 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'aaae5e04-9b77-4902-b54a-6cc990276130', CAST(0xA5690523 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10420 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'14e2ef8b-62e6-405d-92ff-7c168047bcf5', CAST(0xA59B02E0 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20411 AS Decimal(18, 0)), N'Guest', N'e6f785d9-4e89-4124-bba7-8c3392064947', CAST(0xA59F028C AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20412 AS Decimal(18, 0)), N'Guest', N'1f07f8fb-1279-4f92-afaa-e2fcc84a373e', CAST(0xA59F02B8 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20413 AS Decimal(18, 0)), N'Guest', N'99b37a40-b286-49bd-9c1d-8e1e834babbb', CAST(0xA59F02B8 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20414 AS Decimal(18, 0)), N'Guest', N'3576f277-3ee6-45b8-aba1-e24080725603', CAST(0xA59F02BA AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20415 AS Decimal(18, 0)), N'Guest', N'26b3b868-7201-4aa2-9166-fc240b0c8bf7', CAST(0xA5A1030F AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20416 AS Decimal(18, 0)), N'Guest', N'79dfc814-17ec-4c3d-9ad2-d4998338ecc5', CAST(0xA5A1030F AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20417 AS Decimal(18, 0)), N'Guest', N'ed88684b-6a27-4566-afe7-b84401d4ee5b', CAST(0xA5A10313 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20418 AS Decimal(18, 0)), N'Guest', N'3e05ddaa-609a-4342-b305-a3c0a6b1d899', CAST(0xA5A10314 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20419 AS Decimal(18, 0)), N'Guest', N'1f5bc764-ef39-4531-b3bf-e86840f82b03', CAST(0xA5A10316 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20420 AS Decimal(18, 0)), N'Guest', N'd45db2e8-b1a1-4610-ab06-496c29830405', CAST(0xA5A10316 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20421 AS Decimal(18, 0)), N'Guest', N'6d05a703-f1dd-4469-a0cf-5e41200307f9', CAST(0xA5A10316 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20422 AS Decimal(18, 0)), N'Guest', N'd22019e7-c843-4015-9a14-7c2af0726892', CAST(0xA5A10318 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20423 AS Decimal(18, 0)), N'Guest', N'8dad8c29-bdd4-4f1e-8cb8-23eae3c5a7ad', CAST(0xA5A10319 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20424 AS Decimal(18, 0)), N'Guest', N'01e32fe1-31bc-4885-a5bb-e28700cb2692', CAST(0xA5A10319 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20425 AS Decimal(18, 0)), N'Guest', N'0856013d-cb2c-45ac-aa8c-8b85a63a3d11', CAST(0xA5A10319 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20426 AS Decimal(18, 0)), N'Guest', N'8dde7fff-47d4-4a50-a4f3-9328d39e9545', CAST(0xA5A1031A AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20427 AS Decimal(18, 0)), N'Guest', N'43bcbe17-3649-4772-bb66-d54a349b53b1', CAST(0xA5A1031A AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20428 AS Decimal(18, 0)), N'Guest', N'0e8b653d-95c4-401a-99e9-4d78430e410f', CAST(0xA5A1031B AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20429 AS Decimal(18, 0)), N'Guest', N'5e3a8bfb-6cc7-4c21-9080-93688ffe4184', CAST(0xA5A1031D AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20430 AS Decimal(18, 0)), N'Guest', N'99a80b1e-8422-4e15-bf7f-c8e621d7c4bf', CAST(0xA5A1031E AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20431 AS Decimal(18, 0)), N'Guest', N'3eb73f1b-185f-4f5e-a5e2-5451c40db9e0', CAST(0xA5A1031F AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20432 AS Decimal(18, 0)), N'Guest', N'5d0dd198-73c1-41d6-b3d5-ab2388944f2c', CAST(0xA5A10321 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20433 AS Decimal(18, 0)), N'Guest', N'a944ad71-a579-4036-b27e-f0cfe6b491ae', CAST(0xA5A10348 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20434 AS Decimal(18, 0)), N'Guest', N'6ebb71e6-7dba-45fe-8cc3-48eca487ce49', CAST(0xA5A1034B AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20435 AS Decimal(18, 0)), N'Guest', N'a82f5bf7-ebfb-42ee-9505-abfe069e738d', CAST(0xA5A1034C AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20436 AS Decimal(18, 0)), N'Guest', N'c6d69915-f415-4669-bde0-142de0cf588a', CAST(0xA5A10354 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20437 AS Decimal(18, 0)), N'Guest', N'4913c7e7-f4ea-4dd0-a9ae-a9955d2371a7', CAST(0xA5A10356 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20438 AS Decimal(18, 0)), N'Guest', N'1f41849e-4896-4b3b-bc3a-fcf8b288733d', CAST(0xA5A10357 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20439 AS Decimal(18, 0)), N'Guest', N'9a41d23e-2cb2-43bb-8791-8a4fa2532a1c', CAST(0xA5A1035C AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20440 AS Decimal(18, 0)), N'Guest', N'00152f2f-5ccc-4bd7-9e0d-a2606464ea5c', CAST(0xA5A1035D AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20441 AS Decimal(18, 0)), N'Guest', N'484a0d7d-c674-4aed-8d9b-40a081731ef0', CAST(0xA5A1035E AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20442 AS Decimal(18, 0)), N'Guest', N'5572decd-501a-4e81-90fc-ea688e2daaf5', CAST(0xA5A10365 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20443 AS Decimal(18, 0)), N'Guest', N'e37c4e78-cef7-4e22-b669-621fc25f6cce', CAST(0xA5A10368 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20444 AS Decimal(18, 0)), N'Guest', N'996f3d44-ade9-434d-a0f8-94da94a827fa', CAST(0xA5A1036A AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20445 AS Decimal(18, 0)), N'Guest', N'4eb2485e-e858-4fab-950e-fecdf8640e06', CAST(0xA5A1036A AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20446 AS Decimal(18, 0)), N'Guest', N'e985e57c-901d-4d53-9949-62297b1515dd', CAST(0xA5A1036B AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20447 AS Decimal(18, 0)), N'Guest', N'f624c8ae-403e-4e29-a0a4-41d7d758f68c', CAST(0xA5A1036C AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20448 AS Decimal(18, 0)), N'Guest', N'3e3dd645-9a45-4176-867f-15f008d6cc07', CAST(0xA5A1036C AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20449 AS Decimal(18, 0)), N'Guest', N'4165617d-b999-4ee1-b71b-a5fcdb896361', CAST(0xA5A20235 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20450 AS Decimal(18, 0)), N'Guest', N'a92482ff-1bfa-4596-91d7-767abf4597a2', CAST(0xA5A20237 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20451 AS Decimal(18, 0)), N'Guest', N'bbb993a9-4b2c-4fe6-b784-c7cb5030ae85', CAST(0xA5A20237 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20452 AS Decimal(18, 0)), N'Guest', N'49c2b315-88d0-4476-9a71-25e9acc78c09', CAST(0xA5A20261 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20455 AS Decimal(18, 0)), N'Guest', N'c26cd5db-b05b-457d-83a2-2f01f0bedd1c', CAST(0xA5A20269 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20456 AS Decimal(18, 0)), N'Guest', N'fd53fa0e-f31b-4615-9e8b-dca6d8a775da', CAST(0xA5A2026E AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20457 AS Decimal(18, 0)), N'Guest', N'17873526-abe4-415f-9121-6046fae33c7f', CAST(0xA5A20271 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20458 AS Decimal(18, 0)), N'Guest', N'16f49edf-b0a7-4b5e-98f7-265f86a24590', CAST(0xA5A20272 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20459 AS Decimal(18, 0)), N'Guest', N'cf6f2034-83fa-42f2-9e86-1d9a703a7aef', CAST(0xA5A20274 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20460 AS Decimal(18, 0)), N'Guest', N'20dc13d6-7cfc-4b3f-abe7-7493f8c79b7d', CAST(0xA5A20275 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20461 AS Decimal(18, 0)), N'Guest', N'8ab0cc58-1595-460a-a8f1-f6224e0dce59', CAST(0xA5A20277 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20462 AS Decimal(18, 0)), N'Guest', N'8211e7c1-8072-4e61-80d8-fe4449e5775e', CAST(0xA5A2027C AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20463 AS Decimal(18, 0)), N'Guest', N'8fa34a7d-597a-4c12-ac4d-4db11c4cd792', CAST(0xA5A20281 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20464 AS Decimal(18, 0)), N'Guest', N'498d2789-041e-4652-b91d-716cd954e986', CAST(0xA5A2028C AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20465 AS Decimal(18, 0)), N'Guest', N'3ff8707b-a211-4d90-a431-4e67d4dcaea5', CAST(0xA5A2028D AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20466 AS Decimal(18, 0)), N'Guest', N'7f6a7eda-9e73-4b6d-a349-258ec7cc32b8', CAST(0xA5A20296 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20467 AS Decimal(18, 0)), N'Guest', N'1fbd5797-a3af-4bd4-a94a-6ce0f4c09015', CAST(0xA5A20297 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20468 AS Decimal(18, 0)), N'Guest', N'7ec29e39-916f-426d-b886-a6f43925419b', CAST(0xA5A20299 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20469 AS Decimal(18, 0)), N'Guest', N'da3e610d-9ea9-43e6-b65f-0a28e04bd3a3', CAST(0xA5A2029C AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20470 AS Decimal(18, 0)), N'Guest', N'd9a9d726-4ee3-452d-9285-e3471ecbaa12', CAST(0xA5A2029F AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20471 AS Decimal(18, 0)), N'Guest', N'fbf886ab-d508-4599-a81d-0b3c0f9736f8', CAST(0xA5A2029F AS SmallDateTime))
GO
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20472 AS Decimal(18, 0)), N'Guest', N'62a0a767-d27b-4c9c-8fc5-6c9920f9679a', CAST(0xA5A202A0 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20473 AS Decimal(18, 0)), N'Guest', N'183e3f21-6ec2-45ce-b099-37ada2b11c62', CAST(0xA5A202A0 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20474 AS Decimal(18, 0)), N'Guest', N'b4f5a222-d670-4969-8dee-49f4bafe415e', CAST(0xA5A202A9 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20475 AS Decimal(18, 0)), N'Guest', N'4424b313-de0b-42c3-af45-9db932945544', CAST(0xA5A202AE AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20476 AS Decimal(18, 0)), N'Guest', N'6c770442-b3b1-4fa0-9b8b-3c1586b10915', CAST(0xA5A202B5 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20477 AS Decimal(18, 0)), N'Guest', N'e7afb152-e35e-489b-ab37-6886ed7dea8a', CAST(0xA5A202B5 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20478 AS Decimal(18, 0)), N'Guest', N'da5ab920-462d-4f37-99d3-fc2a811cf580', CAST(0xA5A202B5 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20479 AS Decimal(18, 0)), N'Guest', N'3e5d5d29-b9b2-4915-89f9-54ba8e49f5a6', CAST(0xA5A202BE AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20480 AS Decimal(18, 0)), N'Guest', N'3ff4183b-2511-4890-9843-1c8a39720bee', CAST(0xA5A202C0 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10364 AS Decimal(18, 0)), N'chkitagain@chkitagain.com', N'0ca124a9-622b-4d43-97ba-74e8a9cbbcf7', NULL)
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20453 AS Decimal(18, 0)), N'Guest', N'bae14010-8868-40f4-a32c-036e1ab2f2e1', CAST(0xA5A20262 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20491 AS Decimal(18, 0)), N'Guest', N'f23dc41d-dbae-4ba3-b23a-6edcec591668', CAST(0xA5A202D6 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20492 AS Decimal(18, 0)), N'Guest', N'0468899a-0145-441e-b001-34c2e52e4c1e', CAST(0xA5A202D7 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20493 AS Decimal(18, 0)), N'Guest', N'70c9acbe-e937-4006-9a15-fbe32f3eda5d', CAST(0xA5A202D7 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20494 AS Decimal(18, 0)), N'Guest', N'155dcd9c-0767-45ef-9ac2-93466e2a40da', CAST(0xA5A202D7 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20495 AS Decimal(18, 0)), N'Guest', N'3cc3c10b-6a63-4492-9f96-77b947d60368', CAST(0xA5A202D8 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20496 AS Decimal(18, 0)), N'Guest', N'20ce11f5-3bb0-4a1b-8e80-98bc0439b545', CAST(0xA5A202D9 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20497 AS Decimal(18, 0)), N'Guest', N'830ee9e1-f68d-45b1-9b05-b8d0af36d13b', CAST(0xA5A202D9 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20498 AS Decimal(18, 0)), N'Guest', N'970060ba-a6be-427c-bd34-de9f17212415', CAST(0xA5A202D9 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20499 AS Decimal(18, 0)), N'Guest', N'81deb9ca-3f5c-479c-af8c-f444bba3b7b7', CAST(0xA5A202DC AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20500 AS Decimal(18, 0)), N'Guest', N'017f2a95-d365-4a96-b75d-957383112870', CAST(0xA5A202DD AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20501 AS Decimal(18, 0)), N'Guest', N'02054170-e2f2-4ba4-9332-cb32a10cafbe', CAST(0xA5A202DD AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20502 AS Decimal(18, 0)), N'Guest', N'6741941e-e717-440d-a403-4b5f16c69e4c', CAST(0xA5A202DD AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20508 AS Decimal(18, 0)), N'Guest', N'69b87c93-1b94-485e-8e36-deeb2a753e46', CAST(0xA5A20301 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20509 AS Decimal(18, 0)), N'Guest', N'2cd7a5a5-a325-4e28-8c43-74a0b358f142', CAST(0xA5A20305 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20510 AS Decimal(18, 0)), N'Guest', N'4165daf9-11d8-4dae-b1a2-5094fbd254dd', CAST(0xA5A20307 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20511 AS Decimal(18, 0)), N'Guest', N'0785a212-7c81-4e6f-a8d1-abb503fab420', CAST(0xA5A20307 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20520 AS Decimal(18, 0)), N'Guest', N'1039d478-a9b1-4683-9e25-770cfea2becc', CAST(0xA5A20378 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20521 AS Decimal(18, 0)), N'Guest', N'10fb5717-6b22-4339-8e7f-7803ebde505b', CAST(0xA5A20379 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20522 AS Decimal(18, 0)), N'Guest', N'42d2e1a9-43d9-4151-9165-d2dab93b999b', CAST(0xA5A20379 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20537 AS Decimal(18, 0)), N'Guest', N'2665b377-04ea-4c7b-b86c-3ff158e0f13d', CAST(0xA5A204D0 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20538 AS Decimal(18, 0)), N'Guest', N'920fa05a-3318-40dd-96fa-3a0fff4284db', CAST(0xA5A204D2 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20539 AS Decimal(18, 0)), N'Guest', N'88fe4c86-9d75-42e6-b4bf-7c7a1ca9cc7c', CAST(0xA5A204D5 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20540 AS Decimal(18, 0)), N'Guest', N'd106d15d-adc6-42a7-9ccb-d56e5bca3090', CAST(0xA5A204D8 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20541 AS Decimal(18, 0)), N'Guest', N'29cc1aec-406f-4131-9e07-45bb8bfd5f25', CAST(0xA5A204D9 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20542 AS Decimal(18, 0)), N'Guest', N'6bbcfb34-56c1-4d82-9a52-75add09e7246', CAST(0xA5A204DA AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20543 AS Decimal(18, 0)), N'Guest', N'5d5dd751-d534-4d19-81be-044f25e3157c', CAST(0xA5A204DA AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20544 AS Decimal(18, 0)), N'Guest', N'88ae1584-303b-462f-b18a-f6334993d1ea', CAST(0xA5A204E0 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20545 AS Decimal(18, 0)), N'Guest', N'af5868e9-26c8-4894-9178-572141521a37', CAST(0xA5A204E3 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20546 AS Decimal(18, 0)), N'Guest', N'8a7329af-5fd1-425e-9e64-d3d52952b510', CAST(0xA5A204E9 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20547 AS Decimal(18, 0)), N'Guest', N'd84af0e4-1bd0-4e75-ab4e-f5c1cde617fe', CAST(0xA5A204F3 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20548 AS Decimal(18, 0)), N'Guest', N'7d5a521d-f8a2-42c7-ae28-39b9600e43fd', CAST(0xA5A204F3 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20549 AS Decimal(18, 0)), N'Guest', N'4b607773-650b-4191-b42e-fe4cf2d779df', CAST(0xA5A204F3 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20550 AS Decimal(18, 0)), N'Guest', N'524ff415-8e08-44fa-b136-d78065e82392', CAST(0xA5A204F5 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20602 AS Decimal(18, 0)), N'Guest', N'cbc329ea-490e-4b80-8636-50c16a6debcf', CAST(0xA5A3043F AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20614 AS Decimal(18, 0)), N'Guest', N'555c7bf9-b2b9-4ff3-a342-46056d0d3490', CAST(0xA5A304CC AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20615 AS Decimal(18, 0)), N'Guest', N'587468e2-a1a9-4a3e-98b8-73aa1be01f74', CAST(0xA5A304D5 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20616 AS Decimal(18, 0)), N'Guest', N'af722de6-bdc8-4dee-bd35-1f673b912f03', CAST(0xA5A304D7 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20617 AS Decimal(18, 0)), N'Guest', N'11a78952-0852-4fa1-9500-67b1d2f9886f', CAST(0xA5A304DA AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20618 AS Decimal(18, 0)), N'Guest', N'830a81d4-568a-4dff-9b97-9f3d28929ac7', CAST(0xA5A304DD AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20619 AS Decimal(18, 0)), N'Guest', N'da30d77f-ccfa-4929-a9e8-e83ab06a4c47', CAST(0xA5A40259 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20620 AS Decimal(18, 0)), N'Guest', N'2052da39-1411-4df1-8c14-1c36f914eaee', CAST(0xA5A4025B AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20621 AS Decimal(18, 0)), N'Guest', N'9ac4b667-9314-47b6-86a3-8eb37a288a7b', CAST(0xA5A4025E AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20622 AS Decimal(18, 0)), N'Guest', N'e5adf4a0-0d5c-4f58-bd18-5ec5947f8c44', CAST(0xA5A40260 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20623 AS Decimal(18, 0)), N'Guest', N'29a61296-6d96-4eee-b0d2-33f03ca05ded', CAST(0xA5A40261 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30449 AS Decimal(18, 0)), N'Guest', N'3c43603f-f68d-4cfc-891d-1c54d31a45de', CAST(0xA5B40366 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30459 AS Decimal(18, 0)), N'Guest', N'e54ded68-eba4-481c-a93d-11245317ccba', CAST(0xA5B60281 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30460 AS Decimal(18, 0)), N'Guest', N'c94dad9d-6748-42ec-86db-ed0e176ee415', CAST(0xA5B60284 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30461 AS Decimal(18, 0)), N'Guest', N'7fa3e577-8e19-4fd5-a65b-e3f0ec628593', CAST(0xA5B60284 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30462 AS Decimal(18, 0)), N'Guest', N'84ed98b1-e574-4e10-ba76-cd384b17f7b0', CAST(0xA5B60288 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30463 AS Decimal(18, 0)), N'Guest', N'1d4b85f3-a362-4f00-ac82-1f0f9069af83', CAST(0xA5B60289 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30464 AS Decimal(18, 0)), N'Guest', N'1e76585d-75e1-4c84-a08c-0b5869dc7cb0', CAST(0xA5B6028D AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30465 AS Decimal(18, 0)), N'Guest', N'441b4ba5-fa3b-44e1-9fe4-8f8c5c74650d', CAST(0xA5B60290 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30466 AS Decimal(18, 0)), N'Guest', N'c7595ffa-aefe-4cda-808e-77a35cedef56', CAST(0xA5B60291 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30467 AS Decimal(18, 0)), N'Guest', N'f2b228f1-dfc7-4efb-bab8-2daeaf3b2198', CAST(0xA5B60295 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30479 AS Decimal(18, 0)), N'Guest', N'91ac4c31-77e3-4c1a-99f9-d0c2b4e5a737', CAST(0xA5B602E5 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30480 AS Decimal(18, 0)), N'Guest', N'967ce37c-360b-45fa-86ee-b88e1e511061', CAST(0xA5B602E8 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30489 AS Decimal(18, 0)), N'Guest', N'5661f8ef-a507-4a51-8e17-6c242050476e', CAST(0xA5B60320 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30490 AS Decimal(18, 0)), N'Guest', N'65b23e67-434c-4c26-8b81-c53ddc99c5e6', CAST(0xA5B60336 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30502 AS Decimal(18, 0)), N'Guest', N'bdcda17a-d871-4eed-8eea-788dc3f9e6e6', CAST(0xA5B80310 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30503 AS Decimal(18, 0)), N'Guest', N'd0c77838-ea17-4bca-b2f6-1a5c63344f84', CAST(0xA5B8031C AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30504 AS Decimal(18, 0)), N'Guest', N'938fa7e7-0038-4dee-8210-f6a441faa0a1', CAST(0xA5B8031D AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30505 AS Decimal(18, 0)), N'Guest', N'91af0678-8d9b-4044-9264-8aee298ab427', CAST(0xA5B8031F AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30506 AS Decimal(18, 0)), N'Guest', N'24265310-6c8b-4d73-aca8-8698ad336d64', CAST(0xA5B80322 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30507 AS Decimal(18, 0)), N'Guest', N'45c17c9b-84ef-406d-b326-8aeaa37a13a2', CAST(0xA5B80323 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30508 AS Decimal(18, 0)), N'Guest', N'60a2cb7c-8b88-47ff-915b-7e153d4fc564', CAST(0xA5B8032A AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30509 AS Decimal(18, 0)), N'Guest', N'06f07e93-562a-44af-8f7d-b953682f0e6d', CAST(0xA5B8032B AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30510 AS Decimal(18, 0)), N'Guest', N'4a4f1cd3-9b22-4926-9c81-cf26315c4eaa', CAST(0xA5B8032D AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30511 AS Decimal(18, 0)), N'Guest', N'7a790387-0834-445e-a402-09a9776c712f', CAST(0xA5B8032E AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30512 AS Decimal(18, 0)), N'Guest', N'7474c776-6bbe-4bf9-9b6d-458b4ca74717', CAST(0xA5B80335 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30513 AS Decimal(18, 0)), N'Guest', N'56c5c175-8a0e-4878-9861-2dd815fc31df', CAST(0xA5B80336 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30514 AS Decimal(18, 0)), N'Guest', N'ce20e93f-6856-47b9-a768-89537c893205', CAST(0xA5B80337 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30515 AS Decimal(18, 0)), N'Guest', N'1d2127e3-73e4-4113-8095-a2999c98278d', CAST(0xA5B80339 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30516 AS Decimal(18, 0)), N'Guest', N'f267ac3e-f4e5-4078-8a76-831baaa90516', CAST(0xA5B8033A AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30517 AS Decimal(18, 0)), N'Guest', N'a9965c09-de8b-4450-8a97-b968bf8d56ce', CAST(0xA5B8033E AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30518 AS Decimal(18, 0)), N'Guest', N'018bf301-79da-4006-9bd5-cf28ee78a346', CAST(0xA5B8033F AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30519 AS Decimal(18, 0)), N'Guest', N'4b13cfb7-97df-46e5-8074-47fd46040a13', CAST(0xA5B80342 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30520 AS Decimal(18, 0)), N'Guest', N'2fbb5344-c057-452f-b58e-fbd113a9143c', CAST(0xA5B80345 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30530 AS Decimal(18, 0)), N'Guest', N'0ca07e56-4892-4578-815e-8301a42676cd', CAST(0xA5BB033D AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30531 AS Decimal(18, 0)), N'Guest', N'ffc9aae8-581c-447c-a169-798f6b8f9309', CAST(0xA5BB033E AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30532 AS Decimal(18, 0)), N'Guest', N'47850994-587d-4c70-a6d6-1b2b3a414c57', CAST(0xA5BB0340 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30533 AS Decimal(18, 0)), N'Guest', N'6f50bd9f-0668-402b-bed1-14017cd40b43', CAST(0xA5BB0342 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30534 AS Decimal(18, 0)), N'Guest', N'28f75e37-622d-48fc-b215-2e111b944492', CAST(0xA5BB0346 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30535 AS Decimal(18, 0)), N'Guest', N'185f340b-5e5e-4b28-8159-b775ee219abb', CAST(0xA5BB0348 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30536 AS Decimal(18, 0)), N'Guest', N'c962182c-0868-4ede-92de-963cb00f39ba', CAST(0xA5BB034A AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30537 AS Decimal(18, 0)), N'Guest', N'eb86be18-1587-4549-b1b9-c3744615e0ce', CAST(0xA5BB034B AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30538 AS Decimal(18, 0)), N'Guest', N'0d977fb8-411c-4271-b0d6-3ce2c9c1cb21', CAST(0xA5BB034D AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30539 AS Decimal(18, 0)), N'Guest', N'46084c26-2077-44cd-b6b6-8190484ab056', CAST(0xA5BB0350 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30540 AS Decimal(18, 0)), N'Guest', N'15417d5e-148f-44f0-8db2-73c2b55d82dd', CAST(0xA5BB0352 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30541 AS Decimal(18, 0)), N'Guest', N'3826969d-d262-4694-865a-b1a46bf988ff', CAST(0xA5BB0352 AS SmallDateTime))
GO
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30542 AS Decimal(18, 0)), N'Guest', N'51d65327-ce5a-49ed-9351-8ca9e12ed355', CAST(0xA5BB0353 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30543 AS Decimal(18, 0)), N'Guest', N'2e2f0a90-6ec0-4def-a712-75658b6efef1', CAST(0xA5BB0355 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30544 AS Decimal(18, 0)), N'Guest', N'9ca3a1eb-637e-4e73-90c8-05ccd088347e', CAST(0xA5BB0355 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30545 AS Decimal(18, 0)), N'Guest', N'37cdef2f-a58b-4b15-b6b4-da32c77e6651', CAST(0xA5BB0356 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30546 AS Decimal(18, 0)), N'Guest', N'a515e3d0-f2db-4eb5-966e-0cf25c397969', CAST(0xA5BB0358 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30547 AS Decimal(18, 0)), N'Guest', N'c23db6d5-cbf7-4be9-afb4-4197bc95c614', CAST(0xA5BB035D AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30548 AS Decimal(18, 0)), N'Guest', N'c0dc2fbc-75ef-433c-a7fd-2ab18da296ca', CAST(0xA5BB0366 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30549 AS Decimal(18, 0)), N'Guest', N'b2241b2c-a4ee-48d1-a3e8-07c3b1349796', CAST(0xA5BB0369 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30550 AS Decimal(18, 0)), N'Guest', N'd3f81d69-d163-4377-9781-eb5729a0518f', CAST(0xA5BB036D AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30551 AS Decimal(18, 0)), N'Guest', N'57e048c1-ca65-4e52-b16a-6ef84ab53e82', CAST(0xA5BB0371 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30552 AS Decimal(18, 0)), N'Guest', N'3bdfef63-8207-437c-9930-6a757bd317bf', CAST(0xA5BB0373 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30553 AS Decimal(18, 0)), N'Guest', N'7cdf85ee-3909-47b5-ace0-f0cb294693cb', CAST(0xA5BB0376 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30554 AS Decimal(18, 0)), N'Guest', N'af419206-27f6-40f4-bc02-2b5ae035d508', CAST(0xA5BB0377 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30555 AS Decimal(18, 0)), N'Guest', N'75f87129-6a34-42da-8cb9-062b78447182', CAST(0xA5BB0378 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30556 AS Decimal(18, 0)), N'Guest', N'f64facfd-36b4-41ce-a30c-7bb97626a850', CAST(0xA5BB0379 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30557 AS Decimal(18, 0)), N'Guest', N'4ccd1a80-aea8-418a-aa78-7ac673f67c61', CAST(0xA5BB037E AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30558 AS Decimal(18, 0)), N'Guest', N'37d2e859-65b6-4604-8dfc-6f7c4226d3b8', CAST(0xA5BB037F AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30559 AS Decimal(18, 0)), N'Guest', N'19cf0abc-662d-464d-b463-8a3132cfc05d', CAST(0xA5BB0380 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30560 AS Decimal(18, 0)), N'Guest', N'9a62d8ff-7695-4b4b-b7a8-64087355e6b7', CAST(0xA5BB0381 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30561 AS Decimal(18, 0)), N'Guest', N'68813e85-47cd-431b-af16-989a6f2f8018', CAST(0xA5BB0382 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30562 AS Decimal(18, 0)), N'Guest', N'be50e82f-b8a0-4008-beae-666e9a27bc04', CAST(0xA5BB0383 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10356 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'3822a8c0-c4e0-4933-9acc-5bf10d2751af', NULL)
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10357 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'1dc82e1b-7c70-4544-9019-76e543662bd7', NULL)
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10358 AS Decimal(18, 0)), N'Guest', N'45802f7d-750e-454a-9620-bcc7bcd3e1f4', NULL)
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10359 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'875dec72-e261-4509-a3a5-20d6c13e2a04', NULL)
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10360 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'bf5fcaf2-5312-4599-93d9-f789eeea1490', NULL)
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10361 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'a06e6958-b70e-4b23-bdf4-010ef23f09f1', NULL)
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10362 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'cfb766b8-5d3b-4dfa-8418-629478257322', NULL)
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10363 AS Decimal(18, 0)), N'testermeagain@testermeagain.com', N'36155a4e-5133-413a-b5bc-76f65e405201', NULL)
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10368 AS Decimal(18, 0)), N'UmartaxUmartax@UmartaxUmartax.com', N'977cd740-c7c2-4206-99be-005dcfee552f', NULL)
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10369 AS Decimal(18, 0)), N'UmartaxUmartax@UmartaxUmartax.com', N'45b08119-965b-47fd-aeb3-50e02ddb22bd', NULL)
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10370 AS Decimal(18, 0)), N'Guest', N'950a21d1-fed3-4855-8ef3-0a0fb58c4994', NULL)
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10371 AS Decimal(18, 0)), N'Shewhomustbeobeyed@Shewhomustbeobeyed.com', N'82ef20e2-0169-48a2-9f63-fadfbe35d290', NULL)
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30574 AS Decimal(18, 0)), N'Guest', N'23ddefdb-c06e-41fb-bcd7-47e8010c764d', CAST(0xA5BD0233 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30575 AS Decimal(18, 0)), N'Guest', N'7daf29b8-bd00-4860-8ed2-f8e1e93d6117', CAST(0xA5BD0233 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30576 AS Decimal(18, 0)), N'Guest', N'b1cc0949-dad3-423f-a70e-7a617a95b791', CAST(0xA5BD0235 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30577 AS Decimal(18, 0)), N'Guest', N'f1b70a2b-5a6e-4403-a004-df4f1e28145a', CAST(0xA5BD0238 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30578 AS Decimal(18, 0)), N'Guest', N'756f6d3e-d84e-42e8-81ac-c603bc16aedb', CAST(0xA5BD0239 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30579 AS Decimal(18, 0)), N'Guest', N'56c8253d-0f08-4abe-8a79-5b9c9e46feed', CAST(0xA5BD023B AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30580 AS Decimal(18, 0)), N'Guest', N'e2396197-551c-4a5f-8b7c-9784f59c6622', CAST(0xA5BD023C AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30581 AS Decimal(18, 0)), N'Guest', N'e2a38e09-2c05-42a4-9970-73e22328430c', CAST(0xA5BD023F AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30582 AS Decimal(18, 0)), N'Guest', N'959ab839-f06d-4d46-9845-987e84644b4f', CAST(0xA5BD0240 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30583 AS Decimal(18, 0)), N'Guest', N'f284c40b-4e48-4d7f-881b-b9517d2eb6df', CAST(0xA5BD0242 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30584 AS Decimal(18, 0)), N'Guest', N'16263a81-42e9-4c3f-847e-4a011a1215b1', CAST(0xA5BD0243 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30585 AS Decimal(18, 0)), N'Guest', N'9389bcf4-6490-4298-9b09-56da838d7479', CAST(0xA5BD0244 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30586 AS Decimal(18, 0)), N'Guest', N'b2a9df48-db6d-4fb8-b400-c9185d23a1c7', CAST(0xA5BD0246 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30587 AS Decimal(18, 0)), N'Guest', N'9b4b6a34-044b-4d82-90a6-78569e7902e3', CAST(0xA5BD024B AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30628 AS Decimal(18, 0)), N'Guest', N'44a36226-bf36-460a-90b7-9e4f0cc018d8', CAST(0xA5BD02B5 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30629 AS Decimal(18, 0)), N'Guest', N'334dc610-3612-4a87-9591-b33594ad8a1b', CAST(0xA5BD02B7 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30630 AS Decimal(18, 0)), N'Guest', N'951cfd68-cc6a-4635-85f7-e2bbb5460ace', CAST(0xA5BD02B8 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30631 AS Decimal(18, 0)), N'Guest', N'51e65e48-4fc3-435a-96f1-12ad3aec732b', CAST(0xA5BD02B9 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30632 AS Decimal(18, 0)), N'Guest', N'2b0ea46b-ba55-4ab4-9bb1-a3f843241e1e', CAST(0xA5BD02BA AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30633 AS Decimal(18, 0)), N'Guest', N'0d05929f-b6f8-465d-8c11-83a2ecd4a98a', CAST(0xA5BD02BF AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30634 AS Decimal(18, 0)), N'Guest', N'93bdabd9-1155-41df-845b-53d020b56af9', CAST(0xA5BD02C0 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30644 AS Decimal(18, 0)), N'Guest', N'b826e4e4-9d77-44d5-af85-1871b1374a7a', CAST(0xA5BD034B AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30645 AS Decimal(18, 0)), N'Guest', N'835e3e95-0cfe-4e20-aa29-9b4b7ef1bf56', CAST(0xA5BD034B AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30646 AS Decimal(18, 0)), N'Guest', N'80162147-22fb-4b33-b662-be12c537e553', CAST(0xA5BD034C AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30647 AS Decimal(18, 0)), N'Guest', N'98e2b6b2-bdf5-4aca-b86c-172e6bffed49', CAST(0xA5BD034D AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30648 AS Decimal(18, 0)), N'Guest', N'2455fffa-d37b-49df-997b-cd1827fc975c', CAST(0xA5BD034E AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30649 AS Decimal(18, 0)), N'Guest', N'41810133-ee64-4b54-b7bb-27eead924a96', CAST(0xA5BD0350 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30680 AS Decimal(18, 0)), N'Guest', N'340eb567-4e59-403b-ba46-9f1a7a8c94ac', CAST(0xA5BE0268 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30681 AS Decimal(18, 0)), N'Guest', N'85298a12-94cb-43ed-9712-109bc5973515', CAST(0xA5BE0269 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30682 AS Decimal(18, 0)), N'Guest', N'27e76155-4a2c-4cf9-b4a8-033a758e2c28', CAST(0xA5BE026A AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30683 AS Decimal(18, 0)), N'Guest', N'e6d24e7d-6377-4885-9b53-5ddaa9608c1b', CAST(0xA5BE026B AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30684 AS Decimal(18, 0)), N'Guest', N'97d730ab-aed1-4a7b-a5a8-85c096be0fed', CAST(0xA5BE026D AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30685 AS Decimal(18, 0)), N'Guest', N'5cfdce38-fbc6-4d52-9bf4-8637d4bb49b7', CAST(0xA5BE026E AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30686 AS Decimal(18, 0)), N'Guest', N'365f0775-d806-482a-8acc-af3e0b926da4', CAST(0xA5BE026F AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30687 AS Decimal(18, 0)), N'Guest', N'9310409a-bbaf-4fdc-ab77-81f966fecdf3', CAST(0xA5BE0271 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30688 AS Decimal(18, 0)), N'Guest', N'24376aed-37de-4561-9d19-724d25372908', CAST(0xA5BE0272 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30689 AS Decimal(18, 0)), N'Guest', N'6f9d97fe-b458-4a8b-99e3-d1b7c4cd0e78', CAST(0xA5BE0275 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30690 AS Decimal(18, 0)), N'Guest', N'efe5c00b-2e61-4f46-814f-15cc31c96c55', CAST(0xA5BE0276 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30733 AS Decimal(18, 0)), N'Guest', N'4c267222-c77d-4220-8609-74c33ca713d1', CAST(0xA5BF028D AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30734 AS Decimal(18, 0)), N'Guest', N'c5dd9ee7-9e1a-4d6b-bd4b-f050e859b990', CAST(0xA5BF028E AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30735 AS Decimal(18, 0)), N'Guest', N'56090918-ae1a-4d3e-a54a-1fc597cacb3b', CAST(0xA5BF0290 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30736 AS Decimal(18, 0)), N'Guest', N'422e4176-9010-43a9-bd99-e091b4fedb55', CAST(0xA5BF0292 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30737 AS Decimal(18, 0)), N'Guest', N'83931013-29a0-414a-a2e6-d8d33ebf8228', CAST(0xA5BF0294 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30738 AS Decimal(18, 0)), N'Guest', N'07000bd1-6ff6-4289-b736-53a7714a140f', CAST(0xA5BF0294 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30749 AS Decimal(18, 0)), N'Guest', N'5f59d60a-35b2-4750-ac9f-b7740322098b', CAST(0xA6040368 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30750 AS Decimal(18, 0)), N'Guest', N'00faf049-2f97-4bf4-9826-41325dfbc973', CAST(0xA6090451 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(40749 AS Decimal(18, 0)), N'Guest', N'd38ebfa6-ebb4-4d1d-9c6c-bfc50f40ec8d', CAST(0xA61D02C8 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(40750 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'97806656-029e-48cc-8178-375c7463b24d', CAST(0xA6610393 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(40751 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'0cd3e521-254e-4141-9170-6b9709294803', CAST(0xA66103B1 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(40754 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'a80775fe-7096-463c-9a2c-ab3dc126f415', CAST(0xA66103D5 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(40755 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'd4cf0bc7-5107-49b0-95ad-c727c604aef0', CAST(0xA66103E7 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(40757 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'a7d62f15-19d3-450b-8494-989b5550fc1c', CAST(0xA66403EE AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(40758 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'b32a4b90-c4d6-40b7-8152-2fb4e73566e1', CAST(0xA664040E AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(40759 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'70c22b85-25e8-4c2c-8689-354f26d9d800', CAST(0xA6640412 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(40760 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'8dae8156-6a57-4fa7-8cd7-9948ac4ae371', CAST(0xA6640419 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(40761 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'0efb805a-cf0b-4fb7-b122-ac1d3e9a839d', CAST(0xA664041D AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(40762 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'ad5e97aa-a1f4-4a30-9e25-b0d90113a4c8', CAST(0xA6640471 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(40764 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'256d79a3-b545-4ed9-936b-24c349955b84', CAST(0xA6640485 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(40765 AS Decimal(18, 0)), N'Guest', N'007a5d2e-8116-4811-b0cd-2e08c518c4d9', CAST(0xA66404A5 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(40766 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'8271b38e-99b3-4132-910d-a97b1a1beb4f', CAST(0xA66404A9 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(40767 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'a0f12a7c-ca42-46ea-a29a-eb7e2319e43c', CAST(0xA66404CC AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(40769 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'c0a8a20f-136e-4e05-951d-cd4d4a0a063c', CAST(0xA676053E AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(40770 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'a01439a5-b079-465f-b7c9-d6014209252c', CAST(0xA67703AE AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10389 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'2ee67f81-9481-407c-bf12-498a07c4fa43', CAST(0xA56903A6 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20512 AS Decimal(18, 0)), N'Guest', N'c475f895-55a5-4f77-b9f2-c2b2bd35bc0e', CAST(0xA5A20369 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20513 AS Decimal(18, 0)), N'Guest', N'a0753a9a-8871-405b-9265-ad10b0defd4a', CAST(0xA5A2036A AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20514 AS Decimal(18, 0)), N'Guest', N'3060d52d-b171-4e6e-a549-9842e0122ee0', CAST(0xA5A2036B AS SmallDateTime))
GO
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20515 AS Decimal(18, 0)), N'Guest', N'954e0201-cdcd-47ba-b4b5-7ae2b5506e1c', CAST(0xA5A2036C AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20532 AS Decimal(18, 0)), N'Guest', N'856e9fbe-a8bd-4595-9925-232a0333cb29', CAST(0xA5A204AA AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20552 AS Decimal(18, 0)), N'Guest', N'4644e561-dc98-42b4-a84c-a5f2384809cc', CAST(0xA5A302E9 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20553 AS Decimal(18, 0)), N'Guest', N'c8728ac6-d60b-4571-a43f-078efdf838e9', CAST(0xA5A302EC AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30450 AS Decimal(18, 0)), N'Guest', N'98cf502c-17f8-4c14-b12f-ab786db229dd', CAST(0xA5B40382 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30451 AS Decimal(18, 0)), N'Guest', N'c44d6985-138a-492c-a448-3bcbd4a63a68', CAST(0xA5B40389 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30452 AS Decimal(18, 0)), N'Guest', N'f6d6c832-783e-412a-a678-405ebe3b191e', CAST(0xA5B40391 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30453 AS Decimal(18, 0)), N'Guest', N'99ba5ab6-590f-489b-9163-831d1c726819', CAST(0xA5B40393 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30454 AS Decimal(18, 0)), N'Guest', N'b2df406e-402a-499c-a17b-c1b18f7e1a94', CAST(0xA5B40394 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30455 AS Decimal(18, 0)), N'Guest', N'020fba3e-b6c6-4da6-abca-3b95192dbaa4', CAST(0xA5B40460 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30456 AS Decimal(18, 0)), N'Guest', N'6fb347c4-9c29-4572-bf01-e42c53e8420a', CAST(0xA5B40463 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30457 AS Decimal(18, 0)), N'Guest', N'8384beb7-b142-45c5-a94c-23293e360c8d', CAST(0xA5B40464 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30458 AS Decimal(18, 0)), N'Guest', N'5506f00c-0c89-4d74-93f5-b1e765fcdde8', CAST(0xA5B40468 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30487 AS Decimal(18, 0)), N'Guest', N'ed02ccc6-85e4-4b37-888b-791002cfe92c', CAST(0xA5B60311 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30488 AS Decimal(18, 0)), N'Guest', N'e09aab7a-7e68-4fcd-b271-67fa186df1bf', CAST(0xA5B60313 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30491 AS Decimal(18, 0)), N'Guest', N'70ab5cd3-d0db-4124-a707-43d179267245', CAST(0xA5B80245 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30492 AS Decimal(18, 0)), N'Guest', N'73641be7-8d3d-4f99-a046-ae22198eef65', CAST(0xA5B8024C AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30493 AS Decimal(18, 0)), N'Guest', N'7a95a9d1-b81f-41f5-b0e0-61790179de82', CAST(0xA5B8024E AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30494 AS Decimal(18, 0)), N'Guest', N'c87685de-7b71-4b81-9f4e-0818f7607ad0', CAST(0xA5B80258 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30495 AS Decimal(18, 0)), N'Guest', N'd0d8d3b9-db34-4501-88d6-723e9f01bd41', CAST(0xA5B8025F AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30496 AS Decimal(18, 0)), N'Guest', N'65ecdd3c-385f-48a5-b98e-3c8faf4ee4ad', CAST(0xA5B8026B AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30497 AS Decimal(18, 0)), N'Guest', N'de160034-3486-4b71-956c-45e45a91d01d', CAST(0xA5B8027F AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30498 AS Decimal(18, 0)), N'Guest', N'9f35ee9a-fc54-499e-a0be-e027933fb7cb', CAST(0xA5B80285 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30499 AS Decimal(18, 0)), N'Guest', N'bbd8401d-b9d6-49a7-8d3a-667bdf9cc621', CAST(0xA5B80302 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30500 AS Decimal(18, 0)), N'Guest', N'69f9f829-f37f-4ec9-ad67-b39366429d95', CAST(0xA5B80305 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30501 AS Decimal(18, 0)), N'Guest', N'14ffa38d-16aa-4e09-a51d-07702232068e', CAST(0xA5B80305 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30521 AS Decimal(18, 0)), N'Guest', N'ad4365ad-4e51-4551-9f60-5a711c06b69d', CAST(0xA5B8034A AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30522 AS Decimal(18, 0)), N'Guest', N'2a0bc65b-e991-42bf-8e96-4127ce5a2a16', CAST(0xA5B80350 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30565 AS Decimal(18, 0)), N'Guest', N'75626b9b-7249-4961-8fe1-4d386089b42f', CAST(0xA5BB0387 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30566 AS Decimal(18, 0)), N'Guest', N'd928cd45-fb82-4e57-822e-0c6f890d75cf', CAST(0xA5BB0388 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30567 AS Decimal(18, 0)), N'Guest', N'e793235b-4e96-4552-b137-877100211ed8', CAST(0xA5BB0389 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30568 AS Decimal(18, 0)), N'Guest', N'79b4f885-79dd-4517-b76e-04931e95eb82', CAST(0xA5BB038C AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30569 AS Decimal(18, 0)), N'Guest', N'851decc8-c160-4539-a775-bfe174c4d20f', CAST(0xA5BB038D AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30570 AS Decimal(18, 0)), N'Guest', N'27f49a4b-b2fc-43ad-a875-0dac2967adca', CAST(0xA5BB038E AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30571 AS Decimal(18, 0)), N'Guest', N'c09286b6-3db1-4276-8536-7a227bc2fa38', CAST(0xA5BB038F AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30572 AS Decimal(18, 0)), N'Guest', N'd53658e0-c5f0-4e64-a462-5c379d073833', CAST(0xA5BB0391 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30573 AS Decimal(18, 0)), N'Guest', N'932dd955-c5f7-4c30-b101-9db0affbb9ba', CAST(0xA5BB0393 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30588 AS Decimal(18, 0)), N'Guest', N'14992b51-b650-4582-8b83-ccbaf316394c', CAST(0xA5BD0255 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30674 AS Decimal(18, 0)), N'Guest', N'ccdc1879-3461-4574-8264-dde571bc4aa3', CAST(0xA5BD0392 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30675 AS Decimal(18, 0)), N'Guest', N'ba033f99-916b-4f8f-9e23-605129ff52c2', CAST(0xA5BD0393 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30676 AS Decimal(18, 0)), N'Guest', N'ebfbf8d8-7981-4e50-9430-4f2b855edd13', CAST(0xA5BD0394 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30677 AS Decimal(18, 0)), N'Guest', N'21a18363-4bd9-4fc1-b560-d5eb4729b4d3', CAST(0xA5BD0395 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30678 AS Decimal(18, 0)), N'Guest', N'bd76b4bf-0fb4-4a10-80a1-9bb97891610c', CAST(0xA5BD0396 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30679 AS Decimal(18, 0)), N'Guest', N'b7af87b1-7469-4ad6-b84b-a54b24d13583', CAST(0xA5BD0397 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(40753 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'04ebfe0c-e0f7-4d55-b7d9-e6dc9b9a50bf', CAST(0xA66103C3 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(40763 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'e6e081ab-a0a1-4e86-a7b8-f4f625b3b174', CAST(0xA664047A AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10372 AS Decimal(18, 0)), N'Guest', N'aad5faf8-36cd-4a98-acf7-66d714ed583a', NULL)
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10373 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'1d41dc63-6dc0-4b9f-aa35-14e786254979', NULL)
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10374 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'46bf8bb4-1f35-4b9a-b110-112dd3b280f9', NULL)
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10375 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'51aedaee-0954-46a3-8bba-7c3e2dd4f21a', NULL)
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10376 AS Decimal(18, 0)), N'continuetester@continuetester.com', N'72f66c2d-e853-47e9-8d26-fed00787d965', NULL)
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10377 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'877f527a-a6cf-4947-acb8-7e617cbdba43', CAST(0xA5680544 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20454 AS Decimal(18, 0)), N'Guest', N'1ff70468-61bb-43c7-9d09-5cf7fd0d9ed5', CAST(0xA5A20268 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20551 AS Decimal(18, 0)), N'Guest', N'29c5ab06-7853-4718-b762-cf45051e8a0c', CAST(0xA5A302E2 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20554 AS Decimal(18, 0)), N'Guest', N'236c9e58-dcb9-455e-a3b0-e143415f8be5', CAST(0xA5A30313 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20555 AS Decimal(18, 0)), N'Guest', N'90ae2e2b-edee-4cba-9d00-4a570459091e', CAST(0xA5A30318 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20556 AS Decimal(18, 0)), N'Guest', N'00cbab63-c038-46b8-9dc2-7a0dde07a7b0', CAST(0xA5A3031F AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20559 AS Decimal(18, 0)), N'Guest', N'50b45e99-2aa6-4762-bf9b-67e050983054', CAST(0xA5A30341 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20560 AS Decimal(18, 0)), N'Guest', N'5db65c1b-486f-4d95-81f7-b9d91141b418', CAST(0xA5A30343 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20561 AS Decimal(18, 0)), N'Guest', N'2c66720e-f07e-41e8-b0a7-fc7929c0c981', CAST(0xA5A30347 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20562 AS Decimal(18, 0)), N'Guest', N'9f08e80e-c0d9-4277-9d3e-73392dc69509', CAST(0xA5A30349 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20563 AS Decimal(18, 0)), N'Guest', N'dd0b839a-83a6-4c13-8e67-47d288fdd97f', CAST(0xA5A30350 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20564 AS Decimal(18, 0)), N'Guest', N'bed3130d-1a24-40ea-9118-b3bb38db0508', CAST(0xA5A30354 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20565 AS Decimal(18, 0)), N'Guest', N'b677417b-2524-4831-a66a-52b7980e4fc3', CAST(0xA5A30357 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20566 AS Decimal(18, 0)), N'Guest', N'75ca56c3-bb24-4761-9907-8e3cd4f988b6', CAST(0xA5A30358 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20567 AS Decimal(18, 0)), N'Guest', N'23245a3e-31b3-4327-83a5-277d38fc6a34', CAST(0xA5A30359 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20568 AS Decimal(18, 0)), N'Guest', N'1637fa44-62d3-4a23-904b-4fa5fa893f28', CAST(0xA5A3035B AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20569 AS Decimal(18, 0)), N'Guest', N'3e7d2199-dcd9-472d-9145-0ba4ae7f0a00', CAST(0xA5A3035C AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20570 AS Decimal(18, 0)), N'Guest', N'109122ee-9add-4271-9a1b-0913740f0a6a', CAST(0xA5A3035D AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20571 AS Decimal(18, 0)), N'Guest', N'f002c61f-c6d7-447e-8314-369c62fa8368', CAST(0xA5A303F6 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20572 AS Decimal(18, 0)), N'Guest', N'b7a2e968-8b17-4842-8510-628e028ac9ff', CAST(0xA5A303F8 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20573 AS Decimal(18, 0)), N'Guest', N'776645f7-103a-4c68-aa10-46837ed4e2e6', CAST(0xA5A303F9 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20574 AS Decimal(18, 0)), N'Guest', N'83e38ef4-0c05-43d4-a0f4-e58d4cff61c7', CAST(0xA5A303FA AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20575 AS Decimal(18, 0)), N'Guest', N'69ccbc37-a7f8-4e07-ba04-f0f56f28f98d', CAST(0xA5A303FC AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20576 AS Decimal(18, 0)), N'Guest', N'300eeb02-0000-405e-8ca5-44090953960f', CAST(0xA5A303FD AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20577 AS Decimal(18, 0)), N'Guest', N'36a4d727-cd7b-474f-b7e4-b8f2c2feb5a4', CAST(0xA5A303FE AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20578 AS Decimal(18, 0)), N'Guest', N'7c977346-81a9-4ee4-b75b-e8b8ae867937', CAST(0xA5A303FF AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20579 AS Decimal(18, 0)), N'Guest', N'faae9811-3ac3-41e3-b737-9c08a0b2d2ce', CAST(0xA5A30400 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20580 AS Decimal(18, 0)), N'Guest', N'4a626488-ebb6-48cb-8d09-cb382613d122', CAST(0xA5A30402 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20581 AS Decimal(18, 0)), N'Guest', N'cc67681a-3591-4f26-885c-2b7400820763', CAST(0xA5A30402 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20582 AS Decimal(18, 0)), N'Guest', N'8cf9379c-33cc-4276-92d4-65ea5644fe91', CAST(0xA5A30403 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20583 AS Decimal(18, 0)), N'Guest', N'31cb8d9b-d650-419f-860c-29474e18de82', CAST(0xA5A30404 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20584 AS Decimal(18, 0)), N'Guest', N'9ae1da5c-becc-4537-a8ff-a3d729c2de4d', CAST(0xA5A30408 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20585 AS Decimal(18, 0)), N'Guest', N'3ce077b7-aeec-42d8-97dd-7fd313841bd6', CAST(0xA5A30409 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20586 AS Decimal(18, 0)), N'Guest', N'ab30f8e4-0313-47d6-a02e-43c0761bb10b', CAST(0xA5A3040A AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20587 AS Decimal(18, 0)), N'Guest', N'd0e8e09f-f8e7-4b1a-bce3-75501602aaa4', CAST(0xA5A3040F AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20588 AS Decimal(18, 0)), N'Guest', N'03410ac4-4d97-4afb-be58-485fa2a36e80', CAST(0xA5A30411 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20589 AS Decimal(18, 0)), N'Guest', N'c798a668-c8a9-4e86-b7ba-5acb2c653638', CAST(0xA5A30412 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20590 AS Decimal(18, 0)), N'Guest', N'27369de7-0ac7-45d3-a419-9ac4f326eefa', CAST(0xA5A30413 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20591 AS Decimal(18, 0)), N'Guest', N'360e5d8f-551a-42b2-bbb3-10e23b44c175', CAST(0xA5A30414 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20592 AS Decimal(18, 0)), N'Guest', N'd7e6b3ca-70db-4e54-b80d-7a4b7e25294b', CAST(0xA5A30415 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20593 AS Decimal(18, 0)), N'Guest', N'8d0a903a-1e2e-4caa-8e79-1373e83c0d8c', CAST(0xA5A30415 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20594 AS Decimal(18, 0)), N'Guest', N'2b58e558-c864-4731-a0ee-69684a204314', CAST(0xA5A30418 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20595 AS Decimal(18, 0)), N'Guest', N'dda50afa-cbb8-4f7a-9303-b18802772a8a', CAST(0xA5A3041A AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20596 AS Decimal(18, 0)), N'Guest', N'466e3ea8-1d52-45b5-ad3a-5a93daaeaca9', CAST(0xA5A3041B AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20597 AS Decimal(18, 0)), N'Guest', N'a893abf0-f3a6-4566-a907-b6ea0eedb02b', CAST(0xA5A3041C AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20598 AS Decimal(18, 0)), N'Guest', N'61aa1baa-b050-4292-a0f4-2769a0875e9d', CAST(0xA5A3041E AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20599 AS Decimal(18, 0)), N'Guest', N'a6de6191-6cbe-4e9f-9c42-276a0b4d4c94', CAST(0xA5A30421 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20600 AS Decimal(18, 0)), N'Guest', N'44193baf-cf45-463b-a1ff-a58cf24e231f', CAST(0xA5A30424 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20601 AS Decimal(18, 0)), N'Guest', N'a20a827d-fa38-4e70-98f2-c8428c552c9d', CAST(0xA5A30425 AS SmallDateTime))
GO
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20603 AS Decimal(18, 0)), N'Guest', N'2ffc7a4b-6c42-4f0e-be43-e45f9fd76633', CAST(0xA5A30460 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20604 AS Decimal(18, 0)), N'Guest', N'db56cc6b-0161-49a4-9cf1-e741ec33ee4a', CAST(0xA5A30463 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20605 AS Decimal(18, 0)), N'Guest', N'63d24aef-d0c5-4281-ac8e-8c014a12c8de', CAST(0xA5A30465 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20606 AS Decimal(18, 0)), N'Guest', N'533acd5f-9c23-4aeb-bba8-e1fff9435ff4', CAST(0xA5A30469 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20607 AS Decimal(18, 0)), N'Guest', N'c484ba3c-5415-4208-8457-d12e7307b93c', CAST(0xA5A3046A AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20612 AS Decimal(18, 0)), N'Guest', N'454ff680-fc17-4704-8ac2-f7796c527119', CAST(0xA5A30494 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20613 AS Decimal(18, 0)), N'Guest', N'4eaf8dfb-7a81-4aaa-a106-630ccf3971c0', CAST(0xA5A3049C AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(40756 AS Decimal(18, 0)), N'Guest', N'a459e73a-fd0f-4e27-b643-aadb694ae57a', CAST(0xA66203E7 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30473 AS Decimal(18, 0)), N'Guest', N'0f900721-d293-4b3c-b960-edf952b64daa', CAST(0xA5B602C6 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30474 AS Decimal(18, 0)), N'Guest', N'5434676f-eb5b-43a0-9c77-3fac2a058065', CAST(0xA5B602C7 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10414 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'e95dc5e2-90f9-404f-a973-789aa3f88a33', CAST(0xA56A0220 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10415 AS Decimal(18, 0)), N'Guest', N'b58eeb6b-cb15-4b7e-93ba-6d97ae4dfb7d', CAST(0xA5990283 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10416 AS Decimal(18, 0)), N'Guest', N'306a1a99-16a8-4c8a-995c-5757ad7d7d49', CAST(0xA59902CB AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10417 AS Decimal(18, 0)), N'Guest', N'63ac8bf6-45e9-49a8-9998-ab813737eda6', CAST(0xA59902CF AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10418 AS Decimal(18, 0)), N'Guest', N'c3e43a77-0196-461b-8760-d9ea594b272d', CAST(0xA59902E2 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10419 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'e5e69d14-3d54-4274-be30-fb32eefd9cf0', CAST(0xA59B02D2 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10421 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'fe4b8f1f-c28a-4f22-baf4-0be6f18466ff', CAST(0xA59B02ED AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(10422 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'2ef86d9b-ba76-41f2-b9ed-c4e946bc6257', CAST(0xA59B0330 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(40752 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'90493a47-3157-42a6-9b27-639181f8188c', CAST(0xA66103BA AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20481 AS Decimal(18, 0)), N'Guest', N'b1d7e641-1f84-4d4c-b935-af14cfbd49a5', CAST(0xA5A202C8 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20482 AS Decimal(18, 0)), N'Guest', N'e8e5ea14-8d3f-4dec-aac6-555cd7bf625a', CAST(0xA5A202C8 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20483 AS Decimal(18, 0)), N'Guest', N'528925eb-ec36-4d45-9908-d25d704b0041', CAST(0xA5A202CA AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20484 AS Decimal(18, 0)), N'Guest', N'32ad3732-5a27-4b33-ab0c-6e9560287f2d', CAST(0xA5A202CB AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20485 AS Decimal(18, 0)), N'Guest', N'7a7f7823-9e87-497a-b885-90a2bfc76012', CAST(0xA5A202CB AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20486 AS Decimal(18, 0)), N'Guest', N'ad4e144c-2637-4ad0-91a4-458dfd5a551e', CAST(0xA5A202CB AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20487 AS Decimal(18, 0)), N'Guest', N'541de53f-7862-42ff-aaf6-d74635e46695', CAST(0xA5A202D0 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20488 AS Decimal(18, 0)), N'Guest', N'f7d60ec7-e291-4b38-9222-89a2057d66be', CAST(0xA5A202D0 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20489 AS Decimal(18, 0)), N'Guest', N'81b2d5a6-416a-4045-a141-1a6e75489767', CAST(0xA5A202D1 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20490 AS Decimal(18, 0)), N'Guest', N'329abe98-239f-4c0d-8905-b570d928d277', CAST(0xA5A202D1 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20503 AS Decimal(18, 0)), N'Guest', N'1f56552d-ded7-4825-87cf-fca3f6de9706', CAST(0xA5A202E8 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20504 AS Decimal(18, 0)), N'Guest', N'ee99ee87-1645-4d5d-afcb-acacbdfd8490', CAST(0xA5A202EE AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20505 AS Decimal(18, 0)), N'Guest', N'62c02f95-ddd1-4ec2-af05-4151122cf994', CAST(0xA5A202F0 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20506 AS Decimal(18, 0)), N'Guest', N'b7008e95-4040-4c94-a84d-88c0b8a25ab3', CAST(0xA5A202F2 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20507 AS Decimal(18, 0)), N'Guest', N'152b52b9-ffac-4d31-802b-22a67cb41ea8', CAST(0xA5A202F3 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20516 AS Decimal(18, 0)), N'Guest', N'788e88fd-0243-47d0-ae00-c2d12b650daf', CAST(0xA5A20373 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20517 AS Decimal(18, 0)), N'Guest', N'e0fccf17-d3d8-4f25-b0d1-d9e5a6577af9', CAST(0xA5A20373 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20518 AS Decimal(18, 0)), N'Guest', N'69181a47-9234-4b01-8d00-95842673ef1a', CAST(0xA5A20373 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20519 AS Decimal(18, 0)), N'Guest', N'03819850-b054-4346-bc51-96f4cf4c35a0', CAST(0xA5A20374 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20523 AS Decimal(18, 0)), N'Guest', N'653e97e7-aa8f-4c13-817e-8b98df0624ab', CAST(0xA5A203EF AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20524 AS Decimal(18, 0)), N'Guest', N'4e46ac1d-110d-4cfa-af56-469d25ff6cee', CAST(0xA5A203F5 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20525 AS Decimal(18, 0)), N'Guest', N'105595c0-aee6-4a08-9cdc-06475a53cf16', CAST(0xA5A203F6 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20526 AS Decimal(18, 0)), N'Guest', N'2fc0767f-6b4b-48a9-9330-08b50b91c74e', CAST(0xA5A204A4 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20527 AS Decimal(18, 0)), N'Guest', N'40b5dc53-9e60-4135-86b3-29915e135037', CAST(0xA5A204A5 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20528 AS Decimal(18, 0)), N'Guest', N'2d60a090-9b00-4caf-93fe-6d63bb7e91e4', CAST(0xA5A204A5 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20529 AS Decimal(18, 0)), N'Guest', N'ce70167f-e7b5-449e-ad6b-be7ebd200495', CAST(0xA5A204A9 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20530 AS Decimal(18, 0)), N'Guest', N'a27baca8-810b-4cfb-ac27-a3f06182e052', CAST(0xA5A204AA AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20531 AS Decimal(18, 0)), N'Guest', N'099c0095-3eb8-4000-a0d4-50a784be0d7c', CAST(0xA5A204AA AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20533 AS Decimal(18, 0)), N'Guest', N'd1e09e35-e0a8-47c8-b9a6-d5db39979203', CAST(0xA5A204AC AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20534 AS Decimal(18, 0)), N'Guest', N'ae11becc-1351-462f-8892-686767bf0b59', CAST(0xA5A204AD AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20535 AS Decimal(18, 0)), N'Guest', N'a238e7c2-fdd3-4969-8cbb-e213572ecd00', CAST(0xA5A204AD AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20536 AS Decimal(18, 0)), N'Guest', N'c6f05504-1385-4e3f-bac5-c2191020de06', CAST(0xA5A204AD AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20557 AS Decimal(18, 0)), N'Guest', N'f2e28b20-213f-49fb-bb51-5be6b62ca6d2', CAST(0xA5A3032B AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20558 AS Decimal(18, 0)), N'Guest', N'3d8fb414-c794-4689-875f-45e0a54a14f1', CAST(0xA5A30331 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20608 AS Decimal(18, 0)), N'Guest', N'57ac3fd0-1405-416b-9294-6aa822591eac', CAST(0xA5A30482 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20609 AS Decimal(18, 0)), N'Guest', N'a3efcf26-c66a-4ff6-a408-0e7fe88d61ef', CAST(0xA5A30485 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20610 AS Decimal(18, 0)), N'Guest', N'0453163e-c837-49b2-89a1-c0dc723e57b5', CAST(0xA5A30487 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20611 AS Decimal(18, 0)), N'Guest', N'4419f49a-7c0c-4adc-a809-deae80536aa7', CAST(0xA5A3048B AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20624 AS Decimal(18, 0)), N'Guest', N'021727e0-1146-43e9-ae75-41bd11222116', CAST(0xA5A40263 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20625 AS Decimal(18, 0)), N'Guest', N'8bba4820-7914-42af-95b4-129625c8af26', CAST(0xA5A40263 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20626 AS Decimal(18, 0)), N'Guest', N'ef4b2509-13d9-467c-9a8b-4bee5f84dcad', CAST(0xA5A40264 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20627 AS Decimal(18, 0)), N'Guest', N'c75de03c-f9c7-4011-809b-3b3903de8eda', CAST(0xA5A40265 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20628 AS Decimal(18, 0)), N'Guest', N'174d5868-9a7a-43a2-8ed5-ea43828a31d5', CAST(0xA5A40267 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20629 AS Decimal(18, 0)), N'Guest', N'e5526376-0bc6-43ab-98ee-bfd58f350eb1', CAST(0xA5A40268 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20630 AS Decimal(18, 0)), N'Guest', N'0458b8fd-d07e-4ce4-960e-826d2e7703bc', CAST(0xA5A40269 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20631 AS Decimal(18, 0)), N'Guest', N'07705be1-0e63-47ac-97bd-dfb791b0f61d', CAST(0xA5A4026B AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20632 AS Decimal(18, 0)), N'Guest', N'54a0f5c1-f0eb-450b-b5fe-5444f8ef4f31', CAST(0xA5A40271 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20633 AS Decimal(18, 0)), N'Guest', N'3d03e87e-e6a5-4a85-91e5-6eaf94005f96', CAST(0xA5A40275 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20634 AS Decimal(18, 0)), N'Guest', N'98fc10c9-d7a5-4531-bccd-f8394b1d7d7b', CAST(0xA5A40279 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20635 AS Decimal(18, 0)), N'Guest', N'5df53adb-0420-4002-9268-66d69feea590', CAST(0xA5A4027E AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20636 AS Decimal(18, 0)), N'Guest', N'9cbd3fcd-4bac-456b-a07a-6b341ec7184b', CAST(0xA5A40283 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20637 AS Decimal(18, 0)), N'Guest', N'69aafbe2-e831-4b90-b68a-33a1913cd498', CAST(0xA5A40289 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20638 AS Decimal(18, 0)), N'Guest', N'2267f195-5f53-4cae-8e88-e1305cf88c41', CAST(0xA5A4028A AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20639 AS Decimal(18, 0)), N'Guest', N'51ccb3c9-3e53-46f5-aa33-5c6c201d0969', CAST(0xA5A4028D AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20640 AS Decimal(18, 0)), N'Guest', N'727ccfd0-5e92-4edf-801b-15a9b3e2453f', CAST(0xA5A40291 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20641 AS Decimal(18, 0)), N'Guest', N'6df68f15-4c88-4a62-9203-ba0dd5b29ff3', CAST(0xA5A40294 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20642 AS Decimal(18, 0)), N'Guest', N'ba11a0b4-3a27-4b10-9c40-4807444a01e3', CAST(0xA5A40299 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20643 AS Decimal(18, 0)), N'Guest', N'8857ef98-4964-4d46-92af-25161f5c43a3', CAST(0xA5A4029C AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(20644 AS Decimal(18, 0)), N'Guest', N'f564f875-77ef-4f35-b8fb-18a0c8a6e851', CAST(0xA5A4029E AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30468 AS Decimal(18, 0)), N'Guest', N'a821d963-c931-49d8-b6e8-2e8020499ee9', CAST(0xA5B6029D AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30469 AS Decimal(18, 0)), N'Guest', N'7b85b277-f195-437b-959f-13bd85b8019e', CAST(0xA5B602A0 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30470 AS Decimal(18, 0)), N'Guest', N'40016234-0c3e-4614-921e-6b458778e729', CAST(0xA5B602A2 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30471 AS Decimal(18, 0)), N'Guest', N'01b36af8-0fec-4108-b50a-8930f0d18aef', CAST(0xA5B602A6 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30472 AS Decimal(18, 0)), N'Guest', N'ded662fb-a158-4af8-a883-0fd7a70d7cb7', CAST(0xA5B602AA AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30475 AS Decimal(18, 0)), N'Guest', N'a456c015-0590-409c-8c24-edf88c0303fc', CAST(0xA5B602DE AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30476 AS Decimal(18, 0)), N'Guest', N'1a86a181-2f38-4cb3-9d22-057f312c8f6e', CAST(0xA5B602E0 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30477 AS Decimal(18, 0)), N'Guest', N'35b674d9-535f-4bb1-88f4-e397460db256', CAST(0xA5B602E1 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30478 AS Decimal(18, 0)), N'Guest', N'77a474e3-4f83-4929-b984-8791ec736ac7', CAST(0xA5B602E2 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30481 AS Decimal(18, 0)), N'Guest', N'197dc5f0-7d4e-48a8-903e-d17933e043ac', CAST(0xA5B602EE AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30482 AS Decimal(18, 0)), N'Guest', N'96a01584-4bae-477c-b929-82ae42f10d72', CAST(0xA5B602F2 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30483 AS Decimal(18, 0)), N'Guest', N'7cddc8a9-8971-4f41-8896-c5d96fd91a07', CAST(0xA5B602FF AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30484 AS Decimal(18, 0)), N'Guest', N'35e4afb4-85ba-499b-a471-726304f4f7c2', CAST(0xA5B60301 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30485 AS Decimal(18, 0)), N'Guest', N'8801b7d2-7e8b-45e0-820c-a2c29dc7e2ce', CAST(0xA5B60309 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30486 AS Decimal(18, 0)), N'Guest', N'f608c675-2678-4a46-9f4e-7df57546040b', CAST(0xA5B6030D AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30523 AS Decimal(18, 0)), N'Guest', N'a2060326-5165-4505-85cf-0b459c542d41', CAST(0xA5B80356 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30524 AS Decimal(18, 0)), N'Guest', N'cb88f68f-af37-400a-8520-a3c7bbdfaf01', CAST(0xA5B80358 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30525 AS Decimal(18, 0)), N'Guest', N'cf2b20b7-09af-481d-b506-bde5a34df288', CAST(0xA5B80359 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30526 AS Decimal(18, 0)), N'Guest', N'd343368b-bb6b-45ef-9803-f4cd086c3334', CAST(0xA5B80359 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30527 AS Decimal(18, 0)), N'Guest', N'3e056a80-b3b8-4158-84b4-854686e713b0', CAST(0xA5B8035A AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30528 AS Decimal(18, 0)), N'Guest', N'b3ff02e4-6e79-4016-8b34-cc5f29f4d163', CAST(0xA5B8035B AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30529 AS Decimal(18, 0)), N'Guest', N'287eb768-d64b-4547-ab92-d5536be5de7c', CAST(0xA5B8035D AS SmallDateTime))
GO
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30650 AS Decimal(18, 0)), N'Guest', N'6c374472-84ee-4e2f-818e-24622e48c27d', CAST(0xA5BD0372 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30651 AS Decimal(18, 0)), N'Guest', N'c115c283-129e-428a-bff9-06aaff8b214c', CAST(0xA5BD0372 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30652 AS Decimal(18, 0)), N'Guest', N'd10c235f-ebd8-44d3-ab6d-fad0fe660b2b', CAST(0xA5BD0373 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30653 AS Decimal(18, 0)), N'Guest', N'05f56e25-0796-4726-9dc0-bb1df66b4788', CAST(0xA5BD0374 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30654 AS Decimal(18, 0)), N'Guest', N'5deb6c98-8d1f-4213-b312-ffcbfaa60ef4', CAST(0xA5BD0375 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30655 AS Decimal(18, 0)), N'Guest', N'b730d847-361c-45b0-9cc0-22707e59a1e6', CAST(0xA5BD0376 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30563 AS Decimal(18, 0)), N'Guest', N'ab0d31c7-74e7-4eea-8a62-f8ac8ca9abc4', CAST(0xA5BB0384 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30564 AS Decimal(18, 0)), N'Guest', N'18e9f90d-68a8-4284-a07a-c4b417716164', CAST(0xA5BB0385 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30589 AS Decimal(18, 0)), N'Guest', N'e86243c8-989e-4204-9c15-aec36d740e3d', CAST(0xA5BD0260 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30590 AS Decimal(18, 0)), N'Guest', N'375d1aca-83e6-43a3-a50a-7da65aab7d54', CAST(0xA5BD0260 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30591 AS Decimal(18, 0)), N'Guest', N'7ca9d2a6-d7c8-4959-b436-2e6a3f30edba', CAST(0xA5BD0260 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30592 AS Decimal(18, 0)), N'Guest', N'e24109ed-446d-43b1-8119-c73fc05be9bf', CAST(0xA5BD0261 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30593 AS Decimal(18, 0)), N'Guest', N'524e6004-e92a-48d3-9bc3-c56edecda743', CAST(0xA5BD0262 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30594 AS Decimal(18, 0)), N'Guest', N'134adb2e-e9f3-4341-a90e-0905b8696c34', CAST(0xA5BD0263 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30595 AS Decimal(18, 0)), N'Guest', N'9dd3b34b-dcbb-4eba-bf11-0908f37730ee', CAST(0xA5BD0266 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30596 AS Decimal(18, 0)), N'Guest', N'd5ab2a07-0aa4-460a-85b2-e37d02e8c813', CAST(0xA5BD0267 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30597 AS Decimal(18, 0)), N'Guest', N'ff161563-d075-4e11-a0b3-61d9c69440c3', CAST(0xA5BD026D AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30598 AS Decimal(18, 0)), N'Guest', N'16b2c7e7-abf8-43d7-bd69-c16df7cbbe97', CAST(0xA5BD026E AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30599 AS Decimal(18, 0)), N'Guest', N'f7fba33a-7bdd-4ee9-bf7c-f72e48a5a747', CAST(0xA5BD0273 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30600 AS Decimal(18, 0)), N'Guest', N'5da10ef0-dbd7-4059-80d6-ffbe178b0261', CAST(0xA5BD0274 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30601 AS Decimal(18, 0)), N'Guest', N'a845bd26-3bc6-466e-ab57-7145ca26e228', CAST(0xA5BD0277 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30602 AS Decimal(18, 0)), N'Guest', N'7646e29c-f374-4b1e-a7a9-96ce9939c22e', CAST(0xA5BD0279 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30603 AS Decimal(18, 0)), N'Guest', N'ec579a07-98ba-4873-8f0c-d5a2ae7afca1', CAST(0xA5BD027C AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30604 AS Decimal(18, 0)), N'Guest', N'8b26aa50-348f-4db6-a933-37664bb90269', CAST(0xA5BD027D AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30605 AS Decimal(18, 0)), N'Guest', N'c14f1a7c-571d-4041-b411-bff85427766c', CAST(0xA5BD027E AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30606 AS Decimal(18, 0)), N'Guest', N'0dc2e66b-6271-4d4f-a456-c7eb26bf1ecf', CAST(0xA5BD027F AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30607 AS Decimal(18, 0)), N'Guest', N'26f66c0c-aafc-4a79-b7f2-a6b0edcdf6b0', CAST(0xA5BD027F AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30608 AS Decimal(18, 0)), N'Guest', N'5bc69cf6-3c94-4d6d-b3ca-de0589052756', CAST(0xA5BD0280 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30609 AS Decimal(18, 0)), N'Guest', N'64e9c6dc-3d49-4101-815e-48035242050d', CAST(0xA5BD0282 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30610 AS Decimal(18, 0)), N'Guest', N'0b090ccf-5473-4548-94ce-8c3620f2d763', CAST(0xA5BD0283 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30611 AS Decimal(18, 0)), N'Guest', N'444bc7bc-8fa0-4806-b2f8-16ea37588e40', CAST(0xA5BD0284 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30612 AS Decimal(18, 0)), N'Guest', N'e41da948-5f41-4420-9eb1-7df4092b4c7f', CAST(0xA5BD0285 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30613 AS Decimal(18, 0)), N'Guest', N'52e0d5af-3a2d-4995-a0c7-7d3b9b0f4594', CAST(0xA5BD0287 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30614 AS Decimal(18, 0)), N'Guest', N'b990af58-5e0c-4106-a87c-239569adde1a', CAST(0xA5BD0287 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30615 AS Decimal(18, 0)), N'Guest', N'b4379fd3-3b35-43e2-9365-8936cdfbc33d', CAST(0xA5BD0289 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30616 AS Decimal(18, 0)), N'Guest', N'59811b6d-7811-4ca5-8f4a-ba268a8bcc02', CAST(0xA5BD028B AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30617 AS Decimal(18, 0)), N'Guest', N'b1461d36-bd26-430d-ae67-54a6324998b3', CAST(0xA5BD028D AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30618 AS Decimal(18, 0)), N'Guest', N'c026394c-2c5a-44dd-90e8-049a623f4e5c', CAST(0xA5BD028E AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30619 AS Decimal(18, 0)), N'Guest', N'fc5488ad-e69e-4210-b5b2-66edbd3c4035', CAST(0xA5BD028E AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30620 AS Decimal(18, 0)), N'Guest', N'b1ba4364-47c1-4db7-b9cb-021a61291d90', CAST(0xA5BD028F AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30621 AS Decimal(18, 0)), N'Guest', N'86d869fe-6763-4f86-b138-2b89c805570c', CAST(0xA5BD0291 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30622 AS Decimal(18, 0)), N'Guest', N'2a7e7579-786f-42f7-90ed-73665d10a446', CAST(0xA5BD0299 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30623 AS Decimal(18, 0)), N'Guest', N'1f9901fd-e926-47a5-b3a5-b4277c7ad37c', CAST(0xA5BD029D AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30624 AS Decimal(18, 0)), N'Guest', N'38e9d99c-fee5-43d8-b01b-b47d4ed42896', CAST(0xA5BD029E AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30625 AS Decimal(18, 0)), N'Guest', N'5a582f1a-e741-4c36-a40d-f1f169966022', CAST(0xA5BD029F AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30626 AS Decimal(18, 0)), N'Guest', N'63dbefee-65ba-4ae0-b7c1-8ee8e7fd5482', CAST(0xA5BD02A0 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30627 AS Decimal(18, 0)), N'Guest', N'bbe0e1fc-62d2-4658-985c-692b2c5fbb5a', CAST(0xA5BD02A2 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30635 AS Decimal(18, 0)), N'Guest', N'2365567c-b040-4a6c-b382-4050432e2038', CAST(0xA5BD02C4 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30636 AS Decimal(18, 0)), N'Guest', N'ece64ae1-2d7a-40ee-be71-b7c781681cda', CAST(0xA5BD02C4 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30637 AS Decimal(18, 0)), N'Guest', N'f969ecb0-861b-402f-bce7-20783223eb93', CAST(0xA5BD02C5 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30638 AS Decimal(18, 0)), N'Guest', N'a53a11ea-8e51-41a7-912b-0d95258f03cc', CAST(0xA5BD02C7 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30639 AS Decimal(18, 0)), N'Guest', N'f8eaeb01-7ab3-4373-895d-dfb7f1232f4f', CAST(0xA5BD02CA AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30640 AS Decimal(18, 0)), N'Guest', N'4c8e51c9-1e59-4f85-b656-d6c5d74bf1a0', CAST(0xA5BD02CD AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30641 AS Decimal(18, 0)), N'Guest', N'6482b45b-d1b5-4014-85f1-3bcc3e7e1763', CAST(0xA5BD02CD AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30642 AS Decimal(18, 0)), N'Guest', N'481dba22-a350-455d-a98f-c55fcf793b14', CAST(0xA5BD02CE AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30643 AS Decimal(18, 0)), N'Guest', N'b4cc674d-523b-444c-b58f-3db0b2981c7c', CAST(0xA5BD02CF AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30656 AS Decimal(18, 0)), N'Guest', N'd0d38e76-b532-4d92-8ff6-ba0f1308c313', CAST(0xA5BD037A AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30657 AS Decimal(18, 0)), N'Guest', N'0821f6b7-f9e1-4148-af6d-817291ee1f41', CAST(0xA5BD037A AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30658 AS Decimal(18, 0)), N'Guest', N'853e22b6-c066-4225-b3ed-6dd86e4017b1', CAST(0xA5BD037C AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30659 AS Decimal(18, 0)), N'Guest', N'bd479ad3-4172-4049-b2b0-6c8840afc9df', CAST(0xA5BD037D AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30660 AS Decimal(18, 0)), N'Guest', N'd25c7267-3f39-402c-9bc4-776d57aa4412', CAST(0xA5BD037E AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30661 AS Decimal(18, 0)), N'Guest', N'a8fbd4bc-805b-44ca-a8ee-b48a638e0337', CAST(0xA5BD037F AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30662 AS Decimal(18, 0)), N'Guest', N'de41830f-794f-4d50-80ca-970676369181', CAST(0xA5BD0380 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30663 AS Decimal(18, 0)), N'Guest', N'ef1b7667-dd9d-4b81-9489-889f055851dd', CAST(0xA5BD0381 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30664 AS Decimal(18, 0)), N'Guest', N'df185ed6-5201-469c-92e0-916fae91aad4', CAST(0xA5BD0381 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30665 AS Decimal(18, 0)), N'Guest', N'b1dbeaf6-d6a1-4920-9f88-2b5ab7b68c78', CAST(0xA5BD0382 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30666 AS Decimal(18, 0)), N'Guest', N'3677934a-e4cf-41a5-9df5-7c9ddd112d36', CAST(0xA5BD0383 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30667 AS Decimal(18, 0)), N'Guest', N'092bb771-1c4a-48ca-bfa6-6af08a334b8c', CAST(0xA5BD0384 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30668 AS Decimal(18, 0)), N'Guest', N'0eb16fbd-597f-4fcd-8f13-fff5ebd4c400', CAST(0xA5BD0384 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30669 AS Decimal(18, 0)), N'Guest', N'73633f79-b759-4083-9380-747d4681aca2', CAST(0xA5BD0385 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30670 AS Decimal(18, 0)), N'Guest', N'109611f0-90c2-4078-8089-2411364f876d', CAST(0xA5BD0386 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30671 AS Decimal(18, 0)), N'Guest', N'1e4a3e04-340e-415a-bce3-dec4e77e8521', CAST(0xA5BD0387 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30672 AS Decimal(18, 0)), N'Guest', N'bbc946f4-6155-4f09-b3b4-afc5233ac94f', CAST(0xA5BD0389 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30673 AS Decimal(18, 0)), N'Guest', N'08ab2caf-4062-496b-a065-a00855c7c312', CAST(0xA5BD038B AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30691 AS Decimal(18, 0)), N'Guest', N'2297e432-41c1-458e-a23c-498a84baa6f6', CAST(0xA5BE027B AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30692 AS Decimal(18, 0)), N'Guest', N'96598871-8914-4176-bee1-e8a3fa7171f3', CAST(0xA5BE027C AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30693 AS Decimal(18, 0)), N'Guest', N'28087332-a68e-4c93-ac4e-daf519b6e109', CAST(0xA5BE027E AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30694 AS Decimal(18, 0)), N'Guest', N'876389a2-8258-44aa-aa1e-6eacbdd46275', CAST(0xA5BE027F AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30695 AS Decimal(18, 0)), N'Guest', N'0bb71d08-b908-4c18-ac64-913b60dd82d9', CAST(0xA5BE0280 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30696 AS Decimal(18, 0)), N'Guest', N'73679517-0986-42c1-9c3c-c60ed63a7602', CAST(0xA5BE0282 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30697 AS Decimal(18, 0)), N'Guest', N'61fd5069-03dc-48a8-9a97-5a2c32d37a15', CAST(0xA5BE0282 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30698 AS Decimal(18, 0)), N'Guest', N'cbf8d172-2eb2-446d-939b-90582e431126', CAST(0xA5BE0284 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30699 AS Decimal(18, 0)), N'Guest', N'f9ac71c8-96c6-4b19-83e2-d8b6b397bc49', CAST(0xA5BE0285 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30700 AS Decimal(18, 0)), N'Guest', N'ebaf3bea-8bb9-4d88-8979-41ca13173d34', CAST(0xA5BE0286 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30701 AS Decimal(18, 0)), N'Guest', N'ce004925-be62-4264-8f83-f917e97c057f', CAST(0xA5BE0287 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30702 AS Decimal(18, 0)), N'Guest', N'1af3bb42-def1-4686-b194-ed35f215425b', CAST(0xA5BE0287 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30703 AS Decimal(18, 0)), N'Guest', N'15d4565c-e120-45cd-ba28-4161f354b20e', CAST(0xA5BE0289 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30704 AS Decimal(18, 0)), N'Guest', N'159712c7-7def-4f8c-b6cf-2a4ebe8fca77', CAST(0xA5BE028B AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30705 AS Decimal(18, 0)), N'Guest', N'f9651552-ecf7-4088-acb8-e9883161399c', CAST(0xA5BE028E AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30706 AS Decimal(18, 0)), N'Guest', N'2216b5fa-c39e-409c-a56c-a91c3bcf14d6', CAST(0xA5BE028F AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30707 AS Decimal(18, 0)), N'Guest', N'7b6bb3ef-60fe-4cef-bc9e-fa021de25c71', CAST(0xA5BE0291 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30708 AS Decimal(18, 0)), N'Guest', N'9fa822f4-172e-4ae1-854e-2a82cded1d7e', CAST(0xA5BE0293 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30709 AS Decimal(18, 0)), N'Guest', N'caf4c019-fe3f-47b6-8b26-8881747d8b77', CAST(0xA5BF0266 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30710 AS Decimal(18, 0)), N'Guest', N'd383bf22-2b22-4772-b450-0de9d87d16a6', CAST(0xA5BF0268 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30711 AS Decimal(18, 0)), N'Guest', N'bfecfc88-2ae6-4a44-8ec0-dc8ee85b4bcf', CAST(0xA5BF026B AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30712 AS Decimal(18, 0)), N'Guest', N'9d54a56c-3d76-48ab-82b0-2698647c360e', CAST(0xA5BF026B AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30713 AS Decimal(18, 0)), N'Guest', N'fce4fbef-ac4c-46a4-8b38-be2c7fa7659d', CAST(0xA5BF026C AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30714 AS Decimal(18, 0)), N'Guest', N'0324c9ac-39a5-4b29-b33a-a63b2d244836', CAST(0xA5BF026C AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30715 AS Decimal(18, 0)), N'Guest', N'181bb96b-1469-4b11-914b-aab1a780b4de', CAST(0xA5BF026F AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30716 AS Decimal(18, 0)), N'Guest', N'561b5e85-6fe3-4d62-bafc-381a6f83d78b', CAST(0xA5BF0270 AS SmallDateTime))
GO
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30717 AS Decimal(18, 0)), N'Guest', N'dc4fa1f6-3a01-4db6-91d7-67d5d74c3f53', CAST(0xA5BF0271 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30718 AS Decimal(18, 0)), N'Guest', N'882550e5-0e64-4566-bbb0-05a22411f410', CAST(0xA5BF0271 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30719 AS Decimal(18, 0)), N'Guest', N'6ebebb9d-b343-4f69-a8ea-89ce7022653d', CAST(0xA5BF0273 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30720 AS Decimal(18, 0)), N'Guest', N'9f1d6456-1e41-43a2-b9e8-0c2ae214b224', CAST(0xA5BF0276 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30721 AS Decimal(18, 0)), N'Guest', N'34e60563-45b1-42f6-8e40-24ac82a81010', CAST(0xA5BF0277 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30722 AS Decimal(18, 0)), N'Guest', N'1f0757d8-ba42-4a11-89a0-777b9300bfdb', CAST(0xA5BF0277 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30723 AS Decimal(18, 0)), N'Guest', N'f9322fd1-e0fd-47bf-aa9d-9266c53d0294', CAST(0xA5BF0277 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30724 AS Decimal(18, 0)), N'Guest', N'dae6d1b7-7d1f-4667-b017-ee1ca26fd925', CAST(0xA5BF0277 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30725 AS Decimal(18, 0)), N'Guest', N'3016f2ce-f839-46ce-a8a8-908f0d46dee6', CAST(0xA5BF0278 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30726 AS Decimal(18, 0)), N'Guest', N'1178dc29-7944-430b-8b34-73d94134bcdc', CAST(0xA5BF0279 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30727 AS Decimal(18, 0)), N'Guest', N'54885270-9ef7-4f6c-b522-0c997c7e43d3', CAST(0xA5BF027C AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30728 AS Decimal(18, 0)), N'Guest', N'be83c5e3-1924-4a74-9b54-d3071f40a4d5', CAST(0xA5BF027D AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30729 AS Decimal(18, 0)), N'Guest', N'90708981-9a57-481c-82fa-6afbe45424e8', CAST(0xA5BF027E AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30730 AS Decimal(18, 0)), N'Guest', N'b2286c25-1456-420a-bd90-a6159a7c5cf2', CAST(0xA5BF027F AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30731 AS Decimal(18, 0)), N'Guest', N'665a8882-4170-4b99-92ac-795188d3f45d', CAST(0xA5BF0281 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30732 AS Decimal(18, 0)), N'Guest', N'e1535c4f-fbd7-48f4-8e1a-25d3b52ca132', CAST(0xA5BF0283 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30739 AS Decimal(18, 0)), N'Guest', N'e0a0228a-76a2-46b2-89c1-f707f35fd482', CAST(0xA5BF02BC AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30740 AS Decimal(18, 0)), N'Guest', N'cc7f888d-36e3-44b6-888f-5d02247c5b3f', CAST(0xA5BF02BE AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30741 AS Decimal(18, 0)), N'Guest', N'37e27529-57a4-41a9-aded-343437c99bc0', CAST(0xA5BF02BE AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30742 AS Decimal(18, 0)), N'Guest', N'2b49bc0a-c76b-44cb-85d4-caad45b09c4d', CAST(0xA5BF02BF AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30743 AS Decimal(18, 0)), N'Guest', N'eb5a1d55-c5a9-41db-a446-0e6b5bc6fde4', CAST(0xA5BF02C5 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30744 AS Decimal(18, 0)), N'Guest', N'd4125ba6-3ae3-46bd-b452-675c31e8b167', CAST(0xA5BF0300 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30745 AS Decimal(18, 0)), N'Guest', N'a8bc9519-8006-4b5c-8f2d-3c720dd9c2ef', CAST(0xA5BF0302 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30746 AS Decimal(18, 0)), N'Guest', N'c5a1c787-0354-4f09-9046-0bb873b60e5b', CAST(0xA5BF0305 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30747 AS Decimal(18, 0)), N'Guest', N'4d326b33-b7a9-42a6-8fd7-c0f277b4c3a7', CAST(0xA5BF03F7 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(30748 AS Decimal(18, 0)), N'Guest', N'3aa8b30c-a171-4676-aa57-cf825c0ae18f', CAST(0xA5BF03F8 AS SmallDateTime))
INSERT [dbo].[tblUserProfile] ([UserId], [UserName], [StoreCartId], [DateCreated]) VALUES (CAST(40768 AS Decimal(18, 0)), N'zimpik@yahoo.com', N'32909afe-735e-42b4-8909-8a2ced94d101', CAST(0xA6640506 AS SmallDateTime))
SET IDENTITY_INSERT [dbo].[tblUserProfile] OFF
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__UserProf__C9F28456C7E8C9CA]    Script Date: 25/10/2017 11:46:16 ******/
ALTER TABLE [NT AUTHORITY\SYSTEM].[UserProfile] ADD UNIQUE NONCLUSTERED 
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__webpages__8A2B61606E136BBE]    Script Date: 25/10/2017 11:46:16 ******/
ALTER TABLE [NT AUTHORITY\SYSTEM].[webpages_Roles] ADD UNIQUE NONCLUSTERED 
(
	[RoleName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [NT AUTHORITY\SYSTEM].[webpages_Membership] ADD  DEFAULT ((0)) FOR [IsConfirmed]
GO
ALTER TABLE [NT AUTHORITY\SYSTEM].[webpages_Membership] ADD  DEFAULT ((0)) FOR [PasswordFailuresSinceLastSuccess]
GO
ALTER TABLE [dbo].[tblFoodItem]  WITH CHECK ADD  CONSTRAINT [FK__tblFoodIt__FoodW__4E53A1AA] FOREIGN KEY([FoodWeightTypeId])
REFERENCES [dbo].[tblFoodWeightType] ([FoodWeightTypeId])
GO
ALTER TABLE [dbo].[tblFoodItem] CHECK CONSTRAINT [FK__tblFoodIt__FoodW__4E53A1AA]
GO
ALTER TABLE [dbo].[tblFoodItem]  WITH CHECK ADD  CONSTRAINT [FK__tblFoodIt__Selle__51300E55] FOREIGN KEY([SellerId])
REFERENCES [dbo].[tblSellerDetails] ([SellerId])
GO
ALTER TABLE [dbo].[tblFoodItem] CHECK CONSTRAINT [FK__tblFoodIt__Selle__51300E55]
GO
ALTER TABLE [dbo].[tblFoodItem]  WITH CHECK ADD  CONSTRAINT [FK__tblFoodIt__SubFo__3C34F16F] FOREIGN KEY([SubFoodGroupId])
REFERENCES [dbo].[tblSubFoodGroup] ([SubFoodGroupId])
GO
ALTER TABLE [dbo].[tblFoodItem] CHECK CONSTRAINT [FK__tblFoodIt__SubFo__3C34F16F]
GO
ALTER TABLE [dbo].[tblFoodItem]  WITH NOCHECK ADD  CONSTRAINT [FK_tblFoodItem_tblFoodItem] FOREIGN KEY([FoodItemId])
REFERENCES [dbo].[tblFoodItem] ([FoodItemId])
NOT FOR REPLICATION 
GO
ALTER TABLE [dbo].[tblFoodItem] NOCHECK CONSTRAINT [FK_tblFoodItem_tblFoodItem]
GO
ALTER TABLE [dbo].[tblSellerDetails]  WITH CHECK ADD FOREIGN KEY([BankId])
REFERENCES [dbo].[tblBankDetails] ([BankId])
GO
ALTER TABLE [dbo].[tblSubFoodGroup]  WITH CHECK ADD FOREIGN KEY([FoodGroupId])
REFERENCES [dbo].[tblFoodGroup] ([FoodGroupId])
GO
ALTER TABLE [NT AUTHORITY\SYSTEM].[webpages_UsersInRoles]  WITH CHECK ADD  CONSTRAINT [fk_RoleId] FOREIGN KEY([RoleId])
REFERENCES [NT AUTHORITY\SYSTEM].[webpages_Roles] ([RoleId])
GO
ALTER TABLE [NT AUTHORITY\SYSTEM].[webpages_UsersInRoles] CHECK CONSTRAINT [fk_RoleId]
GO
ALTER TABLE [NT AUTHORITY\SYSTEM].[webpages_UsersInRoles]  WITH CHECK ADD  CONSTRAINT [fk_UserId] FOREIGN KEY([UserId])
REFERENCES [NT AUTHORITY\SYSTEM].[UserProfile] ([UserId])
GO
ALTER TABLE [NT AUTHORITY\SYSTEM].[webpages_UsersInRoles] CHECK CONSTRAINT [fk_UserId]
GO
USE [master]
GO
ALTER DATABASE [QuickySaleOnlineStore] SET  READ_WRITE 
GO

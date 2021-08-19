
USE master

if exists (select * from sysdatabases where name='DWTaxiService_xxx')
begin
  raiserror('Dropping existing DWTaxiService database ....',0,1)
  DROP database DWTaxiService_xxx
end
GO

raiserror('Creating DWTaxiService database....',0,1)


CREATE DATABASE DWTaxiService_xxx
GO

Use DWTaxiService_xxx
GO

/* Create the Dimension Tables */
Create table [dbo].[DimCarType] (
	[CarTypeKey][int] NOT NULL Primary Key Identity ,
	[CarTypeId][nchar] (5) NOT NULL ,
	[CarType][nchar] (8) NOT NULL
)

Create table [dbo].[DimDates] (
	[DateKey][int] NOT NULL Primary Key Identity ,
	[Date][datetime] NOT NULL ,
	[DateName][nvarchar] (50) NOT NULL,
	[Month][int] NOT NULL,
	[MonthName][nvarchar] (50) NOT NULL,
	[Year][int] NOT NULL,
	[YearName][nvarchar] (50) NOT NULL
)

Create table [dbo].[DimCity] (
	[CityKey][int] NOT NULL Primary Key Identity ,
	[CityId][nchar] (10) NOT NULL ,
	[CityName][nvarchar] (50) NOT NULL,
	[State][nvarchar] (50) NOT NULL
)

Create table [dbo].[DimStreet] (
	[StreetKey][int] NOT NULL Primary Key Identity ,
	[StreetId][nvarchar] (10) NOT NULL ,
	[StreetName][nvarchar] (50) NOT NULL,
	[CityKey][int] NOT NULL
)


/* Create the Fact Table */
Create table [dbo].[FactTrips] 
(
    [TripKey] int NOT NULL identity,
	[TripNumber][nvarchar] (50) NOT NULL,
	[DateKey][int] NOT NULL ,
	[CarTypeKey][int] NOT NULL,
	[StreetKey][int] NOT NULL,
	[TripMileage][decimal] (18,4) NOT NULL,
	[TripCharge][decimal] (18,4) NOT NULL,
	Constraint PK_FactTrips PRIMARY KEY ([TripKey] asc)
) 

Alter Table dbo.DimStreet Add Constraint FK_DimStreet_DimCity Foreign Key (CityKey)
References dbo.DimCity (CityKey)

Alter Table dbo.FactTrips Add Constraint FK_FactTrips_DimDates Foreign Key (DateKey)
References dbo.DimDates (DateKey)

Alter Table dbo.FactTrips Add Constraint FK_FactTrips_DimCarType Foreign Key (CarTypeKey)
References dbo.DimCarType (CarTypeKey)

Alter Table dbo.FactTrips Add Constraint FK_FactTrips_DimStreet Foreign Key (StreetKey)
References dbo.DimStreet (StreetKey)

GO

-- Distinct Landusage count 
 select *
 from Housing


Select Distinct(Landuse), Count(UniqueID) as count_landuse , Avg(LandValue) as Avg_landvalue, Avg(Buildingvalue) as avg_BuildingValue, Avg(Totalvalue) as avg_TotalValue
From Housing 
Group by Landuse
Order by Count(UniqueID)  desc;

-- City wise value and acerage 

Select CITY, Avg(LandValue) as Avg_landvalue, Avg(Buildingvalue) as avg_BuildingValue, Avg(Totalvalue) as avg_TotalValue , avg(Acreage)as Avg_Acerage
From Housing 
Group by CITY
Order by City ;

-- Property Value by Bedroom and Bathroom

Select FullBath, HalfBath, Bedrooms, Avg(LandValue) as Avg_landvalue, Avg(Buildingvalue) as avg_BuildingValue, Avg(Totalvalue) as avg_TotalValue , avg(Acreage)as Avg_Acerage
From Housing 
Group by Bedrooms, FullBath, Halfbath
Order by Bedrooms DESC;

--Relation between Year Built, salePrice and building value

Select YearBuilt, Avg(buildingvalue) as avd_buildvalue, avg(saleprice) as avg_saleprice
From Housing 
Group by YearBuilt
Order by YearBuilt DESC;

-- MAX Landvalue, buildvalue, Total value, Acerage per city 
Select CITY, MAX(LandValue) as MAX_landvalue, MAX(Buildingvalue) as MAX_BuildingValue, MAX(Totalvalue) as MAX_TotalValue , MAX(Acreage)as MAX_Acerage
From Housing 
Group by CITY
Order by MAX_landvalue DESC;

-- Top 1000 properties with max sale value

Select top 1000 *
from housing 
Order by saleprice DESC


-- Landvalue per acre and buildvalue per acre 

Select city, AVG(landvalue/acreage) as landvalueperacre, AVG(buildingvalue/acreage) as buildvalueperacre, AVG(Totalvalue/acreage) as Totalvalueperacre
From Housing 
Group by city
order by CITY DESC

select * from dbo.housing;

---- Standardizing the sale date

--select SaleDate from PortfolioProject.dbo.housing; -- Data is showing Timestamp along with date 

--UPDATE dbo.housing
--SET SaleDate = Convert(Date, SaleDate); -- Still showing the same results

--ALTER TABLE HOUSING 
--ADD SaleDateConverted Date; 
--UPDATE dbo.housing
--SET SaleDateConverted = Convert(Date, SaleDate); -- Now Standardized column is SaleDateConverted

--ALTER TABLE HOUSING
--DROP COLUMN SaleDate;   -- Dropping the Non-standardized Sale Date Column

---- Populate Property Address
--select * from dbo.housing
--Where PropertyAddress is Null;

--select Count(UniqueID) as Null_Propertyaddress_count , Propertyaddress from dbo.housing
--Group by Propertyaddress
--Having PropertyAddress is NULL;

----select a.parcelID, a.propertyaddress , b.parcelID, b.propertyaddress  -- Where property address is null parcelID is duplicating but not unique ID, we can populate the address with same parcelID via self JOIN
----from dbo.housing a
----Join dbo.housing b
----ON a.ParcelID = b.ParcelID 
----	AND a.UniqueID <> b.UniqueID
----Where a.Propertyaddress IS NULL;

--select a.parcelID, a.propertyaddress , b.parcelID, b.propertyaddress, ISNULL(a.propertyaddress, b.propertyaddress) AS propertyaddress_populated
--from dbo.housing a
--Join dbo.housing b
--ON a.ParcelID = b.ParcelID 
--	AND a.UniqueID <> b.UniqueID
--	Where a.Propertyaddress IS NULL; - 



--update a
--SET propertyaddress =  ISNULL(a.propertyaddress, b.propertyaddress)
--from dbo.housing a
--Join dbo.housing b
--ON a.ParcelID = b.ParcelID 
--	AND a.UniqueID <> b.UniqueID
--	Where a.Propertyaddress IS NULL;


----Seperating address into main address, city , state
----Select Propertyaddress,
----Substring (Propertyaddress,1, CHARINDEX (',' , Propertyaddress) -1) as Main_address,
----Substring (Propertyaddress,CHARINDEX (',' , Propertyaddress) +2, LEN(Propertyaddress)) as City
----From Housing

--ALTER TABLE HOUSING
--ADD CITY Varchar(255);
--UPDATE HOUSING
--SET CITY = Substring (Propertyaddress,CHARINDEX (',' , Propertyaddress) +2, LEN(Propertyaddress)) 
--From Housing

--ALTER TABLE HOUSING
--ADD Address Varchar(255);
--UPDATE HOUSING
--SET  Address = Substring (Propertyaddress,1, CHARINDEX (',' , Propertyaddress) -1)
--From Housing

--ALTER TABLE HOUSING
--DROP COLUMN PropertyAddress;

----Select
----PARSENAME(Replace(Owneraddress ,',', '.') ,1 ) as Owner_State,
----PARSENAME(Replace(Owneraddress ,',', '.') ,2 ) as Owner_City,
----PARSENAME(Replace(Owneraddress,',', '.') ,3 ) as Owner_address
----from housing

--Alter table housing 
--Add Owner_state varchar(50), Owner_city Varchar(100), Owner_address varchar(255);

--UPDATE HOUSING
--SET OWNER_STATE = PARSENAME(Replace(Owneraddress ,',', '.') ,1 ) ,
-- Owner_city = PARSENAME(Replace(Owneraddress ,',', '.') ,2 ) , 
-- Owner_address = PARSENAME(Replace(Owneraddress,',', '.') ,3 );

-- ALTER TABLE HOUSING
-- DROP COLUMN OWNERADDRESS;


-- --DATA characterization for column sold as vacant

----Select SoldasVacant,
---- CASE 
----	When soldasvacant = 'Y' then 'Yes'
----	When soldasvacant = 'N' then 'No'
----	Else soldasvacant
----	END
----From housing


--UPDATE Housing
--Set SoldAsVacant = CASE 
--	When soldasvacant = 'Y' then 'Yes'
--	When soldasvacant = 'N' then 'No'
--	Else soldasvacant
--	END
--From housing


--Select distinct(SoldAsVacant), Count(Soldasvacant)
-- From Housing
-- Group by Soldasvacant;

-- --Remove Duplicates

-- WITH
-- CTE_duplicate ( ParcelID,Saleprice, LegalReference, Address , Duplicate_count)
-- As
-- (
-- SELECT ParcelID,Saleprice, LegalReference, Address , ROW_NUMBER () OVER( Partition by ParcelID, Saleprice, LegalReference, Address Order by ParcelID) as Duplicate_count
-- from Housing
-- )

-- select *
-- from Housing h
-- JOIN CTE_DUPLICATE b
-- ON h.parcelID = b.parcelID 
--	AND h.saleprice = b.saleprice 
--	AND H.legalreference = b.legalreference
--	AND h.address= b.address
--	Where b.duplicate_count >1 ;



-- WITH
-- CTE_duplicate
-- As
-- (
-- SELECT ParcelID,Saleprice, LegalReference, Address , ROW_NUMBER () OVER( Partition by ParcelID, Saleprice, LegalReference, Address Order by ParcelID) as Duplicate_count
-- from Housing
-- )

-- Delete 
-- from CTE_Duplicate
--	Where duplicate_count >1 ;


---- Delete Unused columns

--ALTER TABLE Housing
--Drop COLUMN TaxDistrict, OwnerName



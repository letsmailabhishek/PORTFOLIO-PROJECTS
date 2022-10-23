select * from data



--Standardise Date Format

select saledateconverted , convert (date,saledate)
from data;

update data
set saledate =  convert (date,saledate);

alter table NashvilleHouse
add SaleDateConverted date;

update data
set SaleDateConverted =  convert (date,saledate);

--Populate Property Address data

select *
from data
where propertyaddress is null
--order by ParcelID



select a.parcelid, a.propertyaddress, b.ParcelID, b.PropertyAddress, isnull(a.propertyaddress, b.PropertyAddress)
 from HousingProject.[dbo].[data] a
join HousingProject.[dbo].[data] b
on  a.parcelid = b.parcelid
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.propertyaddress, b.PropertyAddress)
from HousingProject.[dbo].[data] a
join HousingProject.[dbo].[data] b
on  a.parcelid = b.parcelid
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--Breaking out Address into individual columnsn(address, city, state)

select PropertyAddress
from data
--where propertyaddress is null
--order by ParcelID

select
SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1) as Address
,SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) +1 , len(propertyaddress)) as Address
 
 from data


alter table data
add PropertySplitAddress Nvarchar(255);

update data
set  PropertySplitAddress =  SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1)

alter table data
add PropertySplitCity Nvarchar(255)

update data
set PropertySplitCity =  SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) +1 , len(propertyaddress))

select * from data

select owneraddress from data

select 
PARSENAME(replace(Owneraddress, ',','.'), 3)
,PARSENAME(replace(Owneraddress, ',','.'), 2)
,PARSENAME(replace(Owneraddress, ',','.'), 1)
from data


alter table data
add OwnerSplitAddress Nvarchar(255);

update data
set  OwnerSplitAddress =  PARSENAME(replace(Owneraddress, ',','.'), 3)

alter table data
add OwnerSplitCity Nvarchar(255)

update data
set OwnerSplitCity =  PARSENAME(replace(Owneraddress, ',','.'), 2)


alter table data
add OwnerSplitState Nvarchar(255);

update data
set  OwnerSplitState =  PARSENAME(replace(Owneraddress, ',','.'), 1)

--Changing Y and N to Yes and No in "sold Vacant" field

select distinct(soldasvacant), count(soldasvacant)
from data
group by soldasvacant
order by 2


select soldasvacant,
case when soldasvacant = 'Y' then 'Yes'
     when soldasvacant = 'N' then 'No'
	 else soldasvacant
	 end
from data

update data
set soldasvacant = case when soldasvacant = 'Y' then 'Yes'
     when soldasvacant = 'N' then 'No'
	 else soldasvacant
	 end
from data

--Remove Duplicates

WITH  RowNumCTE AS (
select *,
ROW_NUMBER() over (
partition by ParcelID, 
              PropertyAddress,
			  SalePrice,
			  SaleDate,
			  LegalReference
			  Order by 
			  UniqueID
			  ) row_num

from data
--order by ParcelID
)
SELECT *
FROM RowNumCTE
where row_num > 1
order by propertyaddress

--Delete unused columns

select * from data

alter table data
drop column SaleDate, propertyaddress, owneraddress, taxdistrict

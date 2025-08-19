/*

Cleaning data in SQL Queries

*/

Select *
From PortfolioProject.dbo.NashvilleHousing

--Standardize Date Format

	Select SaleDateConverted, convert(Date,SaleDate)
	From PortfolioProject.dbo.NashvilleHousing


	Update NashvilleHousing
	Set SaleDate= Convert(Date,SaleDate)

	ALTER TABLE NashvilleHousing
	Add SaleDateConverted date

	Update NashvilleHousing
	Set SaleDateConverted= Convert(Date,SaleDate)

------------------------------------------------------------------------------------------------------

--Populate Property Address data
 
 Select *
 From PortfolioProject..NashvilleHousing
 --Where PropertyAddress is null
 order by ParcelID
	

 Select a.ParcelID, a.PropertyAddress, b.ParcelID ,b.PropertyAddress,ISNULL(a.PropertyAddress, b.PropertyAddress)
 From PortfolioProject..NashvilleHousing a
 join PortfolioProject..NashvilleHousing b
  on a.ParcelID=b.ParcelID
  and a.[UniqueID ]<>b.[UniqueID ]
  where a.PropertyAddress is null


  Update a
  Set PropertyAddress=ISNULL(a.PropertyAddress, b.PropertyAddress)
  from PortfolioProject..NashvilleHousing a
  join PortfolioProject..NashvilleHousing b
  on a.ParcelID=b.ParcelID
  and a.[UniqueID ]<>b.[UniqueID ]
  where a.PropertyAddress is null
  
   ------------------------------------------------------------------------------------------------------
 
 --Breaking out Address into Indiviadual Columns (Address, City, State)

 Select  PropertyAddress
 from PortfolioProject..NashvilleHousing

 Select 
 SUBSTRING(PropertyAddress, 1, charindex(',', PropertyAddress)-1) as Address,
 SUBSTRING(PropertyAddress, charindex(',', PropertyAddress)+1, Len(PropertyAddress)) as Address
 From PortfolioProject..NashvilleHousing

 Alter Table NashvilleHousing
 Add PropertySplitAddress Nvarchar(255);

 Update NashvilleHousing
 Set PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1)

 Alter Table NashvilleHousing
 Add PropertySplitCity Nvarchar(255);

 Update NashvilleHousing
 Set PropertySpiltCity =  SUBSTRING(PropertyAddress, charindex(',', PropertyAddress)+1, Len(PropertyAddress))
  


 Select *
 From PortfolioProject..NashvilleHousing

 --Breaking OwnerAddress with a different method

 Select OwnerAddress
 From PortfolioProject..NashvilleHousing

 Select 
 PARSENAME (REPLACE(OwnerAddress,',','.'), 3),
 PARSENAME(REPLACE(Owneraddress,',','.'), 2), 
 PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
 from PortfolioProject..NashvilleHousing

 Alter Table NashvilleHousing
 Add OwnerSplitAddress Nvarchar(255);

 Update NashvilleHousing
 Set  OwnerSplitAddress= PARSENAME (REPLACE(OwnerAddress,',','.'), 3)

 Alter Table NashvilleHousing
 Add OwnerSplitCity Nvarchar(255);

 Update NashvilleHousing
 Set OwnerSplitCity= PARSENAME (REPLACE(OwnerAddress,',','.'), 2)

Alter Table NashvilleHousing
 Add OwnerSplitState Nvarchar(255);

 Update NashvilleHousing
 Set OwnerSplitState=PARSENAME (REPLACE(OwnerAddress,',','.'), 1)

 Select *
 From PortfolioProject..NashvilleHousing

 -------------------------------------------------------------------------------------------------

--Change Y and N to Yes and No in 'Sold as Vacant' Field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
from PortfolioProject..NashvilleHousing
Group by SoldAsVacant
order by SoldAsVacant

Select SoldAsVacant,
  CASE When SoldAsVacant='Y' Then 'Yes'
       When SoldAsVacant='N' Then 'No'
	   Else SoldAsVacant
	   End
from PortfolioProject..NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant= CASE When SoldAsVacant='Y' Then 'Yes'
    When SoldAsVacant='N' Then 'No'
	Else SoldAsVacant
	End

----------------------------------------------------------------------------------------------
 
 --Remove Duplicates

 WITH RowNumCTE AS(
 Select *,
        ROW_NUMBER() Over (
        Partition by ParcelID,
		             PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 Order by
					         UniqueID
			          )row_num  
From PortfolioProject..NashvilleHousing
--order by ParcelID
)

DELETE
from RowNumCTE
where row_num >1
--order by PropertyAddress



 WITH RowNumCTE AS(
 Select *,
        ROW_NUMBER() Over (
        Partition by ParcelID,
		             PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 Order by
					         UniqueID
			          )row_num  
From PortfolioProject..NashvilleHousing
--order by ParcelID
)

SELECT *
from RowNumCTE
where row_num >1

----------------------------------------------------------------------------------------------

--Delete Unused Columns

Select *
From PortfolioProject..NashvilleHousing

Alter Table PortfolioProject..NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table PortfolioProject..NashvilleHousing
Drop Column SaleDate






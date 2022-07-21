Select SaleDate
From NashvilleHousing

-- Populate Property Address Data

Select *
From NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvilleHousing a
Join NashvilleHousing b
    on a.ParcelID = b.ParcelID
    and a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvilleHousing a
Join NashvilleHousing b
    on a.ParcelID = b.ParcelID
    and a.[UniqueID] <> b.[UniqueID]

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From NashvilleHousing

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

From NashvilleHousing

Alter table NashvilleHousing
ADD PropertySplitAddress Nvarchar(255)

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

Alter table NashvilleHousing
ADD PropertySplitCity Nvarchar(255)

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select OwnerAddress
From NashvilleHousing

SELECT
Parsename(REPLACE(OwnerAddress,',','.'),3),
Parsename(REPLACE(OwnerAddress,',','.'),2),
Parsename(REPLACE(OwnerAddress,',','.'),1)
From NashvilleHousing

Alter table NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255)

Update NashvilleHousing
Set OwnerSplitAddress = Parsename(REPLACE(OwnerAddress,',','.'),3)

Alter table NashvilleHousing
ADD OwnerSplitCity Nvarchar(255)

Update NashvilleHousing
Set OwnerSplitCity = Parsename(REPLACE(OwnerAddress,',','.'),2)

Alter table NashvilleHousing
ADD OwnerSplitState Nvarchar(255)

Update NashvilleHousing
Set OwnerSplitState = Parsename(REPLACE(OwnerAddress,',','.'),1)

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant,
CASE 
    When SoldAsVacant = 'Y' Then 'Yes'
    When SoldAsVacant = 'N' Then 'No'
    ELSE SoldAsVacant
    END
From NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = CASE 
    When SoldAsVacant = 'Y' Then 'Yes'
    When SoldAsVacant = 'N' Then 'No'
    ELSE SoldAsVacant
    END

-- Remove Duplicates
WITH RowNumCTE AS(
Select *,
    ROW_NUMBER() OVER(
    PARTITION BY ParcelID,
                 PropertyAddress,
                 SaleDate,
                 LegalReference
                 ORDER BY
                    UniqueID
                    ) row_num

From NashvilleHousing
)
Select * -- Use DELETE
From RowNumCTE
Where row_num > 1
Order by PropertyAddress -- Comment out

-- Delete Unused Columns

Alter Table NashvilleHousing
DROP COLUMN OwnerAddress, PropertyAddress
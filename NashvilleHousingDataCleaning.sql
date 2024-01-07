
-- Standardize Sale Date: Convert from DateTime to Date

SELECT SaleDate, CONVERT(Date,SaleDate)
FROM DBO.NashvilleHousing

UPDATE NashvilleHousing 
SET SaleDate = CONVERT(Date,SaleDate) 

-- Populate Property Address data: Dealing with NULL values for Property Address 

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> B.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> B.[UniqueID ]
WHERE a.PropertyAddress IS NULL
 
 -- Confirm changes to Property Address

SELECT * 
FROM NashvilleHousing
WHERE PropertyAddress IS NULL 


-- Separating Adress into 3 columns; Address, City, State

SELECT PropertyAddress
FROM NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))  AS City
FROM NashvilleHousing



ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255) 

UPDATE NashvilleHousing 
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) 

ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255)  

UPDATE NashvilleHousing 
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT * 
FROM NashvilleHousing

-- Separating Owner Address in to 3 columns; Address, city, state 
SELECT OwnerAddress
FROM NashvilleHousing

-- PARSENAME only recognizes . as a delimitor so first we replace the , with . 
SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM NashvilleHousing


ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255)  

UPDATE NashvilleHousing 
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) 

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255)  

UPDATE NashvilleHousing 
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) 

ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(255)  

UPDATE NashvilleHousing 
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

-- Fixing consistency in the "Sold as Vacant" field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant 
  END
FROM NashvilleHousing

-- Confirming changes 

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant 
  END

  -- Remove the duplicates 
WITH RowNumCTE AS(
SELECT *,
   ROW_NUMBER() OVER (
   PARTITION BY ParcelID, 
                PropertyAddress, 
                SalePrice,
                SaleDate, 
                LegalReference
				ORDER BY 
				UniqueID
				) row_num

  FROM NashvilleHousing
 )
DELETE
FROM RowNumCTE
WHERE row_num > 1 



-- Deleting Unused Columns 

ALTER TABLE NashvilleHousing
DROP COLUMN  SaleDate, OwnerAddress, TaxDistrict, PropertyAddress,

SELECT * 
FROM NashvilleHousing 


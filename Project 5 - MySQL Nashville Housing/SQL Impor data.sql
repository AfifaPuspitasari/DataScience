USE nashvilledb;
-- Drop the table if it already exists
DROP TABLE IF EXISTS Nashville_Housing;

-- Create the table
CREATE TABLE Nashville_Housing (
    UniqueID INT PRIMARY KEY,
    ParcelID VARCHAR(255),
    LandUse VARCHAR(255),
    PropertyAddress VARCHAR(255),
    SaleDate DATE,
    SalePrice DECIMAL(10, 2),
    LegalReference VARCHAR(255),
    SoldAsVacant VARCHAR(3),
    OwnerName VARCHAR(255),
    OwnerAddress VARCHAR(255),
    Acreage DECIMAL(10, 2),
    TaxDistrict VARCHAR(255),
    LandValue DECIMAL(10, 2),
    BuildingValue DECIMAL(10, 2),
    TotalValue DECIMAL(10, 2),
    YearBuilt INT,
    Bedrooms INT,
    FullBath INT,
    HalfBath INT
);

LOAD DATA LOCAL INFILE 'C:/Users/afifa/Downloads/Nashville_Housing_Data.csv'
INTO TABLE Nashville_Housing
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    @var_UniqueID,
    @var_ParcelID,
    @var_LandUse,
    @var_PropertyAddress,
    @var_SaleDate,
    @var_SalePrice,
    @var_LegalReference,
    @var_SoldAsVacant,
    @var_OwnerName,
    @var_OwnerAddress,
    @var_Acreage,
    @var_TaxDistrict,
    @var_LandValue,
    @var_BuildingValue,
    @var_TotalValue,
    @var_YearBuilt,
    @var_Bedrooms,
    @var_FullBath,
    @var_HalfBath
)
SET
    UniqueID = NULLIF(@var_UniqueID, ''),
    ParcelID = NULLIF(@var_ParcelID, ''),
    LandUse = NULLIF(@var_LandUse, ''),
    PropertyAddress = NULLIF(@var_PropertyAddress, ''),
    SaleDate = NULLIF(@var_SaleDate, ''),
    SalePrice = NULLIF(@var_SalePrice, ''),
    LegalReference = NULLIF(@var_LegalReference, ''),
    SoldAsVacant = NULLIF(@var_SoldAsVacant, ''),
    OwnerName = NULLIF(@var_OwnerName, ''),
    OwnerAddress = NULLIF(@var_OwnerAddress, ''),
    Acreage = NULLIF(@var_Acreage, ''),
    TaxDistrict = NULLIF(@var_TaxDistrict, ''),
    LandValue = NULLIF(@var_LandValue, ''),
    BuildingValue = NULLIF(@var_BuildingValue, ''),
    TotalValue = NULLIF(@var_TotalValue, ''),
    YearBuilt = NULLIF(@var_YearBuilt, '') + 0, -- Convert to integer
    Bedrooms = NULLIF(@var_Bedrooms, '') + 0,   -- Convert to integer
    FullBath = NULLIF(@var_FullBath, '') + 0,   -- Convert to integer
    HalfBath = NULLIF(@var_HalfBath, '') + 0;   -- Convert to integer

SHOW WARNINGS;
-- 1. Display all data from the Nashville_Housing table.
SELECT *
FROM Nashville_Housing;

-- 2. Standardize the Date Format
-- If the SaleDate column is not in a standard date format, convert it.
-- In this case, we assume SaleDate might need conversion to 'YYYY-MM-DD' format.
UPDATE Nashville_Housing
SET SaleDate = STR_TO_DATE(SaleDate, '%Y-%m-%d');

-- Add a new column to store the standardized date format.
ALTER TABLE Nashville_Housing
ADD SaleDateConverted DATE;

-- Populate the new SaleDateConverted column with the standardized date format.
UPDATE Nashville_Housing
SET SaleDateConverted = STR_TO_DATE(SaleDate, '%Y-%m-%d');

-- Verify that the SaleDateConverted column has been correctly populated.
SELECT SaleDateConverted,
       SaleDate
FROM Nashville_Housing;

-- 3. Populate Property Address Column
-- Check for any NULL values in the PropertyAddress column.
SELECT COUNT(*)
FROM Nashville_Housing
WHERE PropertyAddress IS NULL;

-- The expected result is 29 NULL values in the PropertyAddress column.

-- Use other records with the same ParcelID to fill in the missing PropertyAddress values.
SELECT a.parcelID,
       a.propertyaddress, 
       b.parcelID, 
       b.propertyaddress, 
       IFNULL(a.PropertyAddress, b.PropertyAddress) AS PropertyAddress
FROM Nashville_Housing AS a
JOIN Nashville_Housing AS b
ON a.parcelID = b.parcelID
AND a.uniqueID <> b.uniqueID
WHERE a.PropertyAddress IS NULL;

-- Update the PropertyAddress field for records with NULL values using the non-NULL values from matching ParcelID records.
UPDATE Nashville_Housing AS a
JOIN Nashville_Housing AS b
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = IFNULL(a.PropertyAddress, b.PropertyAddress)
WHERE a.PropertyAddress IS NULL;

-- 4. Replace '.00' from the ParcelID
-- Display the ParcelID values without the '.00' suffix.
SELECT REPLACE(ParcelID, '.00', '')
FROM Nashville_Housing;

-- Update the ParcelID column by removing the '.00' suffix.
UPDATE Nashville_Housing
SET ParcelID = REPLACE(ParcelID, '.00', '');

-- Verify the update by displaying the ParcelID values.
SELECT ParcelID
FROM Nashville_Housing;

-- 5. Breaking out PropertyAddress into individual columns (Address, City)
-- Display the current PropertyAddress values.
SELECT PropertyAddress
FROM Nashville_Housing;

-- Split the PropertyAddress column into two new columns: Address and City.
SELECT PropertyAddress, 
       SUBSTRING_INDEX(PropertyAddress, ',', 1) AS Address,
       TRIM(SUBSTRING_INDEX(PropertyAddress, ',', -1)) AS City
FROM Nashville_Housing;

-- Add new columns for the split address components.
ALTER TABLE Nashville_Housing
ADD PropertyAddress1 VARCHAR(100),
ADD PropertyCity VARCHAR(50);

-- Populate the new PropertyAddress1 column with the address portion of PropertyAddress.
UPDATE Nashville_Housing
SET PropertyAddress1 = SUBSTRING_INDEX(PropertyAddress, ',', 1);

-- Populate the new PropertyCity column with the city portion of PropertyAddress.
UPDATE Nashville_Housing
SET PropertyCity = TRIM(SUBSTRING_INDEX(PropertyAddress, ',', -1));

-- Verify that the new columns have been populated correctly.
SELECT *
FROM Nashville_Housing;

-- 6. Breaking out OwnerAddress into individual columns (Address, City, State)
-- Display the current OwnerAddress values.
SELECT OwnerAddress
FROM Nashville_Housing;

-- Split the OwnerAddress column into three new columns: OwnerSplitAddress, OwnerCity, and OwnerState.
SELECT OwnerAddress,
       SUBSTRING_INDEX(OwnerAddress, ',', 1) AS OwnerSplitAddress,
       TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1)) AS OwnerCity,
       TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1)) AS OwnerState
FROM Nashville_Housing;

-- Add new columns for the split address components.
ALTER TABLE Nashville_Housing
ADD OwnerSplitAddress VARCHAR(100),
ADD OwnerCity VARCHAR(50),
ADD OwnerState VARCHAR(50);

-- Populate the new columns with the appropriate portions of OwnerAddress.
UPDATE Nashville_Housing
SET OwnerSplitAddress = SUBSTRING_INDEX(OwnerAddress, ',', 1),
    OwnerCity = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1)),
    OwnerState = TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1));

-- Verify that the new columns have been populated correctly.
SELECT *
FROM Nashville_Housing;

-- 7. Change 'Y' and 'N' to 'Yes' and 'No' in the SoldAsVacant field.
-- Display the count of each value in the SoldAsVacant column.
SELECT SoldAsVacant, COUNT(SoldAsVacant)
FROM Nashville_Housing
GROUP BY SoldAsVacant
ORDER BY 2;

-- Replace 'Y' with 'Yes' and 'N' with 'No' in the SoldAsVacant column.
SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
     ELSE SoldAsVacant
END AS SoldAsVacant
FROM Nashville_Housing;

-- Update the SoldAsVacant column with the new values.
UPDATE Nashville_Housing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
                        WHEN SoldAsVacant = 'N' THEN 'No'
                        ELSE SoldAsVacant
                    END;

-- 8. Remove Duplicates
-- Display the UniqueID and OwnerName columns, sorted by UniqueID.
SELECT UniqueID, OwnerName
FROM Nashville_Housing
ORDER BY UniqueID;

-- Assign row numbers to each record, partitioned by OwnerName and ordered by UniqueID.
SELECT ROW_NUMBER() OVER(PARTITION BY OwnerName ORDER BY UniqueID ASC) AS Row_Num, UniqueID, OwnerName
FROM Nashville_Housing;

-- Count how many OwnerName values are NULL.
SELECT COUNT(OwnerName)
FROM Nashville_Housing
WHERE OwnerName IS NULL;

-- Display all records.
SELECT *
FROM Nashville_Housing;

-- Identify duplicate records based on specific columns and assign row numbers.
WITH RowNumCTE AS 
(
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
                              ORDER BY uniqueID) AS row_num
    FROM Nashville_Housing
)

-- Display records where the row number is 2 or higher, indicating duplicates.
SELECT * 
FROM RowNumCTE
WHERE row_num >= 2;

-- 9. Delete redundant columns
-- Drop the PropertyAddress and OwnerAddress columns as they are now redundant.
ALTER TABLE Nashville_Housing
DROP COLUMN PropertyAddress, 
DROP COLUMN OwnerAddress;

-- Verify that the columns have been dropped by attempting to select them.
SELECT PropertyAddress1 AS PropertyAddress, OwnerSplitAddress AS OwnerAddress 
FROM Nashville_Housing 
LIMIT 0, 1000;


-- Display all records to verify changes.
SELECT *
FROM Nashville_Housing;

-- 10. Replacing NULL values in numeric columns with 0 or 0.0
-- For the Acreage column, replace NULL values with 0.0.
SELECT Acreage, IFNULL(Acreage, 0.0)
FROM Nashville_Housing;

-- Update the Acreage column by replacing NULL values with 0.
UPDATE Nashville_Housing
SET Acreage = IFNULL(Acreage, 0);

-- For the LandValue column, replace NULL values with 0.
SELECT LandValue, IFNULL(LandValue, 0)
FROM Nashville_Housing;

-- Update the LandValue column by replacing NULL values with 0.
UPDATE Nashville_Housing
SET LandValue = IFNULL(LandValue, 0);

-- For other numeric columns, replace NULL values with 0.
UPDATE Nashville_Housing
SET BuildingValue = IFNULL(BuildingValue, 0),
    TotalValue = IFNULL(TotalValue, 0),
    Bedrooms = IFNULL(Bedrooms, 0),
    FullBath = IFNULL(FullBath, 0),
    HalfBath = IFNULL(HalfBath, 0);

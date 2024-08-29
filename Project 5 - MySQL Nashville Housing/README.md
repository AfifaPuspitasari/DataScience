# SQL-Nashville-Data-Cleaning

# Cleaning the Nashville Housing Dataset using SQL.

I have cleaned this data using SQL statements. Here the data was retrieved, understood and then accordingly updated.

# What was done?
- Converting String Date to Date datatype.
- Updating missing values in Address Column.
- Formating ParcelID, Acreage, LandValue
- Breaking out PropertyAddress, Owner Address into individual columns
- Change Y and N to Yes and No in 'SoldasVacant' field.
- Removing Duplicates and redudndant columns

# Credits

This is a guided project from vrushali: https://github.com/vrushali92/SQL-Nashville-Data-Cleaning-/


# Changes
- In this project, we also handle empty values (" ") by converting them to NULL.
- And in this project, I adapt the code from SQL into MySQL 

1. **CONVERT to STR_TO_DATE**: In MySQL, the function used for date format conversion is `STR_TO_DATE()`, not `CONVERT()`.

2. **ISNULL to COALESCE**: In MySQL, `ISNULL` is replaced with `COALESCE()`.

3. **CHARINDEX and LEN to SUBSTRING_INDEX**: MySQL does not support `CHARINDEX` and `LEN`. Instead, `SUBSTRING_INDEX()` is used to split strings.

4. **ROW_NUMBER() and CTE**: MySQL supports `ROW_NUMBER()` and Common Table Expressions (CTE) with similar syntax, but `ROW_NUMBER()` is not available in MySQL versions before 8.0.

5. **IFNULL as a Replacement for ISNULL**: To handle NULL values in MySQL, use `IFNULL()`.

# Files
- Dataset: Nashville_Housing_Data.xlsx in `.csv `  
- Code: Nashville_Data_Cleaning.sql `.sql` 

# Setup
- MySQL Workbench

# Dataset

This dataset has 54403 records. It primarily describes the Nashville property's detail containing the Owner and its property details.

Description of the variables:

- `UniqueID`: Primary key
- `ParcelID` : varchar
- `LandUse` : varchar, Type of the property e.g Condo, Church, Apartment, Daycare
- `PropertyAddress` : varchar
- `SaleDate`: Date
- `SalePrice`: Integer
- `LegalReference` : varchar 
- `SoldAsVacant` : Bool, Yes/ No
- `OwnerName`: varchar
- `OwnerAddress` : varchar
- `Acreage` : Float
- `TaxDistrict` : varchar
- `LandValue` : Integer
- `BuildingValue` : Integer
- `TotalValue` : Integer
- `YearBuilt` : Integer
- `Bedrooms` : Integer
- `FullBath` : Integer
- `HalfBath` : Integer

				

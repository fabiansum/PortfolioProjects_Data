/*
Cleaning Data in SQL Queries

*/



Select *
From PortfolioProject..NashvilleHousing


---------------------------------------------------------------------------------------------------

-- Standardize Date Format

Select SaleDate
From PortfolioProject..NashvilleHousing

--Update PortfolioProject..NashvilleHousing
--SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE PortfolioProject..NashvilleHousing
Add SaleDateConverted Date;

Update PortfolioProject..NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

Select SaleDateConverted
From PortfolioProject..NashvilleHousing



---------------------------------------------------------------------------------------------------
-- Populate Property Address Data

Select *
From PortfolioProject..NashvilleHousing
-- Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress, ISNULL(a.propertyaddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET propert
From PortfolioProject..NashvilleHousing a


---------------------------------------------------------------------------------------------------
-- Breaking Out Address into Individual Columns (Address, City, State)










---------------------------------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" field







---------------------------------------------------------------------------------------------------
-- Remove Duplicates








---------------------------------------------------------------------------------------------------
-- Delete Unused Columns

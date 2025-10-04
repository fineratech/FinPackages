# Changelog

All notable changes to the fin_api_functions package will be documented in this file.

## [Unreleased]

### Added
- **Real Estate API Functions**:
  - `getTotalOutstandingBalance(String userId)` - Get user's total outstanding balance across all properties
  - `getAllRealEstate(String subMerchantId)` - Get all real estate properties managed by a sub-merchant
- **Models**:
  - `RealEstateProperty` - Complete property model with all fields (id, address, category, type, rent, price, fees, isLeased, friendlyName, starRating, state, country, locationId, managementCompanyId, images)
- **API Endpoints** (already existed, now exposed):
  - `ApiEndPoints.totalOutstandingBalance`
  - `ApiEndPoints.getAllRealEstate`

### Changed
- Exported `RealEstateProperty` model in main library file for public use
- Enhanced `ApiFunctionsService` with Real Estate specific methods

### Documentation
- Added comprehensive property model with JSON serialization
- Added proper error handling for Real Estate API calls

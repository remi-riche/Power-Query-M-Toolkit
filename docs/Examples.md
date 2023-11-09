# Examples for Power-Query-M-Toolkit Functions

This document provides step-by-step examples for each function in the Power-Query-M-Toolkit, illustrating how they can be applied to typical data transformation tasks in Excel and Power BI.

## CleanPhoneNumber

The `CleanPhoneNumber` function standardizes phone numbers to a consistent format.

Example Usage:

```m
let
Source = YourDataSource,
CleanedNumbers = Table.TransformColumns(Source, {"PhoneNumber", each CleanPhoneNumber(_)})
in
CleanedNumbers
```

This code will take a column named "PhoneNumber" and apply the `CleanPhoneNumber` function to each value.

## CleanEmail

The `CleanEmail` function ensures that email addresses are valid and properly formatted.

Example Usage:


```m
let
Source = YourDataSource,
CleanedEmails = Table.TransformColumns(Source, {"Email", each CleanEmail(_)})
in
CleanedEmails
```

This code will clean the "Email" column in your data source using the `CleanEmail` function.

## DeduplicateByKey

The `DeduplicateByKey` function removes duplicate records based on a specified key.

Example Usage:


```m
let
Source = YourDataSource,
UniqueRecords = DeduplicateByKey(Source, "ID")
in
UniqueRecords
```

This code will deduplicate the data based on the "ID" column.

## ExcludeUniformColumns

The `ExcludeUniformColumns` function removes any columns that have the same value in every row.

Example Usage:


```m
let
Source = YourDataSource,
VariedData = ExcludeUniformColumns(Source)
in
VariedData
```

This code will return a table with all uniform columns excluded.

## KeepUniformColumns

The `KeepUniformColumns` function does the opposite of `ExcludeUniformColumns`, keeping only those columns where the value is uniform across all rows.

Example Usage:


```m
let
Source = YourDataSource,
UniformData = KeepUniformColumns(Source)
in
UniformData
```

This code will return a table with only the columns where the values are uniform.

## Conclusion

These examples should give you a starting point to incorporate the Power-Query-M-Toolkit functions into your data processing workflows. Each function is designed to be intuitive and easy to integrate into your existing Power Query M queries.

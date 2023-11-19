# Power-Query-M-Toolkit for Advanced Data Solutions

Harness the full potential of data transformation in Excel, Power BI, Power Platform dataflows, and Microsoft Fabric with the `Power-Query-M-Toolkit`. Our community-driven repository offers an array of Power Query M functions optimized for comprehensive analytical solutions, from data movement to data science, making it the future of efficient data processing.

## Table of Contents
- [Introduction](#introduction)
- [Function Library](#function-library)
- [Platform Compatibility](#platform-compatibility)
- [Future-Ready Data Processing](#future-ready-data-processing)
- [Getting Started](#getting-started)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Introduction
Power Query M is an essential part of the modern data stack, integral not only in Excel, Power BI Dataflows, Azure Data Factory but also in Power Platform dataflows, ensuring seamless, integrated analytics workflows. The `Power-Query-M-Toolkit` is the cornerstone for current and future data processing needs, simplifying complex tasks through its intuitive and powerful functions.

## Function Library

### Data Normalization and Standardization
- [`AlphabetizeColumns`](functions/AlphabetizeColumns.pq) - Enhance data readability by reordering table columns alphabetically.
- [`CleanPhoneNumber`](functions/CleanPhoneNumber.pq) - Streamline communication by standardizing phone number formats.
- [`CleanEmail`](functions/CleanEmail.pq) - Enhance data reliability with thorough email validation.
- [`NormalizeUnicode`](functions/NormalizeUnicode.pq) - Standardize text to Unicode Normalization Form C for consistent encoding.
- [`StandardizeDateFormats`](functions/StandardizeDateFormats.pq) - Convert a variety of date formats into a single standardized format.

### Data Deduplication
- [`DeduplicateByKey`](functions/DeduplicateByKey.pq) - Achieve cleaner datasets by removing duplicate entries.
- [`KeepOnlyDistinctColumns`](functions/KeepOnlyDistinctColumns.pq) - Refine data integrity by retaining only the columns with values that are entirely unique or meet a specified closeness to uniqueness, allowing for a nuanced approach to data deduplication and anomaly detection.
- [`FuzzyDeduplicate`](functions/FuzzyDeduplicate.pq) - Remove near-duplicate entries using fuzzy string matching algorithms.
- [`CrossTableDeduplicate`](functions/CrossTableDeduplicate.pq) - Deduplicate entries across multiple related tables based on complex logic.

### Data Reduction
- [`ExcludeUniformColumns`](functions/ExcludeUniformColumns.pq) - Focus analysis on varied data by excluding uniform columns.
- [`KeepUniformColumns`](functions/KeepUniformColumns.pq) - Simplify templates and reporting by keeping uniform columns.
- [`PatternBasedDeduplication`](functions/PatternBasedDeduplication.pq) - Remove duplicates by identifying repeating patterns in text data.

### Data Specification
- [`FilterColumnsByDistinctValues`](functions/FilterColumnsByDistinctValues.pq) - Optimize dataset specificity by preserving columns with a number of distinct values above a defined threshold, facilitating precise control over data granularity and uniqueness.

### Data Enrichment
- [`SentimentAnalysis`](functions/SentimentAnalysis.pq) - Analyze text data to extract sentiment scores, categorizing inputs as positive, negative, or neutral.
- [`DataTypeConversion`](functions/DataTypeConversion.pq) - Convert data types with advanced parsing for mixed-format columns.

### Data Transformation
- [`NestedJSONFlatten`](functions/NestedJSONFlatten.pq) - Flatten deeply nested JSON structures into tabular format for analysis.
- [`DynamicPivot`](functions/DynamicPivot.pq) - Pivot data based on dynamic sets of categories and aggregation rules.

### Data Integration
- [`SmartMerge`](functions/SmartMerge.pq) - Merge tables with the ability to handle mismatched schemas and automate column mapping.
- [`TemporalDataAlignment`](functions/TemporalDataAlignment.pq) - Align disparate time series data by resampling and interpolation.

### Data Quality Assurance
- [`AuditChangeTracking`](functions/AuditChangeTracking.pq) - Create a log of changes for auditing data transformations over time.
- [`CreateTimestampWithTimezoneHandling`](functions/CreateTimestampWithTimezoneHandling.pq) - Generate accurate timestamps considering timezone shifts and daylight saving time changes, enhancing data reliability in time-sensitive reports.
- [`ValidateCustomPatterns`](functions/ValidateCustomPatterns.pq) - Check data against custom regex patterns for complex validation rules.
### Custom Calculations and Aggregations
- [`WeightedAverage`](functions/WeightedAverage.pq) - Calculate weighted averages for complex grouped data scenarios.
- [`BucketizeNumericRanges`](functions/BucketizeNumericRanges.pq) - Segment numeric data into custom-defined ranges or buckets.

### Advanced Analytics
- [`CalculateTrends`](functions/CalculateTrends.pq) - Assess data trends and generate predictive insights.
- [`PerformClusterAnalysis`](functions/PerformClusterAnalysis.pq) - Segment data into clusters for advanced categorization and analysis.

### Data Governance
- [`MaskSensitiveData`](functions/MaskSensitiveData.pq) - Anonymize or redact sensitive information in compliance with data governance policies.
- [`TrackDataLineage`](functions/TrackDataLineage.pq) - Provide a function to track and visualize the lineage of data transformations.


## Platform Compatibility
Our toolkit is robust and flexible, tested for compatibility with and highly effective in:
- **Excel Power Query**: Supercharge your Excel data wrangling capabilities.
- **Power BI Dataflows**: Seamlessly integrate with Power BI for analytics and reporting.
- **Power Platform Dataflows**: The key to unlocking advanced data manipulation within the Power Platform ecosystem.
- **Azure Data Factory (ADF)**: Employ in ADF for comprehensive ETL processes.
- **Microsoft Fabric**: Capitalize on an all-in-one analytical solution that spans from data movement to data science.

## Future-Ready Data Processing
With the rapid evolution of data platforms, the `Power-Query-M-Toolkit` stands ready as the future of data processing. It empowers users to navigate the evolving landscape with tools that are easy to learn and use, adaptable to new technologies, and capable of handling the complexities of tomorrow's data challenges.

## Getting Started
Embark on your journey with the Power-Query-M-Toolkit by following these simple steps:
1. Select the function you need from our [Function Library](#function-library).
2. Copy its `.pq` file's contents from the raw view on GitHub.
3. Paste the code into your Power Query Editor, Dataflow, or Microsoft Fabric pipeline.
4. Adjust the parameters as needed to tailor the function to your data scenario.

## Contributing
Join us in shaping the future of data transformation by contributing to the `Power-Query-M-Toolkit`. Your insights and expertise can help enhance the toolkit for users around the globe. [Learn how to contribute](CONTRIBUTING.md).

## License
This toolkit is shared under the MIT License, inviting broad use and collaborative enhancements. See the [LICENSE](LICENSE) file for details.

## Contact
Questions, feedback, or ideas? We're all ears! Reach out to us through [GitHub Issues](https://github.com/remi-riche/Power-Query-M-Toolkit/issues) or get in touch with Rémi RICHE at [r.riche@dataipa.com](mailto:r.riche@dataipa.com).

Discover the toolkit: [https://github.com/remi-riche/Power-Query-M-Toolkit](https://github.com/remi-riche/Power-Query-M-Toolkit)

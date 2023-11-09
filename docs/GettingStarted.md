# Getting Started with Power-Query-M-Toolkit

Welcome to the Power-Query-M-Toolkit! This guide will walk you through the steps to start using these powerful functions to enhance your data transformation processes in Excel and Power BI.

## Prerequisites

Before you begin, make sure you have:

- Microsoft Excel or Power BI Desktop installed.
- Basic knowledge of Power Query M and how to access the Power Query Editor.

## Installation

There is no traditional installation process for Power Query M functions since they are code snippets that you can copy and paste directly into your Power Query Editor. However, you should know how to import these functions into your editor.

1. Choose the function you want to use from the `functions` directory.
2. Open the `.pq` file and copy the entire code.
3. Open Power Query Editor in Excel or Power BI.
4. In the Home tab, click on `Advanced Editor`.
5. Paste the copied code into the Advanced Editor.

## Using the Functions

Once you've imported a function, you can call it within your Power Query M queries. Here's an example of how to use a function:

1. Ensure that you have data loaded into Power Query Editor.
2. Call the function from your query with the required parameters. For example:

```m
let
Source = YourDataTable,
CleanedData = CleanPhoneNumber(Source[PhoneNumberColumn])
in
CleanedData
```

Replace `YourDataTable` with the name of your data table and `PhoneNumberColumn` with the name of the column containing phone numbers.

## Next Steps

After you have used the basic functions, try combining them to perform more complex data transformations. Refer to the `Examples.md` and `AdvancedUsage.md` files for more detailed use cases and advanced techniques.

## Getting Help

If you encounter any issues or have questions:

- Check the `FAQs` section in the documentation.
- If you cannot find an answer, post your question in the `issues` section of the GitHub repository.

## Contributing

Your contributions to the toolkit are welcome! Please read through the `CONTRIBUTING.md` file for guidelines on how to submit contributions.

Thank you for using the Power-Query-M-Toolkit, and happy data transforming!

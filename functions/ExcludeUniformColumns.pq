let
    CleanAndFilterColumns = (source as table) as table =>
    let
        // Replace empty strings with null and trim text values
        CleanedTable = Table.TransformColumns(
            source, 
            List.Transform(
                Table.ColumnNames(source), 
                (columnName) => {columnName, each if _ is text then Text.Trim(Text.Clean(_)) else _}
            )
        ),
        
        // Table with replaced empty strings
        CleanedTableWithNulls = Table.TransformColumns(
            CleanedTable, 
            List.Transform(
                Table.ColumnNames(CleanedTable), 
                (columnName) => {columnName, each if _ = "" then null else _}
            )
        ),
        
        // Identify columns with more than one unique value (excluding nulls)
        NonUniformColumns = List.Select(
            Table.ColumnNames(CleanedTableWithNulls), 
            (columnName) =>
                let
                    ColumnData = Table.Column(CleanedTableWithNulls, columnName),
                    UniqueValues = List.Distinct(List.RemoveNulls(ColumnData)),
                    MoreThanOneUniqueValue = List.Count(UniqueValues) > 1
                in
                    MoreThanOneUniqueValue
        ),

        // Remove columns where all values are the same (or all nulls)
        FilteredTable = Table.SelectColumns(CleanedTableWithNulls, NonUniformColumns)
    in
        FilteredTable
in
    CleanAndFilterColumns

/*
Développeur : Rémi RICHE
Version : 2023.11.08.79
Email : r.riche@dataipa.com

Cette fonction Power Query M personnalisée est conçue pour filtrer et conserver uniquement les colonnes d'une table qui ont un nombre de valeurs distinctes correspondant au nombre total de lignes, ou qui se situent dans une tolérance spécifiée. Lorsque la tolérance est définie sur 0, toutes les colonnes avec des valeurs uniques seront conservées. Si une tolérance est spécifiée, les colonnes avec un nombre de valeurs distinctes supérieur ou égal à (Nombre de lignes - Tolérance) seront conservées.
*/

let
    KeepOnlyDistinctColumns = (sourceTable as table, optional tolerance as nullable number) as table =>
    let
        // Set default tolerance if not provided
        ToleranceLevel = if tolerance = null then 0 else tolerance,

        // Calculate the minimum number of distinct values required to retain a column
        RowCount = Table.RowCount(sourceTable),
        MinDistinctCount = RowCount - ToleranceLevel,

        // Clean the table: trim text values and replace empty strings with nulls
        CleanTable = Table.TransformColumns(sourceTable, List.Transform(Table.ColumnNames(sourceTable), 
            (colName) => {colName, each if _ is text then let trimmed = Text.Trim(_) in if trimmed = "" then null else trimmed else _})),

        // Identify and retain columns where the count of distinct non-null values meets the criteria
        ColumnsToKeep = List.Select(Table.ColumnNames(CleanTable), (colName) =>
            let
                ColumnValues = Table.Column(CleanTable, colName),
                DistinctNonNullValues = List.Distinct(List.RemoveNulls(ColumnValues)),
                DistinctCount = List.Count(DistinctNonNullValues)
            in
                // Adjust the comparison based on the tolerance level
                ToleranceLevel = 0 and DistinctCount = RowCount or
                ToleranceLevel > 0 and DistinctCount >= MinDistinctCount),

        // Create the final table with filtered columns
        FinalFilteredTable = Table.SelectColumns(CleanTable, ColumnsToKeep)
    in
        FinalFilteredTable
in
    KeepOnlyDistinctColumns

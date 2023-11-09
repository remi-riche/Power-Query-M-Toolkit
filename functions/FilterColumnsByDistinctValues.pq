/*
Développeur : Rémi RICHE
Version : 2023.11.08.79
Email : r.riche@dataipa.com

Cette fonction Power Query M personnalisée est conçue pour filtrer et conserver les colonnes d'une table basée sur le nombre de valeurs distinctes. Si aucune valeur n'est fournie pour le paramètre 'distinctCount', la fonction utilise une valeur par défaut de 1. Les colonnes retenues seront celles dont le nombre de valeurs distinctes est supérieur ou égal au 'MinDistinctCount' après le nettoyage des données.
*/

let
    FilterColumnsByDistinctValues = (sourceTable as table, optional distinctCount as nullable number) as table =>
    let
        // Set default distinct count if not provided
        MinDistinctCount = if distinctCount = null then 1 else distinctCount,

        // Clean the table: trim text values and replace empty strings with nulls
        TrimAndCleanTable = Table.TransformColumns(sourceTable, List.Transform(Table.ColumnNames(sourceTable), 
            (colName) => {colName, each if _ is text then let trimmed = Text.Trim(_) in if trimmed = "" then null else trimmed else _})),

        // Identify and retain columns where the count of distinct values is greater than or equal to MinDistinctCount
        RetainedColumns = List.Select(Table.ColumnNames(TrimAndCleanTable), (colName) =>
            List.Count(List.Distinct(List.RemoveNulls(Table.Column(TrimAndCleanTable, colName)))) >= MinDistinctCount),

        // Create the final table with filtered columns
        FinalTable = Table.SelectColumns(TrimAndCleanTable, RetainedColumns)
    in
        FinalTable
in
    FilterColumnsByDistinctValues

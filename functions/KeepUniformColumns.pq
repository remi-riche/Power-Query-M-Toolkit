let
    CleanAndRetainSingleValuedColumns = (source as table) as table =>
    let
        // Nettoyer les données en remplaçant les chaînes vides par null et en supprimant les espaces
        CleanedTable = Table.TransformColumns(
            source, 
            List.Transform(
                Table.ColumnNames(source), 
                (columnName) => {columnName, each if _ is text then Text.Trim(Text.Clean(_)) else _}
            )
        ),
        TableWithNulls = Table.ReplaceValue(CleanedTable,"",null,Replacer.ReplaceValue,Table.ColumnNames(CleanedTable)),

        // Calculer le nombre de valeurs non-null et distinctes pour chaque colonne
        ColumnsWithSingleNonNullValue = List.Select(
            Table.ColumnNames(TableWithNulls), 
            (columnName) =>
                let
                    ColValues = Table.Column(TableWithNulls, columnName),
                    NonNullValues = List.NonNullCount(ColValues),
                    DistinctValues = List.Distinct(List.Select(ColValues, (value) => value <> null))
                in
                    NonNullValues <= 1 // Modifié pour permettre zéro ou une occurrence non-null
        ),

        // Sélectionner seulement les colonnes avec au maximum une occurrence non-null
        FilteredTable = Table.SelectColumns(TableWithNulls, ColumnsWithSingleNonNullValue)
    in
        FilteredTable
in
    CleanAndRetainSingleValuedColumns

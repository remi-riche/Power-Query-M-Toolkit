/*
Développeur : Rémi RICHE
Version : 2023.11.08.79
Email : r.riche@dataipa.com

Cette fonction Power Query M personnalisée est conçue pour dédupliquer une table en se basant sur une colonne clé spécifiée.
Elle nettoie d'abord la table en remplaçant les chaînes vides par des valeurs nulles, ajoute un index pour conserver l'ordre des lignes,
puis regroupe les données pour remplir les valeurs manquantes en descendant et en remontant.
Enfin, elle combine les tables, trie par l'index pour restaurer l'ordre initial et supprime les doublons.
*/

let
    DeduplicateByKey = (inputTable as table, keyColumn as text) as table =>
    let
        // Nettoyer les données en remplaçant les chaînes vides par null et en appliquant trim
        CleanedTable = Table.TransformColumns(inputTable, List.Transform(Table.ColumnNames(inputTable), (columnName) => 
            {columnName, each if _ is text then Text.Trim(Text.Clean(_)) else _, type any}
        )),
        CleanedTableWithNulls = Table.ReplaceValue(CleanedTable,"",null,Replacer.ReplaceValue,Table.ColumnNames(CleanedTable)),

        // Ajoutez une colonne d'index pour conserver l'ordre initial des lignes
        TableWithIndex = Table.AddIndexColumn(CleanedTableWithNulls, "IndexDeduplicateByKey", 0, 1, Int64.Type),
        
        // Modifier le type de la colonne clé en texte pour le regroupement
        TypedTable = Table.TransformColumnTypes(TableWithIndex, {{keyColumn, type text}}),
        
        // Regrouper les données en fonction de la colonne clé
        GroupedRows = Table.Group(TypedTable, {keyColumn}, {
            {"AllData", each _, type table}
        }),

        // Appliquez FillDown et FillUp à toutes les colonnes de chaque groupe pour combler les valeurs manquantes
        FillDownAndUp = Table.TransformColumns(GroupedRows, {"AllData", each 
            let
                ColumnsToFill = List.RemoveItems(Table.ColumnNames(_), {keyColumn, "IndexDeduplicateByKey"}),
                FilledDown = Table.FillDown(_, ColumnsToFill),
                FilledUp = Table.FillUp(FilledDown, ColumnsToFill)
            in
            FilledUp
        }),

        // Combiner les tables remplies en une seule table
        CombinedTable = Table.Combine(FillDownAndUp[AllData]),

        // Trier la table combinée par l'index pour restaurer l'ordre initial des lignes
        SortedTable = Table.Sort(CombinedTable, {{"IndexDeduplicateByKey", Order.Ascending}}),

        // Supprimer les doublons basés sur la colonne clé tout en conservant la première ligne de chaque groupe
        RemovedDuplicates = Table.Distinct(SortedTable, {keyColumn}),

        // Supprimer la colonne d'index maintenant qu'elle n'est plus nécessaire
        FinalTable = Table.RemoveColumns(RemovedDuplicates, {"IndexDeduplicateByKey"})
    in
        FinalTable
in
    DeduplicateByKey

/*
Développeur : Rémi RICHE
Version : 2023.11.08.79
Email : r.riche@dataipa.com

Cette fonction Power Query M personnalisée est conçue pour réorganiser les colonnes d'une table par ordre alphabétique.
Elle prend une table en entrée et retourne la même table avec ses colonnes triées par ordre alphabétique de A à Z.
*/

let
    AlphabetizeColumns = (inputTable as table) as table =>
    let
        // Obtenir les noms de colonnes et les trier
        ColumnNames = Table.ColumnNames(inputTable),
        SortedColumnNames = List.Sort(ColumnNames),

        // Réorganiser les colonnes de la table en fonction des noms triés
        SortedTable = Table.ReorderColumns(inputTable, SortedColumnNames)
    in
        SortedTable
in
    AlphabetizeColumns

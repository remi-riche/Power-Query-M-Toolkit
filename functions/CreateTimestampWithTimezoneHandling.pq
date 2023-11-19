/*
Développeur : Rémi RICHE
Version : 2023.11.08.79
Email : r.riche@dataipa.com

Cette fonction Power Query M crée un horodatage (timestamp) qui indique la dernière actualisation d'un rapport dans Power BI.
Elle est conçue pour être utilisée dans Power BI Service et prend en compte les changements de fuseaux horaires ainsi que les heures d'été et d'hiver.
*/

let
    // Calcul de la date de début de l'heure d'été
    DebutHeureEte = Date.StartOfWeek(#date(Date.Year(DateTime.LocalNow()), 3, 31), Day.Sunday),

    // Calcul de la date de début de l'heure d'hiver
    DebutHeureHiver = Date.StartOfWeek(#date(Date.Year(DateTime.LocalNow()), 10, 31), Day.Sunday),

    // Obtention de la date et heure actuelles sans fuseau horaire
    DateHeureActuelleSansFuseau = DateTimeZone.RemoveZone(DateTimeZone.UtcNow()),

    // Détermination du décalage horaire avec UTC en fonction de la date actuelle
    DecalageHoraireUTC = if DateHeureActuelleSansFuseau < DebutHeureEte & #time(1, 0, 0) or
        DateHeureActuelleSansFuseau > DebutHeureHiver & #time(1, 0, 0) then 1 else 2,

    // Création de l'horodatage avec ajustement du fuseau horaire
    HorodatageAvecFuseau = DateTimeZone.SwitchZone(DateTimeZone.UtcNow(), DecalageHoraireUTC, 0),
    
    // Conversion de l'horodatage en tableau pour manipulation dans Power Query
    TableauHorodatage = #table(1, {{HorodatageAvecFuseau}}),

    // Renommage de la colonne pour plus de clarté
    TableauAvecColonneRenommee = Table.RenameColumns(TableauHorodatage, {{"Column1", "Horodatage"}}),

    // Ajustement du type de la colonne pour correspondre au format datetimezone
    TableauFinalAvecHorodatageFormate = Table.TransformColumnTypes(TableauAvecColonneRenommee, {{"Horodatage", type datetimezone}})
in
    TableauFinalAvecHorodatageFormate

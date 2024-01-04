let
    // Fonction pour extraire les adresses e-mail
    ExtractEmails = (text as nullable text) as list =>
    let
        // Vérifiez si le texte d'entrée est null et retournez une liste vide si c'est vrai
        Result = if text = null then
                    {}
                 else
                    let
                        // Fonction pour remplacer les caractères accentués par des caractères non accentués
                        ReplaceAccents = (input as text) as text =>
                            let
                                AccentedChars = {"á", "à", "â", "ä", "ã", "å", "é", "è", "ê", "ë", "í", "ì", "î", "ï", "ó", "ò", "ô", "ö", "õ", "ø", "ú", "ù", "û", "ü", "ý", "ÿ", "ç", "ñ"},
                                NonAccentedChars = {"a", "a", "a", "a", "a", "a", "e", "e", "e", "e", "i", "i", "i", "i", "o", "o", "o", "o", "o", "o", "u", "u", "u", "u", "y", "y", "c", "n"},
                                ReplacedText = List.Accumulate(List.Zip({AccentedChars, NonAccentedChars}), input, (state, replacement) => Text.Replace(state, replacement{0}, replacement{1}))
                            in
                                ReplacedText,
                        // Convertir en minuscules, remplacer les accents et supprimer les espaces de début/fin
                        PreparedText = ReplaceAccents(Text.Lower(Text.Trim(text))),
                        // Séparer le texte en mots
                        Words = Text.Split(PreparedText, " "),
                        // Sélectionner les mots qui contiennent '@' et '.'
                        Emails = List.Select(Words, each Text.Contains(_, "@") and Text.Contains(_, ".")),
                        // Valider et nettoyer le format de l'e-mail
                        ValidEmails = List.Transform(Emails, each if Text.Contains(_, ";") then Text.BeforeDelimiter(_, ";") else _)
                    in
                        ValidEmails
    in
        Result
in
    ExtractEmails

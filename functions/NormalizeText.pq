/*
Développeur : Rémi RICHE
Version : 2024.04.27.10
Email : r.riche@dataipa.com

Cette fonction Power Query M personnalisée, 'NormalizeText', est conçue pour normaliser le texte. Elle convertit le texte en minuscules, remplace les caractères accentués et spéciaux par leurs équivalents non accentués, transforme les lettres stylisées en lettres standard, retire les emojis et autres symboles, et standardise les espaces (y compris les tabulations et les espaces multiples). Elle prend une chaîne de caractères en entrée (qui peut être null) et retourne la chaîne normalisée.
*/

let
    NormalizeText = (inputText as nullable text) as text =>
    let
        // Étape 1: Remplacer les valeurs null par une chaîne vide
        CheckedText = if inputText = null then "" else inputText,

        // Étape 2: Convertir le texte en minuscules
        LowercaseText = Text.Lower(CheckedText),

        // Étape 3: Remplacer les caractères accentués et spéciaux
        ReplaceAccents = 
            let
                // Table de remplacement des caractères accentués et spéciaux
                AccentReplacements = #table(
                    {"AccentedChar", "Replacement"},
                    {
                        // Lettres accentuées communes
                        {"á", "a"}, {"à", "a"}, {"â", "a"}, {"ä", "a"}, {"ã", "a"}, {"å", "a"}, {"ā", "a"}, {"ă", "a"}, {"ą", "a"}, {"æ", "ae"},
                        {"ç", "c"}, {"ć", "c"}, {"č", "c"}, {"ĉ", "c"}, {"ċ", "c"},
                        {"é", "e"}, {"è", "e"}, {"ê", "e"}, {"ë", "e"}, {"ē", "e"}, {"ė", "e"}, {"ę", "e"},
                        {"í", "i"}, {"ì", "i"}, {"î", "i"}, {"ï", "i"}, {"ī", "i"}, {"į", "i"},
                        {"ñ", "n"}, {"ń", "n"}, {"ň", "n"}, {"ņ", "n"}, {"ŋ", "n"},
                        {"ó", "o"}, {"ò", "o"}, {"ô", "o"}, {"ö", "o"}, {"õ", "o"}, {"ø", "o"}, {"ō", "o"}, {"ő", "o"}, {"œ", "oe"}, {"ð", "d"},
                        {"ß", "ss"}, {"ś", "s"}, {"ŝ", "s"}, {"ş", "s"}, {"ș", "s"}, {"š", "s"},
                        {"ť", "t"}, {"ţ", "t"}, {"ț", "t"}, {"þ", "th"},
                        {"ú", "u"}, {"ù", "u"}, {"û", "u"}, {"ü", "u"}, {"ū", "u"}, {"ů", "u"}, {"ű", "u"}, {"ų", "u"},
                        {"ý", "y"}, {"ÿ", "y"},
                        {"ž", "z"}, {"ź", "z"}, {"ż", "z"},
                        {"ľ", "l"}, {"ĺ", "l"}, {"ł", "l"},
                        {"ď", "d"}, {"đ", "d"},
                        {"ğ", "g"}, {"ĝ", "g"}, {"ġ", "g"},
                        {"ħ", "h"},
                        {"ĵ", "j"},
                        {"ŕ", "r"}, {"ř", "r"},
                        {"µ", "u"},
                        {"ﬁ", "fi"}, {"ﬂ", "fl"}
                        // Ajouter d'autres remplacements si nécessaire
                    }
                ),

                // Convertir la table en liste de records
                AccentReplacementsList = Table.ToRecords(AccentReplacements),

                // Fonction pour remplacer les caractères accentués
                ReplaceAccentsFunc = (text as text) as text =>
                    List.Accumulate(
                        AccentReplacementsList,
                        text,
                        (state, current) => Text.Replace(state, current[AccentedChar], current[Replacement])
                    )
            in
                ReplaceAccentsFunc(LowercaseText),

        // Étape 4: Remplacer les lettres stylisées par des lettres standard
        ReplaceStylized = 
            let
                // Table de remplacement des caractères stylisés
                StylizedReplacements = #table(
                    {"StylizedChar", "Replacement"},
                    {
                        // Lettres mathématiques gras italique (Bold Italic) majuscules
                        {"𝑨", "a"}, {"𝑩", "b"}, {"𝑪", "c"}, {"𝑫", "d"}, {"𝑬", "e"}, {"𝑭", "f"}, {"𝑮", "g"},
                        {"𝑯", "h"}, {"𝑰", "i"}, {"𝑱", "j"}, {"𝑲", "k"}, {"𝑳", "l"}, {"𝑴", "m"}, {"𝑵", "n"},
                        {"𝑶", "o"}, {"𝑷", "p"}, {"𝑸", "q"}, {"𝑹", "r"}, {"𝑺", "s"}, {"𝑻", "t"}, {"𝑼", "u"},
                        {"𝑽", "v"}, {"𝑾", "w"}, {"𝑿", "x"}, {"𝒀", "y"}, {"𝒁", "z"},
                        // Lettres mathématiques gras italique (Bold Italic) minuscules
                        {"𝒂", "a"}, {"𝒃", "b"}, {"𝒄", "c"}, {"𝒅", "d"}, {"𝒆", "e"}, {"𝒇", "f"}, {"𝒈", "g"},
                        {"𝒉", "h"}, {"𝒊", "i"}, {"𝒋", "j"}, {"𝒌", "k"}, {"𝒍", "l"}, {"𝒎", "m"}, {"𝒏", "n"},
                        {"𝒐", "o"}, {"𝒑", "p"}, {"𝒒", "q"}, {"𝒓", "r"}, {"𝒔", "s"}, {"𝒕", "t"}, {"𝒖", "u"},
                        {"𝒗", "v"}, {"𝒘", "w"}, {"𝒙", "x"}, {"𝒚", "y"}, {"𝒛", "z"},
                        // Ajout des autres lettres stylisées précédemment incluses
                        // Fraktur Letters
                        {"𝔞", "a"}, {"𝔟", "b"}, {"𝔠", "c"}, {"𝔡", "d"}, {"𝔢", "e"}, {"𝔣", "f"}, {"𝔤", "g"},
                        {"𝔥", "h"}, {"𝔦", "i"}, {"𝔧", "j"}, {"𝔨", "k"}, {"𝔩", "l"}, {"𝔪", "m"}, {"𝔫", "n"},
                        {"𝔬", "o"}, {"𝔭", "p"}, {"𝔮", "q"}, {"𝔯", "r"}, {"𝔰", "s"}, {"𝔱", "t"}, {"𝔲", "u"},
                        {"𝔳", "v"}, {"𝔴", "w"}, {"𝔵", "x"}, {"𝔶", "y"}, {"𝔷", "z"},
                        {"𝔄", "a"}, {"𝔅", "b"}, {"𝔇", "d"}, {"𝔈", "e"}, {"𝔉", "f"}, {"𝔊", "g"}, {"𝔍", "j"},
                        {"𝔎", "k"}, {"𝔏", "l"}, {"𝔐", "m"}, {"𝔑", "n"}, {"𝔒", "o"}, {"𝔓", "p"}, {"𝔔", "q"},
                        {"𝔖", "s"}, {"𝔗", "t"}, {"𝔘", "u"}, {"𝔙", "v"}, {"𝔚", "w"}, {"𝔛", "x"}, {"𝔜", "y"},
                        // Script Letters
                        {"𝓪", "a"}, {"𝓫", "b"}, {"𝓬", "c"}, {"𝓭", "d"}, {"𝓮", "e"}, {"𝓯", "f"}, {"𝓰", "g"},
                        {"𝓱", "h"}, {"𝓲", "i"}, {"𝓳", "j"}, {"𝓴", "k"}, {"𝓵", "l"}, {"𝓶", "m"}, {"𝓷", "n"},
                        {"𝓸", "o"}, {"𝓹", "p"}, {"𝓺", "q"}, {"𝓻", "r"}, {"𝓼", "s"}, {"𝓽", "t"}, {"𝓾", "u"},
                        {"𝓿", "v"}, {"𝔀", "w"}, {"𝔁", "x"}, {"𝔂", "y"}, {"𝔃", "z"},
                        {"𝓐", "a"}, {"𝓑", "b"}, {"𝓒", "c"}, {"𝓓", "d"}, {"𝓔", "e"}, {"𝓕", "f"}, {"𝓖", "g"},
                        {"𝓗", "h"}, {"𝓘", "i"}, {"𝓙", "j"}, {"𝓚", "k"}, {"𝓛", "l"}, {"𝓜", "m"}, {"𝓝", "n"},
                        {"𝓞", "o"}, {"𝓟", "p"}, {"𝓠", "q"}, {"𝓡", "r"}, {"𝓢", "s"}, {"𝓣", "t"}, {"𝓤", "u"},
                        {"𝓥", "v"}, {"𝓦", "w"}, {"𝓧", "x"}, {"𝓨", "y"}, {"𝓩", "z"},
                        // Autres caractères stylisés
                        {"♡", " "}, {"❤", " "}, {"♥", " "}, {"★", " "}, {"☆", " "}
                        // Ajouter d'autres remplacements si nécessaire
                    }
                ),

                // Convertir la table en liste de records
                StylizedReplacementsList = Table.ToRecords(StylizedReplacements),

                // Fonction pour remplacer les caractères stylisés
                ReplaceStylizedFunc = (text as text) as text =>
                    List.Accumulate(
                        StylizedReplacementsList,
                        text,
                        (state, current) => Text.Replace(state, current[StylizedChar], current[Replacement])
                    )
            in
                ReplaceStylizedFunc(ReplaceAccents),

        // Étape 5: Supprimer les emojis et autres symboles en conservant uniquement les lettres a-z, les chiffres 0-9 et les espaces
        RemoveEmojisAndSymbols = Text.Select(ReplaceStylized, {"a".."z", "0".."9", " "}),
    
        // Étape 6: Remplacer les ponctuations et les caractères de contrôle par des espaces
        ReplacePunctuations = 
            let
                Punctuations = {".", ",", ";", ":", "!", "?", "(", ")", "[", "]", "{", "}", "<", ">", "/", "\\", "|", "@", "#", "$", "%", "^", "&", "*", "+", "=", "~", "`", "'", "'"},
                ReplaceWithSpace = List.Accumulate(
                    Punctuations, 
                    RemoveEmojisAndSymbols, 
                    (state, punctuation) => Text.Replace(state, punctuation, " ")
                )
            in
                ReplaceWithSpace,

        // Étape 7: Remplacer les caractères de contrôle (tabulations, retours à la ligne, etc.) par des espaces
        ReplaceControlChars = Text.Replace(ReplacePunctuations, "#(cr)", " "),
        ReplaceControlChars2 = Text.Replace(ReplaceControlChars, "#(lf)", " "),
        ReplaceControlChars3 = Text.Replace(ReplaceControlChars2, "#(tab)", " "),
        ReplaceControlCharsFinal = ReplaceControlChars3,

        // Étape 8: Remplacer les multiples espaces par un seul espace
        SimplifiedText = Text.Combine(List.Select(Text.Split(ReplaceControlCharsFinal, " "), each _ <> ""), " "),

        // Étape 9: Supprimer les espaces en début et fin de chaîne
        TrimmedText = Text.Trim(SimplifiedText)
    in
        TrimmedText
in
    NormalizeText

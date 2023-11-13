/*
Développeur : Rémi RICHE
Version : 2023.11.12.01
Email : r.riche@dataipa.com

Cette fonction Power Query M personnalisée, 'NormalizeText', est conçue pour normaliser le texte. Elle convertit le texte en minuscule, remplace les caractères accentués et spéciaux, et standardise les espaces (y compris les tabulations et les espaces multiples). Elle prend une chaîne de caractères en entrée (qui peut être null) et retourne la chaîne normalisée.
*/

let
    NormalizeText = (inputText as nullable text) as text =>
    let
        // Vérifier si le texte est null
        CheckedText = if inputText = null then "" else inputText,

        // Convertir le texte en minuscules
        LowercaseText = Text.Lower(CheckedText),

        // Remplacer les caractères accentués et spéciaux
        ReplaceAccentsAndSpecialChars = (text) => 
            let
                AccentedAndSpecialChars = {"á", "à", "â", "ä", "ã", "å", "é", "è", "ê", "ë", "í", "ì", "î", "ï", "ó", "ò", "ô", "ö", "õ", "ø", "ú", "ù", "û", "ü", "ý", "ÿ", "ç", "ñ", "ß", "œ", "æ", "\t", "\n", "\r"},  // Add more special characters as needed
                NonAccentedChars = {"a", "a", "a", "a", "a", "a", "e", "e", "e", "e", "i", "i", "i", "i", "o", "o", "o", "o", "o", "o", "u", "u", "u", "u", "y", "y", "c", "n", "ss", "oe", "ae", " ", " ", " "},  // Corresponding replacements
                ReplacedText = List.Accumulate(List.Zip({AccentedAndSpecialChars, NonAccentedChars}), text, (state, replacement) => Text.Replace(state, replacement{0}, replacement{1}))
            in
                ReplacedText,

        // Appliquer le remplacement des caractères et standardiser les espaces
        SimplifiedText = Text.Replace(ReplaceAccentsAndSpecialChars(LowercaseText), "  ", " "),
        StandardizedSpaces = Text.Clean(SimplifiedText)  // Removes all non-printing characters and reduces multiple spaces to a single space
    in
        StandardizedSpaces
in
    NormalizeText

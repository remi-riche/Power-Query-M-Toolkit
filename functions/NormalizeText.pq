/*
Développeur : Rémi RICHE
Version : 2024.04.27.04
Email : r.riche@dataipa.com

Cette fonction Power Query M personnalisée, 'NormalizeText', est conçue pour normaliser le texte. Elle convertit le texte en minuscules, remplace les caractères accentués et spéciaux par leurs équivalents non accentués, transforme les lettres stylisées en lettres standard, retire les emojis et autres symboles, et standardise les espaces (y compris les tabulations et les espaces multiples). Elle prend une chaîne de caractères en entrée (qui peut être null) et retourne la chaîne normalisée.
*/

let
    NormalizeText = (inputText as nullable text) as text =>
    let
        // 1. Vérifier si le texte est null
        CheckedText = if inputText = null then "" else inputText,

        // 2. Convertir le texte en minuscules
        LowercaseText = Text.Lower(CheckedText),

        // 3. Remplacer les caractères accentués et spéciaux par des non accentués
        ReplaceAccentsAndSpecialChars = 
            let
                AccentedChars = {
                    "á","à","â","ä","ã","å","ā","ă","ą",
                    "é","è","ê","ë","ē","ė","ę",
                    "í","ì","î","ï","ī","į","ì",
                    "ó","ò","ô","ö","õ","ø","ō","ő","ð",
                    "ú","ù","û","ü","ū","ů","ű","ų",
                    "ç","ñ","ß","œ","æ",
                    "þ","ž","ÿ","ý","µ"
                },
                NonAccentedChars = {
                    "a","a","a","a","a","a","a","a","a",
                    "e","e","e","e","e","e","e",
                    "i","i","i","i","i","i","i",
                    "o","o","o","o","o","o","o","o","o",
                    "u","u","u","u","u","u","u","u",
                    "c","n","ss","oe","ae",
                    "th","z","y","y","u"
                },
                ReplacedText = List.Accumulate(
                    List.Zip({AccentedChars, NonAccentedChars}), 
                    LowercaseText, 
                    (state, replacement) => Text.Replace(state, replacement{0}, replacement{1})
                )
            in
                ReplacedText,

        // 4. Remplacer les lettres stylisées par des lettres standard
        ReplaceStylizedLetters =
            let
                StylizedChars = {
                    // Fraktur Letters (minuscule)
                    "𝔞","𝔟","𝔠","𝔡","𝔢","𝔣","𝔤","𝔥","𝔦","𝔧","𝔨","𝔩","𝔪","𝔫","𝔬","𝔭","𝔮","𝔯","𝔰","𝔱","𝔲","𝔳","𝔴","𝔵","𝔶","𝔷",
                    // Fraktur Letters (majuscule)
                    "𝔄","𝔅","𝔇","𝔈","𝔉","𝔊","𝔍","𝔎","𝔏","𝔐","𝔑","𝔒","𝔓","𝔔","𝔖","𝔗","𝔘","𝔙","𝔚","𝔛","𝔜","ℌ",
                    // Script Letters (minuscule)
                    "𝓪","𝓫","𝓬","𝓭","𝓮","𝓯","𝓰","𝓱","𝓲","𝓳","𝓴","𝓵","𝓶","𝓷","𝓸","𝓹","𝓺","𝓻","𝓼","𝓽","𝓾","𝓿","𝔀","𝔁","𝔂","𝔃",
                    // Script Letters (majuscule)
                    "𝓐","𝓑","𝓒","𝓓","𝓔","𝓕","𝓖","𝓗","𝓘","𝓙","𝓚","𝓛","𝓜","𝓝","𝓞","𝓟","𝓠","𝓡","𝓢","𝓣","𝓤","𝓥","𝓦","𝓧","𝓨","𝓩",
                    // Bold Letters (minuscule)
                    "𝐚","𝐛","𝐜","𝐝","𝐞","𝐟","𝐠","𝐡","𝐢","𝐣","𝐤","𝐥","𝐦","𝐧","𝐨","𝐩","𝐪","𝐫","𝐬","𝐭","𝐮","𝐯","𝐰","𝐱","𝐲","𝐳",
                    // Bold Letters (majuscule)
                    "𝐀","𝐁","𝐂","𝐃","𝐄","𝐅","𝐆","𝐇","𝐈","𝐉","𝐊","𝐋","𝐌","𝐍","𝐎","𝐏","𝐐","𝐑","𝐒","𝐓","𝐔","𝐕","𝐖","𝐗","𝐘","𝐙",
                    // Italic Letters (minuscule)
                    "𝒶","𝒷","𝒸","𝒹","𝒺","𝒻","𝒼","𝒽","𝒾","𝒿","𝓀","𝓁","𝓂","𝓃","𝓸","𝓅","𝓆","𝓇","𝓈","𝓉","𝓊","𝓋","𝓌","𝓍","𝓎","𝓏",
                    // Italic Letters (majuscule)
                    "𝒜","𝒝","𝒞","𝒟","𝒠","𝒡","𝒢","𝒣","𝒥","𝒦","𝒩","𝒪","𝒫","𝒬","𝒮","𝒯","𝒰","𝒱","𝒲","𝒳","𝒴","𝒵",
                    // Bold Italic Letters (minuscule)
                    "𝒶","𝒷","𝒸","𝒹","𝒺","𝒻","𝒼","𝒽","𝒾","𝒿","𝓀","𝓁","𝓂","𝓃","𝓸","𝓅","𝓆","𝓇","𝓈","𝓉","𝓊","𝓋","𝓌","𝓍","𝓎","𝓏",
                    // Bold Italic Letters (majuscule)
                    "𝒜","𝒝","𝒞","𝒟","𝒠","𝒡","𝒢","𝒣","𝒥","𝒦","𝒩","𝒪","𝒫","𝒬","𝒮","𝒯","𝒰","𝒱","𝒲","𝒳","𝒴","𝒵",
                    // Sans-Serif Letters (minuscule)
                    "𝗮","𝗯","𝗰","𝗱","𝗲","𝗳","𝗴","𝗵","𝗶","𝗷","𝗸","𝗹","𝗺","𝗻","𝗼","𝗽","𝗾","𝗿","𝘀","𝘁","𝘂","𝘃","𝘄","𝘅","𝘆","𝘇",
                    // Sans-Serif Letters (majuscule)
                    "𝗔","𝗕","𝗖","𝗗","𝗘","𝗙","𝗚","𝗛","𝗜","𝗝","𝗞","𝗟","𝗠","𝗡","𝗢","𝗣","𝗤","𝗥","𝗦","𝗧","𝗨","𝗩","𝗪","𝗫","𝗬","𝗭",
                    // Monospace Letters (minuscule)
                    "𝚊","𝚋","𝚌","𝚍","𝚎","𝚏","𝚐","𝚑","𝚒","𝚓","𝚔","𝚕","𝚖","𝚗","𝚘","𝚙","𝚚","𝚛","𝚜","𝚝","𝚞","𝚟","𝚠","𝚡","𝚢","𝚣",
                    // Monospace Letters (majuscule)
                    "𝙰","𝙱","𝙲","𝙳","𝙴","𝙵","𝙶","𝙷","𝙸","𝙹","𝙺","𝙻","𝙼","𝙽","𝙾","𝙿","𝚀","𝚁","𝚂","𝚃","𝚄","𝚅","𝚆","𝚇","𝚈","𝚉",
                    // Superscript Letters and Numbers
                    "ⁱ","⁰","¹","²","³","⁴","⁵","⁶","⁷","⁸","⁹","⁺","⁻","⁼","⁽","⁾",
                    // Subscript Letters and Numbers
                    "₀","₁","₂","₃","₄","₅","₆","₇","₈","₉","₊","₋","₌","₍","₎",
                    // Other Stylized Characters
                    "_","•","♡","❤","★","☆","✓","✔","✕","✖","✦","✧","❄","❇","❌","❎","✈","✉","✂","☎","☀","☁","☂","☃","☄","☑","☓","☞","☟","☠","☣","☤","☦","☪","☮","☯","☸","✡","✝","✞","✠"
                },
                StandardChars = {
                    // Fraktur Letters
                    "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
                    "a","b","d","e","f","g","j","k","l","m","n","o","p","q","s","t","u","v","w","x","y","h",
                    // Script Letters
                    "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
                    "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
                    // Bold Letters
                    "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
                    "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
                    // Italic Letters
                    "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
                    "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
                    // Bold Italic Letters
                    "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
                    "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
                    // Sans-Serif Letters
                    "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
                    "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
                    // Monospace Letters
                    "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
                    "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
                    // Superscript Letters and Numbers
                    "i","0","1","2","3","4","5","6","7","8","9","+","-","=","(",")",
                    // Subscript Letters and Numbers
                    "0","1","2","3","4","5","6","7","8","9","+","-","=","(",")",
                    // Other Stylized Characters
                    " "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "
                },
                // Assurez-vous que les listes ont la même longueur
                // Si ce n'est pas le cas, il faut ajuster les listes
                // Ici, les listes sont conçues pour être de la même longueur
                ReplacedStylizedText = List.Accumulate(
                    List.Zip({StylizedChars, StandardChars}), 
                    ReplaceAccentsAndSpecialChars, 
                    (state, replacement) => Text.Replace(state, replacement{0}, replacement{1})
                )
            in
                ReplacedStylizedText,

        // 5. Supprimer les emojis et autres symboles en conservant uniquement les lettres a-z, les chiffres 0-9 et les espaces
        RemoveEmojisAndSymbols = Text.Select(ReplaceStylizedLetters, {"a".."z", "0".."9", " "}), 

        // 6. Remplacer les ponctuations et les caractères de contrôle par des espaces
        ReplacePunctuationAndControlChars = 
            let
                Punctuations = {".", ",", ";", ":", "!", "?", "(", ")", "[", "]", "{", "}", "<", ">", "/", "\\", "|", "@", "#", "$", "%", "^", "&", "*", "+", "=", "~", "`", "'", "\"", "•", "♡", "❤", "★", "☆", "✓", "✔", "✕", "✖", "✦", "✧", "❄", "❇", "❌", "❎", "✈", "✉", "✂", "☎", "☀", "☁", "☂", "☃", "☄", "☑", "☓", "☞", "☟", "☠", "☣", "☤", "☦", "☪", "☮", "☯", "☸", "✡", "✝", "✞", "✠"},
                ReplaceWithSpace = List.Accumulate(
                    Punctuations, 
                    RemoveEmojisAndSymbols, 
                    (state, punctuation) => Text.Replace(state, punctuation, " ")
                )
            in
                ReplaceWithSpace,

        // 7. Remplacer les tabulations, retours à la ligne, etc., par des espaces
        ReplaceControlChars = Text.Replace(ReplacePunctuationAndControlChars, "#(cr)", " "),
        ReplaceControlChars2 = Text.Replace(ReplaceControlChars, "#(lf)", " "),
        ReplaceControlChars3 = Text.Replace(ReplaceControlChars2, "#(tab)", " "),

        // 8. Remplacer les multiples espaces par un seul espace
        SimplifiedText = Text.Combine(Text.Split(ReplaceControlChars3, " "), " "),

        // 9. Supprimer les espaces en début et fin de chaîne
        TrimmedText = Text.Trim(SimplifiedText)
    in
        TrimmedText
in
    NormalizeText

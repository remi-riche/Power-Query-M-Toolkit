let
    ExtractEmails = (text as nullable text) as list =>
    let
        // Check if the input text is null
        IsTextNull = text = null,

        // Function to replace accented characters with non-accented characters
        ReplaceAccents = (input as text) as text =>
            let
                AccentedChars = {"á", "à", "â", "ä", "ã", "å", "é", "è", "ê", "ë", "í", "ì", "î", "ï", "ó", "ò", "ô", "ö", "õ", "ø", "ú", "ù", "û", "ü", "ý", "ÿ", "ç", "ñ"},
                NonAccentedChars = {"a", "a", "a", "a", "a", "a", "e", "e", "e", "e", "i", "i", "i", "i", "o", "o", "o", "o", "o", "o", "u", "u", "u", "u", "y", "y", "c", "n"},
                ReplacedText = List.Accumulate(List.Zip({AccentedChars, NonAccentedChars}), input, (state, replacement) => Text.Replace(state, replacement{0}, replacement{1}))
            in
                ReplacedText,

        // Main logic to extract emails
        Result = if IsTextNull then
                    {}
                 else
                    let
                        // Convert to lower case and remove leading/trailing whitespace
                        PreparedText = ReplaceAccents(Text.Lower(Text.Trim(text))),
                        // Split the text into words
                        Words = Text.Split(PreparedText, " "),
                        // Select words that contain '@' and '.'
                        Emails = List.Select(Words, each Text.Contains(_, "@") and Text.Contains(_, ".")),
                        // Validate and clean the email format
                        ValidEmails = List.Transform(Emails, each if Text.Contains(_, ";") then Text.BeforeDelimiter(_, ";") else _)
                    in
                        ValidEmails
    in
        Result
in
    ExtractEmails

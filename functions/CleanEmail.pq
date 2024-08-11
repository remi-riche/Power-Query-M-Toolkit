let
    // List of known generic domains to identify personal emails
    GenericDomains = {"gmail.com", "yahoo.com", "outlook.com", "hotmail.com", "live.com"},

    // Function to check if a domain is generic
    // Parameter: domain (text) - The domain of an email address, e.g., "gmail.com"
    // Returns: bool (true if the domain is generic, false otherwise)
    IsGeneric = (domain as text) as logical =>
        List.Contains(GenericDomains, Text.Lower(domain)),

    // Main function to extract and analyze email addresses
    // Parameter: text (nullable text) - The raw text potentially containing email addresses
    // Returns: table - A table containing detailed information about the extracted emails
    ExtractEmailDetails = (text as nullable text) as table =>
    let
        // Initial check if the input text is null or empty
        // If so, return an empty table with defined columns
        Result = if text = null or Text.Length(text) = 0 then
                    #table({"Email", "CleanedEmail", "Alias", "IsGeneric", "Domain", "SubDomain", "LocalPart", "DomainExtension"}, {})
                 else
                    let
                        // Convert text to lowercase and trim leading/trailing spaces
                        // This standardizes the text before processing
                        LowerText = Text.Lower(Text.Trim(text)),

                        // Function to replace accented characters with their non-accented equivalents
                        // Parameter: input (text) - The text in which accents need to be replaced
                        // Returns: text - The text with accents replaced
                        ReplaceAccents = (input as text) as text =>
                            let
                                // List of accented characters and their non-accented equivalents
                                AccentedChars = {"á", "à", "â", "ä", "ã", "å", "é", "è", "ê", "ë", "í", "ì", "î", "ï", "ó", "ò", "ô", "ö", "õ", "ø", "ú", "ù", "û", "ü", "ý", "ÿ", "ç", "ñ"},
                                NonAccentedChars = {"a", "a", "a", "a", "a", "a", "e", "e", "e", "e", "i", "i", "i", "i", "o", "o", "o", "o", "o", "o", "u", "u", "u", "u", "y", "y", "c", "n"},
                                // Replace accented characters by iterating over each character
                                ReplacedText = List.Accumulate(List.Zip({AccentedChars, NonAccentedChars}), input, (state, replacement) => Text.Replace(state, replacement{0}, replacement{1}))
                            in
                                ReplacedText,

                        // Apply the ReplaceAccents function to replace accents in the text
                        // Lowercase conversion and trimming are already applied in LowerText
                        PreparedText = ReplaceAccents(LowerText),

                        // Split the text into words using delimiters like spaces, commas, etc.
                        // This allows each word to be processed individually to detect emails
                        Words = Text.SplitAny(PreparedText, " ,;:"),

                        // Filter the words to keep only those that resemble email addresses
                        // We check for the presence of "@" and "." in the word
                        PotentialEmails = List.Select(Words, each Text.Contains(_, "@") and Text.Contains(_, ".")),

                        // Validate and clean up the extracted emails
                        // For each potential email, we truncate before ":" if present
                        ValidEmails = List.Transform(PotentialEmails, each
                            let
                                AtIndex = Text.PositionOf(_, "@"),
                                ColonIndex = Text.PositionOf(_, ":"),
                                // If ":" is present, take everything before it, otherwise take the whole word
                                Email = if ColonIndex >= 0 then Text.Start(_, ColonIndex) else _
                            in
                                Email
                        ),

                        // Transform the validated emails into detailed records
                        EmailRecords = List.Transform(ValidEmails, each
                            let
                                Email = _,
                                // Extract the part before and after the "@"
                                LocalPartWithAlias = Text.BeforeDelimiter(Email, "@"),
                                DomainPart = Text.AfterDelimiter(Email, "@"),
                                // Handle aliases in the local part (extract the part before and after "+")
                                LocalParts = Text.Split(LocalPartWithAlias, "+"),
                                MainLocalPart = LocalParts{0},
                                Alias = if List.Count(LocalParts) > 1 then LocalParts{1} else null,
                                // Construct the cleaned email without the alias
                                CleanedEmail = MainLocalPart & "@" & DomainPart,
                                // Separate the main domain and subdomain
                                DomainComponents = Text.Split(DomainPart, "."),
                                DomainComponentCount = List.Count(DomainComponents),
                                // Extract the main domain (e.g., "gmail.com")
                                MainDomain = Text.Combine(List.LastN(DomainComponents, 2), "."),
                                // Extract the subdomain if it exists (e.g., "mail" in "mail.example.com")
                                SubDomain = if DomainComponentCount > 2 then Text.Combine(List.FirstN(DomainComponents, DomainComponentCount - 2), ".") else null,
                                // Extract the domain extension (e.g., ".com")
                                DomainExtension = List.Last(DomainComponents),
                                // Check if the domain is generic or not
                                IsGenericDomain = IsGeneric(MainDomain)
                            in
                                // Create a record for each email with all the details
                                [
                                    Email = Email,
                                    CleanedEmail = CleanedEmail,
                                    Alias = Alias,
                                    IsGeneric = IsGenericDomain,
                                    Domain = MainDomain,
                                    SubDomain = SubDomain,
                                    LocalPart = MainLocalPart,
                                    DomainExtension = DomainExtension
                                ]
                        ),

                        // Convert the list of records into a table
                        // This allows displaying the results as a table in Power Query
                        EmailTable = Table.FromRecords(EmailRecords)
                    in
                        EmailTable
    in
        Result
in
    ExtractEmailDetails

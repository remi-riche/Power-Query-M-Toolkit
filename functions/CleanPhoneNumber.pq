let
    CleanPhoneNumber = (phoneNumber as text) as record =>
    let
        // Extract only digits from the input
        DigitsOnly = Text.Select(phoneNumber, {"0".."9"}),
        // Ensure there are at least 9 digits to work with
        IsValidLength = Text.Length(DigitsOnly) >= 9,
        // Retrieve the last 9 digits and prepend '0'
        PreparedNumber = if IsValidLength then "0" & Text.End(DigitsOnly, 9) else null,
        // Check if the prepared number has a sequence of the same digit
        IsSequenceOfSameDigit = if PreparedNumber <> null then List.Count(List.Distinct(Text.ToList(PreparedNumber))) = 1 else false,
        // Determine the type of phone number based on prefixes
        PhoneType = 
            if PreparedNumber = null then null else
            if Text.StartsWith(PreparedNumber, "06") or Text.StartsWith(PreparedNumber, "07") then "Mobile" 
            else if Text.StartsWith(PreparedNumber, "01") or Text.StartsWith(PreparedNumber, "02") or Text.StartsWith(PreparedNumber, "03") or Text.StartsWith(PreparedNumber, "04") or Text.StartsWith(PreparedNumber, "05") or Text.StartsWith(PreparedNumber, "08") or Text.StartsWith(PreparedNumber, "09") then "Domicile" 
            else "Inconnu",
        // Finalize the cleaned number
        CleanedNumber = if not IsSequenceOfSameDigit and PhoneType <> null then PreparedNumber else null
    in
        [Number=CleanedNumber, Type=PhoneType]
in
    CleanPhoneNumber

table 50121 "Fields 2"
{
    //Scope = Cloud;
    LookupPageId = "Field List";
    DrillDownPageId = "Field List";

    fields
    {
        field(1; "Table No."; Integer)
        {
        }
        field(2; "No."; Integer)
        {
        }
        field(3; "Table Name"; Text[30])
        {
        }
        field(4; "Field Name"; Text[30])
        {
        }
        field(5; Type; option)
        {
            OptionMembers = TableFilter,RecordID,OemText,Date,Time,DateFormula,Decimal,Media,MediaSet,Text,Code,Binary,BLOB,Boolean,Integer,OemCode,Option,BigInteger,Duration,GUID,DateTime;
            // This list must stay in sync with NCLOptionMetadataNavTypeField
            //OptionOrdinalValues = 4912, 4988, 11519, 11775, 11776, 11797, 12799, 26207, 26208, 31488, 31489, 33791, 33793, 34047, 34559, 35071, 35583, 36095, 36863, 37119, 37375;
            //OptionMembers = 4912, 4988, 11519, 11775, 11776, 11797, 12799, 26207, 26208, 31488, 31489, 33791, 33793, 34047, 34559, 35071, 35583, 36095, 36863, 37119, 37375;
            OptionCaption = 'TableFilter,RecordID,OemText,Date,Time,DateFormula,Decimal,Media,MediaSet,Text,Code,Binary,BLOB,Boolean,Integer,OemCode,Option,BigInteger,Duration,GUID,DateTime';

        }
        field(6; Length; Integer)
        {
        }
        field(7; Class; Option)
        {
            OptionMembers = Normal,FlowField,FlowFilter;
        }
        field(8; Enabled; Boolean)
        {
        }
        field(9; "Type Name"; Text[30])
        {
        }
        field(20; "Field Caption"; Text[80])
        {
        }
        field(21; "Relation Table No."; Integer)
        {
        }
        field(22; "Relation Field No."; Integer)
        {
        }
        field(23; "SQL Data Type"; option)
        {
            OptionMembers = Varchar,Integer,Variant,BigInteger;
        }
        field(24; "Option String"; Text[2047])
        {
        }
        field(25; "Obsolete State"; Option)
        {
            OptionMembers = No,Pending,Removed;
        }
        field(26; "Obsolete Reason"; Text[248])
        {
        }
        field(27; "Data Classification"; Option)
        {
            OptionMembers = CustomerContent,ToBeClassified,EndUserIdentifiableInformation,AccountData,EndUserPseudonymousIdentifiers,OrganizationIdentifiableInformation,SystemMetadata;
        }
        field(28; "Is Part Of Primary Key"; Boolean)
        {
        }
        field(60; "App Package ID"; Guid)
        {
        }
        field(61; "App Runtime Package ID"; Guid)
        {
        }
    }

    keys
    {
        key(pk; "Table No.", "No.")
        {
        }
    }
}
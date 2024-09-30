table 50135 "Location Stop"
{
    Caption = 'Location Stop';
    DataClassification = ToBeClassified;
    LookupPageId = "Location Stops";
    DrillDownPageId = "Location Stops";

    fields
    {
        field(1; "Route No."; Integer)
        {
            Caption = 'Route No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Location Stop"; Code[20])
        {
            Caption = 'Location Stop';
            DataClassification = ToBeClassified;
        }
        field(3; Description; Text[30])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
    }


    keys
    {
        key(PK; "Route No.", "Location Stop")
        {
            Clustered = true;
        }
    }
}

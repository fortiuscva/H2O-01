table 50128 "Comment Code"
{
    Caption = 'Comment Code';
    DataClassification = ToBeClassified;
    LookupPageId = "Comment Codes";
    DrillDownPageId = "Comment Codes";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[30])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
    }


    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}

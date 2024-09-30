table 50125 "Work Order Type"
{
    Caption = 'Work Order Type';
    DataClassification = ToBeClassified;
    LookupPageId = "Work Order Types";
    DrillDownPageId = "Work Order Types";

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

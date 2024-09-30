table 50126 "Meter Service Address Class"
{
    Caption = 'Meter Service Address Class';
    DataClassification = ToBeClassified;
    LookupPageId = "Meter Service Address Classes";
    DrillDownPageId = "Meter Service Address Classes";

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

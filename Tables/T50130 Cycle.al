table 50130 Cycle
{
    Caption = 'Cycles';
    DataClassification = ToBeClassified;
    LookupPageId = Cycles;
    DrillDownPageId = Cycles;

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

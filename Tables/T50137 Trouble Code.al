table 50137 "Trouble Code"
{
    Caption = 'Trouble Code';
    DataClassification = ToBeClassified;
    LookupPageId = "Trouble Codes";
    DrillDownPageId = "Trouble Codes";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(10; Replace; Boolean)
        {
            Caption = 'Replace';
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

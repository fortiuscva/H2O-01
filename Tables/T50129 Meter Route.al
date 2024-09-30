table 50129 Route
{
    Caption = 'Route';
    DataClassification = ToBeClassified;
    LookupPageId = "Meter Routes";
    DrillDownPageId = "Meter Routes";

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[30])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(3; "Customer No."; code[20])
        {
            Caption = 'Customer No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
    }



    keys
    {
        key(PK; "Customer No.", "No.")
        {
            Clustered = true;
        }
    }
}

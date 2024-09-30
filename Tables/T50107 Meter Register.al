table 50107 "Meter Register"
{
    Caption = 'Meter Register';
    DataClassification = ToBeClassified;
    LookupPageId = "Meter Registers";
    DrillDownPageId = "Meter Registers";

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(5; "From Entry No."; Integer)
        {
            Caption = 'From Entry No.';
            DataClassification = ToBeClassified;
            TableRelation = "Meter Ledger Entry";
        }
        field(10; "To Entry No."; Integer)
        {
            Caption = 'To Entry No.';
            DataClassification = ToBeClassified;
            TableRelation = "Meter Ledger Entry";
        }
        field(15; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            DataClassification = ToBeClassified;
        }
        field(20; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            DataClassification = ToBeClassified;
            TableRelation = "Source Code";
        }
        field(25; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
        }
        field(30; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}

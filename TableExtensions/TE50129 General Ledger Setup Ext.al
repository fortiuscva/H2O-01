tableextension 50129 "General Ledger Setup Ext" extends "General Ledger Setup"
{
    fields
    {
        field(50100; "Global Dim. 1 Code Required"; Boolean)
        {
            Caption = 'Global Dim. 1 Code Required';
            DataClassification = ToBeClassified;
        }
        field(50101; "Global Dim. 2 Code Required"; Boolean)
        {
            Caption = 'Global Dim. 2 Code Required';
            DataClassification = ToBeClassified;
        }
    }
}

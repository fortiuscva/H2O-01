tableextension 50113 "Res. Ledger Entry Ext" extends "Res. Ledger Entry"
{
    fields
    {
        field(50100; Rental; Boolean)
        {
            Caption = 'Rental';
            DataClassification = ToBeClassified;
        }
        field(50101; "Rental Start Date"; Date)
        {
            Caption = 'Rental Start Date';
            DataClassification = ToBeClassified;
        }
        field(50102; "Rental End Date"; Date)
        {
            Caption = 'Rental End Date';
            DataClassification = ToBeClassified;
        }
        field(50103; "On Rent"; Boolean)
        {
            Caption = 'On Rent';
            DataClassification = ToBeClassified;
        }
        field(50105; "Rental Days"; Integer)
        {
            Caption = 'Rental Days';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key20; "Entry No.", "Resource No.")
        {
        }
    }
}

tableextension 50102 "Item Ledger Entry Ext" extends "Item Ledger Entry"
{
    fields
    {
        field(50100; Meter; Boolean)
        {
            Caption = 'Meter';
            DataClassification = ToBeClassified;
        }
        field(50101; "Meter Created"; Boolean)
        {
            Caption = 'Meter Created';
            DataClassification = ToBeClassified;
        }
        field(50102; "Meter No."; Code[20])
        {
            Caption = 'Meter No.';
            DataClassification = ToBeClassified;
            TableRelation = Meter;
        }
        field(50103; "Source Sub No."; Code[10])
        {
            Caption = 'Source Sub No.';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Source Type" = CONST(Customer)) "Ship-to Address".Code WHERE("Customer No." = FIELD("Source No."));
        }
        field(50105; "Sent To Remote App"; Boolean)
        {
            Caption = 'Sent To Remote App';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50110; "Sent To Remote App Date"; Date)
        {
            Caption = 'Sent To Remote App Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50115; "Sent To Remote App Time"; Time)
        {
            Caption = 'Sent To Remote App Time';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50120; "EID No."; code[20])
        {
            Caption = 'Meter EID No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }


    keys
    {
        key(Key15; Meter, "Meter Created")
        {
        }
    }

}

tableextension 50103 "Item Journal Line Ext" extends "Item Journal Line"
{
    fields
    {
        field(50100; Meter; Boolean)
        {
            Caption = 'Meter';
            DataClassification = ToBeClassified;
        }
        field(50101; "Source Sub No."; Code[10])
        {
            Caption = 'Source Sub No.';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Source Type" = CONST(Customer)) "Ship-to Address" WHERE("Customer No." = FIELD("Source No."));
        }
        field(50105; "Meter Activity Code"; code[10])
        {
            caption = 'Meter Activity Code';
            DataClassification = ToBeClassified;
            TableRelation = "Meter Activity";
        }
        field(50110; "Received From Remote App"; Boolean)
        {
            Caption = 'Received From Remote App';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50115; "Received From Remote App Date"; Date)
        {
            Caption = 'Received From Remote App Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50120; "Received From Remote App Time"; Time)
        {
            Caption = 'Received From Remote App Time';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50125; "EID No."; code[20])
        {
            Caption = 'EID No.';
            DataClassification = ToBeClassified;
        }

    }
}

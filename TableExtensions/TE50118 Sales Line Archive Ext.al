tableextension 50118 "Sales Line Archive Ext" extends "Sales Line Archive"
{
    fields
    {
        field(50100; Meter; Boolean)
        {
            Caption = 'Meter';
            DataClassification = ToBeClassified;
        }
        field(50105; "Meter Activity Code"; code[10])
        {
            Caption = 'Meter Activity Code';
            DataClassification = ToBeClassified;
            TableRelation = "Meter Activity" where(Reading = CONST(false));
        }
        field(50110; "Meter Serial No."; code[20])
        {
            caption = 'Meter Serial No.';
            FieldClass = FlowField;
            CalcFormula = Lookup(Meter."Serial No." WHERE("No." = FIELD("No.")));
            Editable = false;
        }
        field(50120; Rental; Boolean)
        {
            caption = 'Rental';
            DataClassification = ToBeClassified;
        }
        field(50130; "Rental Start Date"; date)
        {
            caption = 'Rental Start Date';
            DataClassification = ToBeClassified;
        }
        field(50140; "Rental End Date"; date)
        {
            caption = 'Rental End Date';
            DataClassification = ToBeClassified;
        }
        field(50145; "Rental Days"; Integer)
        {
            caption = 'Rental Days';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50150; "On Rent"; boolean)
        {
            caption = 'On Rent';
            DataClassification = ToBeClassified;
        }
        field(50155; "Resource Type"; Enum "Resource Type")
        {
            caption = 'Resource Type';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50250; "Start Time"; time)
        {
            Caption = 'Start Time';
            DataClassification = ToBeClassified;
        }
        field(50260; "End Time"; time)
        {
            Caption = 'End Time';
            DataClassification = ToBeClassified;
        }
        field(50310; "WO Supervisor"; code[20])
        {
            Caption = 'Work Order Supervisor';
            DataClassification = ToBeClassified;
            TableRelation = Resource where(Type = Const(Person));
        }
    }
}

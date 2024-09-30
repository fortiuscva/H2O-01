tableextension 50106 "Sales Cr.Memo Line Ext" extends "Sales Cr.Memo Line"
{
    fields
    {
        modify("No.")
        {
            CaptionClass = GetCaptionClass(FIELDNO("No."));
            Caption = 'No.';
            TableRelation = IF (Type = CONST("G/L Account")) "G/L Account"
            ELSE
            IF (Type = CONST(Item)) Item
            ELSE
            IF (Type = CONST(Resource)) Resource
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF (Type = CONST("Charge (Item)")) "Item Charge"
            ELSE
            IF (Type = CONST(Meter)) Meter;

            trigger OnAfterValidate()
            begin
                If Type = Type::Item then begin
                    MtrSetup.get;
                    SalesCMHeader.get("Document No.");
                    Mtr.RESET;
                    Mtr.SETRANGE("Customer No.", SalesCMHeader."Sell-to Customer No.");
                    IF MtrSetup."Req. Ship-to Code Sale" then
                        Mtr.SETRANGE("Ship-to Code", SalesCMHeader."Ship-to Code");
                    IF Mtr.FINDFIRST THEN
                        ERROR(Text50000, Mtr."No.", Mtr."Customer No.", Mtr."Ship-to Code");
                end;
            END;
        }
        field(50100; Meter; Boolean)
        {
            Caption = 'Meter';
            DataClassification = ToBeClassified;
        }
        field(50105; "Meter Activity Code"; code[10])
        {
            Caption = 'Meter Activity Code';
            DataClassification = ToBeClassified;
            TableRelation = "Meter Activity";
            trigger OnValidate()
            begin
                testfield(Type, Type::Meter);
            end;
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
        field(50200; "Original Document No."; code[20])
        {
            Caption = 'Original Document No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50205; "Original Line No."; integer)
        {
            Caption = 'Original Line No.';
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
        field(50330; "Original Completed Date"; date)
        {
            Caption = 'Original Completed Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50345; "Material Amount"; Decimal)
        {
            Caption = 'Material Amount';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50350; "Labor Amount"; Decimal)
        {
            Caption = 'Labor Amount';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50355; "Equipment Amount"; Decimal)
        {
            Caption = 'Equipment Amount';
            DataClassification = ToBeClassified;
            editable = false;
        }
        field(50360; "Location Comment"; boolean)
        {
            Caption = 'Equipment Amount';
            DataClassification = ToBeClassified;
            editable = false;
        }

    }



    var
        MtrSetup: record "Meter Setup";
        Mtr: record Meter;
        SalesCMHeader: record "Sales Cr.Memo Header";
        Text50000: TextConst ENU = 'Meter No. %1 is already assigned to Customer No. %2 and Ship-to Code %3.';
}

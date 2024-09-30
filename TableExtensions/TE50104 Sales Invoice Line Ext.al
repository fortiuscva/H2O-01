tableextension 50104 "Sales Invoice Line Ext" extends "Sales Invoice Line"
{
    fields
    {
        modify("No.")
        {
            CaptionClass = GetCaptionClass(FIELDNO("No."));
            TableRelation = IF (Type = CONST(" ")) "Standard Text"
            ELSE
            IF (Type = CONST("G/L Account"),
                    "System-Created Entry" = CONST(false)) "G/L Account" WHERE("Direct Posting" = CONST(true),
                        "Account Type" = CONST(Posting),
                        Blocked = CONST(false))
            ELSE
            IF (Type = CONST("G/L Account"),
                    "System-Created Entry" = CONST(true)) "G/L Account"
            ELSE
            IF (Type = CONST(Resource)) Resource
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF (Type = CONST("Charge (Item)")) "Item Charge"
            ELSE
            IF (Type = CONST(Item)) Item
            else
            IF (Type = CONST(Meter)) Meter;

            trigger OnAfterValidate()
            begin
                If Type = Type::Item then begin
                    MtrSetup.get;
                    SalesInvHeader.get("Document No.");
                    Mtr.RESET;
                    Mtr.SETRANGE("Customer No.", SalesInvHeader."Sell-to Customer No.");
                    IF MtrSetup."Req. Ship-to Code Sale" then
                        Mtr.SETRANGE("Ship-to Code", SalesInvHeader."Ship-to Code");
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
        field(50207; "Original Ship-to Code"; code[10])
        {
            Caption = 'Original Ship-to Code';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50208; "Original No."; code[20])
        {
            Caption = 'Original No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }

        field(50215; "Purchase Order No. 2"; code[20])
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            Caption = 'Purchase Order No.';
            //Editable = false;
            DataClassification = ToBeClassified;
            TableRelation = IF ("Drop Shipment 2" = CONST(true)) "Purchase Header"."No." WHERE("Document Type" = CONST(Order));
        }
        field(50217; "Purch. Order Line No. 2"; integer)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            Caption = 'Purch. Order Line No.';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Drop Shipment 2" = CONST(true)) "Purchase Line"."Line No." WHERE("Document Type" = CONST(Order),
                                                                                               "Document No." = FIELD("Purchase Order No. 2"));
        }
        field(50220; "Drop Shipment 2"; Boolean)
        {
            AccessByPermission = TableData "Drop Shpt. Post. Buffer" = R;
            Caption = 'Drop Shipment (INv)';
            Editable = true;
            DataClassification = ToBeClassified;
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
        field(50379; "WO Purpose"; boolean)
        {
            Caption = 'WO Purpose';
            DataClassification = ToBeClassified;
            editable = false;
        }
    }



    keys
    {
        key(Key30; "Original Document No.", "Original Line No.")
        { }
    }



    var
        MtrSetup: record "Meter Setup";
        Mtr: record Meter;
        SalesInvHeader: record "Sales Invoice Header";
        Text50000: TextConst ENU = 'Meter No. %1 is already assigned to Customer No. %2 and Ship-to Code %3.';
}

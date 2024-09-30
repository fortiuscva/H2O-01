tableextension 50117 "Sales Header Archive Ext" extends "Sales Header Archive"
{
    fields
    {
        field(50100; "Sent To Remote App"; Boolean)
        {
            Caption = 'Sent To Remote App';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50101; "Sent To Remote App Date"; Date)
        {
            Caption = 'Sent To Remote App Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50102; "Sent To Remote App Time"; Time)
        {
            Caption = 'Sent To Remote App Time';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50103; "Received From Remote App"; Boolean)
        {
            Caption = 'Received From Remote App';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50104; "Received From Remote App Date"; Date)
        {
            Caption = 'Received From Remote App Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50105; "Received From Remote App Time"; Time)
        {
            Caption = 'Received From Remote App Time';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50106; Flushed; Boolean)
        {
            Caption = 'Flushed';
            DataClassification = ToBeClassified;
        }
        field(50107; "Back Charged"; Boolean)
        {
            Caption = 'Back Charged';
            DataClassification = ToBeClassified;
        }
        field(50108; "Material Amount"; Decimal)
        {
            Caption = 'Material Amount';
            Editable = false;
            FieldClass = flowfield;
            CalcFormula = Sum("Sales Line Archive"."Amount Including VAT" WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), Type = CONST(Item)));
        }
        field(50109; "Labor Amount"; Decimal)
        {
            Caption = 'Labor Amount';
            Editable = false;
            FieldClass = flowfield;
            CalcFormula = Sum("Sales Line Archive"."Amount Including VAT" WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), Type = CONST(Resource), "Resource Type" = CONST(Person)));
        }
        field(50110; "Equipment Amount"; Decimal)
        {
            Caption = 'Equipment Amount';
            Editable = false;
            FieldClass = flowfield;
            CalcFormula = Sum("Sales Line Archive"."Amount Including VAT" WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), Type = CONST(Resource), "Resource Type" = CONST(Machine)));
        }
        field(50111; "Completed Date"; Date)
        {
            Caption = 'Completed Date';
            DataClassification = ToBeClassified;
        }
        field(50112; "Requested By"; Text[50])
        {
            Caption = 'Requested By';
            DataClassification = ToBeClassified;
        }
        field(50113; Emergency; boolean)
        {
            Caption = 'Emergency';
            DataClassification = ToBeClassified;
        }
        field(50114; Priority; enum Priority)
        {
            Caption = 'Priority';
            DataClassification = ToBeClassified;
        }
        field(50115; "Must Send To Mendix"; Boolean)
        {
            Caption = 'Must Send To Mendix';
            DataClassification = ToBeClassified;
        }
        field(50116; "Work Order Type Code"; code[10])
        {
            Caption = 'Work Order Type Code';
            DataClassification = ToBeClassified;
            TableRelation = "Work Order Type";
        }
        field(50117; "Work Order Status"; enum "Work Order Status")
        {
            Caption = 'Work Order Status';
            DataClassification = ToBeClassified;
        }
        field(50118; "Field Coordinator"; text[50])
        {
            Caption = 'Field Coordinator';
            DataClassification = ToBeClassified;
        }
        field(50120; "Include In Batch Invoicing"; boolean)
        {
            Caption = 'Include In Batch Invocing';
            DataClassification = ToBeClassified;
        }
        field(50125; "OK To Delete"; Boolean)
        {
            Caption = 'Include In Batch Invocing';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50130; Invoiced; boolean)
        {
            Caption = 'Invoiced';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50145; Purpose; Text[100])
        {
            Caption = 'Purpose';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50150; "Reponsible Technician"; code[20])
        {
            Caption = 'Reponsible Technician';
            DataClassification = ToBeClassified;
            TableRelation = Resource."No." where(Type = const(Person));
        }
    }
}
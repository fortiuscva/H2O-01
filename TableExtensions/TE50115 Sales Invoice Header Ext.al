tableextension 50115 "Sales Invoice Header Ext" extends "Sales Invoice Header"
{
    fields
    {
        field(50100; "Sent To Mendix"; Boolean)
        {
            Caption = 'Sent To Mendix';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50101; "Sent To Mendix Date"; Date)
        {
            Caption = 'Sent To Mendix Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50102; "Sent To Mendix Time"; Time)
        {
            Caption = 'Sent To Mendix Time';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50103; "Received From Mendix"; Boolean)
        {
            Caption = 'Received From Mendix';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50104; "Received From Mendix Date"; Date)
        {
            Caption = 'Received From Mendix Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50105; "Received From Mendix Time"; Time)
        {
            Caption = 'Received From Mendix Time';
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
            CalcFormula = Sum("Sales Invoice Line"."Material Amount" WHERE("Document No." = FIELD("No."), Type = CONST(Item)));
        }
        field(50109; "Labor Amount"; Decimal)
        {
            Caption = 'Labor Amount';
            Editable = false;
            FieldClass = flowfield;
            CalcFormula = Sum("Sales Invoice Line"."Labor Amount" WHERE("Document No." = FIELD("No."), Type = filter(Resource | Meter), "Resource Type" = CONST(Person)));
        }
        field(50110; "Equipment Amount"; Decimal)
        {
            Caption = 'Equipment Amount';
            Editable = false;
            FieldClass = flowfield;
            CalcFormula = Sum("Sales Invoice Line"."Equipment Amount" WHERE("Document No." = FIELD("No."), Type = CONST(Resource), "Resource Type" = CONST(Machine)));
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
        field(50135; "Work Order Due Date"; date)
        {
            Caption = 'Work Order Due Date';
            DataClassification = ToBeClassified;
        }
        field(50140; "Batch Invoice"; boolean)
        {
            Caption = 'Batch Invoice';
            DataClassification = ToBeClassified;
            editable = false;
        }
        field(50145; Purpose; Text[100])
        {
            Caption = 'Purpose';
            DataClassification = ToBeClassified;
        }
        field(50150; "Auto-Generated"; boolean)
        {
            Caption = 'Auto-Generated';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50155; "Generated From Source No."; code[20])
        {
            Caption = 'Generated From Source No.';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Sales Document Template"."Source Document No." where("Source Document Type" = CONST(Quote), "Source Document No." = FIELD("Generated From Source No."));
        }
        field(50160; "Generated from Meter Read Opp."; Boolean)
        {
            Caption = 'Generated From Meter Reading Opportunity';
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(50161; "Sent To Remote App"; Boolean)
        {
            Caption = 'Sent To Remote App';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50162; "Sent To Remote App Date"; Date)
        {
            Caption = 'Sent To Remote App Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50163; "Sent To Remote App Time"; Time)
        {
            Caption = 'Sent To Remote App Time';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50164; "Received From Remote App"; Boolean)
        {
            Caption = 'Received From Remote App';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50165; "Received From Remote App Date"; Date)
        {
            Caption = 'Received From Remote App Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50166; "Received From Remote App Time"; Time)
        {
            Caption = 'Received From Remote App Time';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50167; "Reponsible Technician"; code[20])
        {
            Caption = 'Reponsible Technician';
            DataClassification = ToBeClassified;
            TableRelation = Resource."No." where(Type = const(Person));
        }


    }


    procedure GetStatusStyleText2() StatusStyleText: Text
    begin
        if Priority = Priority::High then
            StatusStyleText := 'Unfavorable';
        If Priority = Priority::Medium then
            StatusStyleText := 'Favorable';
        If Priority = Priority::Low then
            StatusStyleText := 'Standard';
        //OnAfterGetStatusStyleText(Rec, StatusStyleText);
    end;

}
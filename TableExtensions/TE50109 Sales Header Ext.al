tableextension 50109 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
        modify("Ship-to Code")
        {
            trigger OnBeforeValidate()
            begin
                SalesLine2.reset;
                SalesLine2.setrange("Document Type", "Document Type");
                SalesLine2.setrange("Document No.", "No.");
                IF SalesLine2.findset then
                    repeat
                        SalesLine2."Original Ship-to Code" := "Ship-to Code";
                        SalesLine2.modify;
                    until SalesLine2.next = 0;
            end;
        }


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
            CalcFormula = Sum("Sales Line"."Material Amount" WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), Type = CONST(Item)));
        }
        field(50109; "Labor Amount"; Decimal)
        {
            Caption = 'Labor Amount';
            Editable = false;
            FieldClass = flowfield;
            CalcFormula = Sum("Sales Line"."Labor Amount" WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), Type = FILTER(Resource | Meter), "Resource Type" = CONST(Person)));
        }
        field(50110; "Equipment Amount"; Decimal)
        {
            Caption = 'Equipment Amount';
            Editable = false;
            FieldClass = flowfield;
            CalcFormula = Sum("Sales Line"."Equipment Amount" WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), Type = CONST(Resource), "Resource Type" = CONST(Machine)));
        }
        field(50111; "Completed Date"; Date)
        {
            Caption = 'Completed Date';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                testfield("Work Order Status", "Work Order Status"::Completed);
            end;
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
            trigger OnValidate()
            begin
                If Emergency then
                    Priority := Priority::High
                else
                    Priority := Priority::Low;
            end;
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
            trigger OnValidate()
            begin
                If "Work Order Status" = "Work Order Status"::Completed then begin
                    "Completed Date" := today;
                    SalesLine2.reset;
                    SalesLine2.setrange("Document Type", "Document Type");
                    SalesLine2.setrange("Document No.", "No.");
                    SalesLine2.setrange(Rental, true);
                    If SalesLine2.findset then
                        repeat
                            SalesLine2."On Rent" := false;
                            SalesLine2."Rental End Date" := "Completed Date";
                            SalesLine2."Rental Work Order No." := '';
                            SalesLine2.modify;
                        until SalesLine2.next = 0;



                end else
                    If "Work Order Status" = "Work Order Status"::"Ready For Invoicing" then
                        if Status <> Status::Released then
                            ReleaseSalesDoc.PerformManualRelease(Rec);
            end;
        }
        field(50118; "Field Coordinator"; code[20])
        {
            Caption = 'Field Coordinator';
            DataClassification = ToBeClassified;
            TableRelation = resource where(Type = Const(Person));
        }
        field(50120; "Include In Batch Invoicing"; boolean)
        {
            Caption = 'Include In Batch Invocing';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                If "Include in Batch Invoicing" = true then
                    testfield("Batch Invoice", false);
            end;
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
            //Editable = false;
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

            trigger OnValidate()
            begin
                IF "Batch Invoice" = true then
                    testfield("Include In Batch Invoicing", false);
                SalesInvSubform.BatchSet(rec);
            end;
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
    }



    var
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        SalesLine2: record "Sales Line";
        ResLedgEntry: record "Res. Ledger Entry";
        SalesInvSubform: page "Sales Invoice Subform";



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


    //obsolete version 23.
    /*
    procedure PerformManualRelease(var SalesHeader: Record "Sales Header")
    var
        BatchProcessingMgt: Codeunit "Batch Processing Mgt.";
        NoOfSelected: Integer;
        NoOfSkipped: Integer;
    begin
        NoOfSelected := SalesHeader.Count;
        SalesHeader.SetFilter(Status, '<>%1', SalesHeader.Status::Released);
        NoOfSkipped := NoOfSelected - SalesHeader.Count;
        BatchProcessingMgt.BatchProcess(SalesHeader, Codeunit::"Sales Manual Release", "Error Handling Options"::"Show Error", NoOfSelected, NoOfSkipped);
    end;
    */
    //obsolete version 23.


    procedure SetStyle() Style: Text
    var
        IsHandled: Boolean;
    begin
        //OnBeforeSetStyle(Style, IsHandled);
        if IsHandled Then
            exit(Style);

        if Emergency then begin
            exit('Unfavorable')
        end else
            exit('Standard');
        exit('');
    end;
}

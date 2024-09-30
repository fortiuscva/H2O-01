tableextension 50108 "Customer Ext" extends Customer
{

    fields
    {
        field(50100; "Meter Reading Day"; integer)
        {
            Caption = 'Meter Reading Date';
            DataClassification = ToBeClassified;
            MinValue = 1;
            MaxValue = 30;
            //TableRelation = "Meter Reading Pull Calendar"."Pull Day" where("Customer No." = field("No."));
        }
        field(50101; "Meter Reading Threshold"; decimal)
        {
            Caption = 'Meter Reading Threshold %';
            DataClassification = ToBeClassified;
        }
        field(50103; "Must Send To Mendix"; Boolean)
        {
            Caption = 'Must Send To Mendix';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50105; "Sent To Mendix"; Boolean)
        {
            Caption = 'Sent To Mendix';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50110; "Sent To Mendix Date"; Date)
        {
            Caption = 'Sent To Mendix Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50115; "Sent To Mendix Time"; Time)
        {
            Caption = 'Sent To Mendix Time';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50117; "Must Send To Opus"; Boolean)
        {
            Caption = 'Must Send To Opus';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50120; "Sent To Opus"; Boolean)
        {
            Caption = 'Sent To Opus';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50125; "Sent To Opus Date"; Date)
        {
            Caption = 'Sent To Opus Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50130; "Sent To Opus Time"; Time)
        {
            Caption = 'Sent To Opus Time';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50135; "No Ship-to Name"; Boolean)
        {
            Caption = 'No Ship-to Name';
            DataClassification = ToBeClassified;
        }
        field(50140; "No. of Ship-tos"; integer)
        {
            Caption = 'No. of Ship-tos';
            TableRelation = "Ship-to Address".Code where("Customer No." = field("No."));
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("Ship-to Address" WHERE("Customer No." = FIELD("No.")));
        }
        field(50145; "No. of Meters"; integer)
        {
            Caption = 'No. of Meters';
            TableRelation = Meter."No." where("Customer No." = field("No."));
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count(Meter WHERE("Customer No." = FIELD("No.")));
        }
        field(50150; "No. of Open Work Orders"; integer)
        {
            caption = 'No. of Open Work Orders';
            TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST(Invoice), "Sell-to Customer No." = FIELD("No."));
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("Sales Header" WHERE("Document Type" = CONST(Invoice), "Sell-to Customer No." = FIELD("No.")));
        }
        field(50160; "Report ID"; integer)
        {
            Caption = 'Sales Invoice Report ID';
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Report));
        }
        field(50170; "Batch Invoice Day"; integer)
        {
            Caption = 'Batch Invoice Day';
            DataClassification = ToBeClassified;
            MinValue = 1;
            MaxValue = 30;
        }
        field(50180; "Opus Transmission Day"; integer)
        {
            Caption = 'Opus Transmission Day';
            DataClassification = ToBeClassified;
            MinValue = 1;
            MaxValue = 30;
        }
        field(50190; "Min. Location Stop"; code[20])
        {
            Caption = 'Min. Location Stop';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Min("Ship-to Address"."Location Stop" where("Customer No." = field("No.")));
        }
        field(50200; "Max. Location Stop"; code[20])
        {
            Caption = 'Max. Location Stop';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Max("Ship-to Address"."Location Stop" where("Customer No." = field("No.")));
        }
    }


    var
        MtrSetup: record "Meter Setup";



    trigger OnInsert()
    begin
        "Must Send To Opus" := true;
        "Sent To Opus" := false;
        "Sent To Opus Date" := 0D;
        "Sent To Opus Time" := 0T;

        "Must Send To Mendix" := true;
        "Sent To Mendix" := false;
        "Sent To Mendix Date" := 0D;
        "Sent To Mendix Time" := 0T;

        IF MtrSetup.get then begin
            "Meter Reading Day" := MtrSetup."Meter Reading Day";
            "Batch Invoice Day" := MtrSetup."Batch Invoice Day";
            "Opus Transmission Day" := MtrSetup."Opus Transmission Day";
        end;
    end;


    trigger OnModify()
    begin
        IF (rec.Name <> xrec.Name) or
            (rec."Name 2" <> xrec."Name 2") or
            (rec.Address <> xrec.Address) or
            (rec."Address 2" <> xrec."Address 2") or
            (rec.City <> xrec.City) Or
            (rec.County <> xrec.County) or
            (rec."Post Code" <> xrec."Post Code") or
            (rec."Country/Region Code" <> xrec."Country/Region Code") or
            (rec."Phone No." <> xrec."Phone No.") or
            (rec."E-Mail" <> xrec."e-mail") or
            (rec.Contact <> xrec.Contact) or
            (rec."Payment Terms Code" <> xrec."Payment Terms Code") then begin
            //If "Last Date Modified" > "Sent to Opus Date" then begin
            "Must Send To Opus" := true;
            "Sent To Opus" := false;
            "Sent To Opus Date" := 0D;
            "Sent To Opus Time" := 0T;

            //If "Last Date Modified" > "Sent to Mendix Date" then begin
            "Must Send To Mendix" := true;
            "Sent To Mendix" := false;
            "Sent To Mendix Date" := 0D;
            "Sent To Mendix Time" := 0T;
        end;
    end;


}

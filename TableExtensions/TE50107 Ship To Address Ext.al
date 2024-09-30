tableextension 50107 "Ship-To Address Ext" extends "Ship-to Address"
{
    fields
    {
        modify(Code)
        {
            caption = 'Property No.';
        }


        field(50100; "Sent To Opus"; Boolean)
        {
            Caption = 'Sent To Opus';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50101; "Sent To Opus Date"; Date)
        {
            Caption = 'Sent To Opus Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50102; "Sent To Opus Time"; Time)
        {
            Caption = 'Sent To Opus Time';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50103; "Sent To Mendix"; Boolean)
        {
            Caption = 'Sent To Mendix';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50104; "Sent To Mendix Date"; Date)
        {
            Caption = 'Sent To Mendix Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50105; "Sent To Mendix Time"; Time)
        {
            Caption = 'Sent To Mendix Time';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50106; "Must Send To Opus"; boolean)
        {
            Caption = 'Must Send To Opus';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50107; "Must Send To Mendix"; boolean)
        {
            Caption = 'Must Send To Mendix';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50108; "Route No."; Integer)
        {
            Caption = 'Route No.';
            DataClassification = ToBeClassified;
            TableRelation = Route."No." where("Customer No." = field("Customer No."));
        }
        field(50109; "Location Stop"; Code[20])
        {
            Caption = 'Location Stop';
            DataClassification = ToBeClassified;
        }
        field(50110; "No. of Units"; integer)
        {
            Caption = 'No. of Units';
            DataClassification = ToBeClassified;
        }
        field(50111; Blocked; boolean)
        {
            Caption = 'Blocked';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                IF (rec.Blocked <> xrec.Blocked) AND rec.Blocked = true then begin
                    Mtr.setrange("Customer No.", rec."Customer No.");
                    Mtr.setrange("Ship-to Code", rec.Code);
                    If Mtr.findset then
                        repeat
                            Mtr.Blocked := true;
                            Mtr.modify;
                        until Mtr.next = 0;
                end;
            end;
        }
        field(50112; "Opus Account No."; code[20])
        {
            Caption = 'Opus Account No.';
            DataClassification = ToBeClassified;
        }
        field(50113; "Derived Account No."; code[20])
        {
            Caption = 'Derived Account No.';
            DataClassification = ToBeClassified;
        }
    }


    keys
    {
        key(Key50; "Location Stop")
        { }
    }


    var
        Cust: record Customer;
        Mtr: record Meter;



    trigger OnInsert()
    begin
        "Must Send To Opus" := true;
        "Sent To Opus" := false;
        "Sent To Opus Date" := today;
        "Sent To Opus Time" := 0T;

        "Must Send To Mendix" := true;
        "Sent To Mendix" := false;
        "Sent To Mendix Date" := 0D;
        "Sent To Mendix Time" := 0T;

        If Cust.get("Customer No.") then
            IF Cust."No Ship-to Name" then
                Name := ''
            else
                Name := Cust.Name;
    end;


    trigger OnModify()
    begin
        If (rec.Name <> xrec.Name) or
            (rec."Name 2" <> xrec."Name 2") or
            (rec.Address <> xrec.Address) or
            (rec."Address 2" <> xrec."Address 2") or
            (rec.City <> xrec.City) or
            (rec.County <> xrec.County) or
            (rec."Post Code" <> xrec."Post Code") or
            (rec."Phone No." <> xrec."Phone No.") or
            (rec."E-Mail" <> xrec."E-Mail") then begin

            "Must Send To Opus" := true;
            "Sent To Opus" := false;
            "Sent To Opus Date" := 0D;
            "Sent To Opus Time" := 0T;

            "Must Send To Mendix" := true;
            "Sent To Mendix" := false;
            "Sent To Mendix Date" := 0D;
            "Sent To Mendix Time" := 0T;
        end;
    end;


}
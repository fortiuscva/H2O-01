table 50102 "Meter Ledger Entry"
{
    Caption = 'Meter Ledger Entry';
    DataClassification = ToBeClassified;
    LookupPageId = "Meter Ledger Entries";
    DrillDownPageId = "Meter Ledger Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
        }
        field(10; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
        }
        field(15; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;
        }
        field(20; "Meter No."; Code[20])
        {
            Caption = 'Meter No.';
            DataClassification = ToBeClassified;
            TableRelation = Meter;
        }
        field(25; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(30; "Description 2"; Text[100])
        {
            Caption = 'Description 2';
            DataClassification = ToBeClassified;
        }
        field(35; "Meter Activity Code"; Code[10])
        {
            Caption = 'Meter Activity Code';
            DataClassification = ToBeClassified;
            TableRelation = "Meter Activity";
        }
        field(40; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            DataClassification = ToBeClassified;
        }
        field(45; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            DataClassification = ToBeClassified;
        }
        field(50; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            DataClassification = ToBeClassified;
            TableRelation = "Source Code";
        }
        field(55; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            DataClassification = ToBeClassified;
            TableRelation = "Meter Journal Batch";
        }
        field(60; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            DataClassification = ToBeClassified;
            TableRelation = "Reason Code";
        }
        field(65; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Business Posting Group";
        }
        field(70; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group";
        }
        field(75; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = ToBeClassified;
        }
        field(80; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            DataClassification = ToBeClassified;
        }
        field(85; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
        }
        field(90; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(100; "Previous Meter Reading"; Decimal)
        {
            Caption = 'Previous Meter Reading';
            DataClassification = ToBeClassified;
        }
        field(105; "Current Meter Reading"; Decimal)
        {
            Caption = 'Current Meter Reading';
            DataClassification = ToBeClassified;
        }
        field(110; "Water Usage"; Decimal)
        {
            Caption = 'Water Usage';
            DataClassification = ToBeClassified;
        }
        field(115; "Previous Meter Reading Date"; Date)
        {
            Caption = 'Previous Meter Reading Date';
            DataClassification = ToBeClassified;
        }
        field(120; "Current Meter Reading Date"; Date)
        {
            Caption = 'Current Meter Reading Date';
            DataClassification = ToBeClassified;
        }
        field(125; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            DataClassification = ToBeClassified;
        }
        field(130; "Ship-to Code"; Code[10])
        {
            Caption = 'Property No.';
            DataClassification = ToBeClassified;
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Customer No."));
        }
        field(135; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = ToBeClassified;
        }
        field(138; "Must Send To Opus"; boolean)
        {
            caption = 'Must Send To Opus';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(140; "Sent To Opus"; Boolean)
        {
            caption = 'Sent To Opus';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(145; "Sent To Opus Date"; date)
        {
            caption = 'Sent To Opus Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(150; "Sent To Opus Time"; time)
        {
            caption = 'Sent To Opus Time';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(155; "Meter Reading"; Boolean)
        {
            caption = 'Meter Reading';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(160; "Re-read Required"; Boolean)
        {
            caption = 'Re-read Required';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(165; "Meter Reading Threshold"; decimal)
        {
            caption = 'Meter Reading Threshold';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(170; "Date Filter"; date)
        {
            FieldClass = flowfilter;
            caption = 'Date Filter';
        }
        field(175; "Serial No."; code[20])
        {
            caption = 'Serial No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(180; Corrected; Boolean)
        {
            caption = 'Corrected';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(185; "Corrected Entry No."; integer)
        {
            caption = 'Corrected Entry No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(190; "Corrected Date"; date)
        {
            caption = 'Corrected Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(195; "Curr. Mtr. Read (Original)"; decimal)
        {
            caption = 'Curr. Mtr. Read (Original)';
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }



    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Meter No.", "Posting Date")
        { }
    }


    fieldgroups
    {
        fieldgroup(DropDown; "Entry No.", "Meter No.", "Meter Activity Code", "Current Meter Reading") { }
    }



    var
        DimMgt: Codeunit DimensionManagement;
        MtrActivity: record "Meter Activity";


    trigger OnInsert()
    begin
        If "Meter Reading" then begin
            "Must Send To Opus" := true;
            "Sent To Opus" := false;
            "Sent To Opus Date" := 0D;
            "Sent To Opus Time" := 0T;
        end;

    end;


    procedure CopyFromMtrJnlLine(MtrJnlLine: Record "Meter Journal Line")
    var
        MtrSetup: record "Meter Setup";
        Text004: TextConst ENU = 'Applies-to Entry No. cannot be zero';
    begin
        MtrSetup.get;

        "Document No." := MtrJnlLine."Document No.";
        "External Document No." := MtrJnlLine."External Document No.";
        "Posting Date" := MtrJnlLine."Posting Date";
        "Document Date" := MtrJnlLine."Document Date";
        "Meter No." := MtrJnlLine."Meter No.";
        "Serial No." := MtrJnlLine."Serial No.";
        //"Meter Group No." := MtrJnlLine."Meter Group No.";
        Description := MtrJnlLine.Description;
        "Description 2" := MtrJnlLine."Description 2";
        "Global Dimension 1 Code" := MtrJnlLine."Shortcut Dimension 1 Code";
        "Global Dimension 2 Code" := MtrJnlLine."Shortcut Dimension 2 Code";
        "Dimension Set ID" := MtrJnlLine."Dimension Set ID";
        "Source Code" := MtrJnlLine."Source Code";
        "Journal Batch Name" := MtrJnlLine."Journal Batch Name";
        "Reason Code" := MtrJnlLine."Reason Code";
        "Gen. Bus. Posting Group" := MtrJnlLine."Gen. Bus. Posting Group";
        "Gen. Prod. Posting Group" := MtrJnlLine."Gen. Prod. Posting Group";
        "No. Series" := MtrJnlLine."Posting No. Series";
        "Source Code" := MtrJnlLine."Source Code";

        "Current Meter Reading" := MtrJnlLine."Current Meter Reading";
        "Current Meter Reading Date" := MtrJnlLine."Current Meter Reading Date";
        "Previous Meter Reading" := MtrJnlLine."Previous Meter Reading";
        "Previous Meter Reading Date" := MtrJnlLine."Previous Meter Reading Date";
        "Water Usage" := MtrJnlLine."Water Usage";
        "Customer No." := MtrJnlLine."Customer No.";
        "Meter Activity Code" := MtrJnlLine."Meter Activity Code";
        "Meter Reading" := MtrJnlLine."Meter Reading";
        "Re-read Required" := MtrJnlLine."Re-read Required";
        "Meter Reading Threshold" := MtrJnlLine."Meter Reading Threshold";
        //"Ship-to Code" := MtrJnlLine."Ship-to Code";

        If MtrSetup."Req. Ship-to Code Read" then begin
            MtrJnlLine.testfield("Ship-to Code");
            "Ship-to Code" := MtrJnlLine."Ship-to Code";
        end;

        If "Source Code" <> 'SALES' then begin
            MtrActivity.reset;
            MtrActivity.setrange(Reading, true);
            IF MtrActivity.findfirst then begin
                "Meter Reading" := true;
                "Meter Activity Code" := MtrActivity.Code;
            end;
        end else
            "Meter Activity Code" := MtrJnlLine."Meter Activity Code";

        If MtrJnlLine.Correction then begin
            Corrected := true;
            If (Corrected) and (MtrJnlLine."Applies-to Entry No." = 0) then
                error(Text004)
            else begin
                "Corrected Entry No." := MtrJnlLine."Applies-to Entry No.";
                "Corrected Date" := MtrJnlLine."Posting Date";
                "Curr. Mtr. Read (Original)" := MtrJnlLine."Curr. Mtr. Read (Original)";
            end;
        end;
    end;


    procedure ShowDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "Entry No."));
    end;
}

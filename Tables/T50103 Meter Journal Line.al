table 50103 "Meter Journal Line"
{
    Caption = 'Meter Journal Line';
    DataClassification = ToBeClassified;
    LookupPageId = "Meter Journal";
    DrillDownPageId = "Meter Journal";

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            DataClassification = ToBeClassified;
            TableRelation = "Meter Journal Template";
        }
        field(2; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            DataClassification = ToBeClassified;
            TableRelation = "Meter Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name"));
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
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
            trigger OnValidate()
            begin
                VALIDATE("Document Date", "Posting Date");
            end;
        }
        field(20; "Meter No."; Code[20])
        {
            Caption = 'Meter No.';
            DataClassification = ToBeClassified;
            TableRelation = Meter;
            trigger OnValidate()
            begin
                Mtr.GET("Meter No.");
                Mtr.TESTFIELD(Blocked, FALSE);
                Description := Mtr.Description;
                "Description 2" := Mtr."Description 2";
                "Serial No." := Mtr."Serial No.";
                validate("Meter Group Code", Mtr."Meter Group Code");
                validate("Gen. Prod. Posting Group", Mtr."Gen. Prod. Posting Group");
                validate("Shortcut Dimension 1 Code", Mtr."Global Dimension 1 Code");
                validate("Shortcut Dimension 2 Code", Mtr."Global Dimension 2 Code");
                validate("Customer No.", Mtr."Customer No.");
                validate("Ship-to Code", Mtr."Ship-to Code");
                "Current Meter Reading Date" := workdate;
                "Meter Reading" := true;

                MtrActivity.reset;
                MtrActivity.setrange(Reading, true);
                IF MtrActivity.findfirst then
                    validate("Meter Activity Code", MtrActivity.Code);

                UpdateMeter;
            end;
        }
        field(25; "Meter Group Code"; Code[10])
        {
            Caption = 'Meter Group No.';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Meter Group";
        }
        field(30; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(35; "Description 2"; Text[100])
        {
            Caption = 'Description 2';
            DataClassification = ToBeClassified;
        }
        field(40; "Shortcut Dimension 1 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(45; "Shortcut Dimension 2 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(50; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Source Code";
        }
        field(55; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            DataClassification = ToBeClassified;
        }
        field(60; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Business Posting Group";
        }
        field(65; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group";
        }
        field(70; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = ToBeClassified;
        }
        field(75; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            DataClassification = ToBeClassified;
        }
        field(80; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(85; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(90; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            DataClassification = ToBeClassified;
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Customer No."));
        }
        field(95; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Set Entry";
            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(100; "Previous Meter Reading"; Decimal)
        {
            Caption = 'Previous Meter Reading';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(105; "Current Meter Reading"; Decimal)
        {
            Caption = 'Current Meter Reading';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                UpdateMeter2;

                IF "Current Meter Reading" = 0 then begin
                    "Water Usage" := 0;
                end;

                If (Rec."Current Meter Reading" <> xRec."Current Meter Reading") AND (Rec."Current Meter Reading" <> 0) then begin
                    IF "Current Meter Reading" < "Previous Meter Reading" THEN begin
                        "Water Usage" := 0;
                        ERROR(Text001, FORMAT("Current Meter Reading"), FORMAT("Previous Meter Reading"));
                    end;
                end;

                If Correction then
                    "Curr. Mtr. Read (Original)" := "Current Meter Reading";
            end;
        }
        field(110; "Water Usage"; Decimal)
        {
            Caption = 'Water Usage';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(115; "Previous Meter Reading Date"; Date)
        {
            Caption = 'Previous Meter Reading Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(120; "Current Meter Reading Date"; Date)
        {
            Caption = 'Current Meter Reading Date';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                testfield("Current Meter Reading");
            end;
        }
        field(130; "Received From Mendix"; Boolean)
        {
            caption = 'Received From Mendix';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(135; "Received From Mendix Date"; date)
        {
            caption = 'Received From Mendix Date';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(140; "Received From Mendix Time"; time)
        {
            caption = 'Received From Mendix Time';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(145; "Meter Activity Code"; code[10])
        {
            caption = 'Meter Activity Code';
            DataClassification = ToBeClassified;
            TableRelation = "Meter Activity";
        }
        field(150; "Re-read Required"; Boolean)
        {
            caption = 'Re-read Required';
            DataClassification = ToBeClassified;
        }
        field(155; "Meter Reading Threshold"; Decimal)
        {
            caption = 'Meter Reading Threshold';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(160; Image; Media)
        {
            Caption = 'Image';
        }
        field(165; "Serial No."; code[20])
        {
            caption = 'Serial No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(170; "Meter Reading"; boolean)
        {
            caption = 'Meter Reading';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(175; "Meter Trouble Code"; code[10])
        {
            caption = 'Meter Trouble Code';
            DataClassification = ToBeClassified;
            TableRelation = "Trouble Code";

            trigger OnValidate()
            begin
                CreateTrouble(rec);
            end;
        }
        field(180; "Meter Skip Code"; code[10])
        {
            caption = 'Meter Skip Code';
            DataClassification = ToBeClassified;
            TableRelation = "Skip Code";

            trigger OnValidate()
            begin
                CreateSkip(rec);
            end;
        }
        field(190; Correction; boolean)
        {
            caption = 'Correction';
            DataClassification = ToBeClassified;
        }
        field(200; "Applies-to Entry No."; integer)
        {
            caption = 'Applies-to Entry No.';
            DataClassification = ToBeClassified;
            TableRelation = "Meter Ledger Entry"."Entry No." where("Meter No." = field("Meter No."));
            trigger OnValidate()
            var
                MLE: record "Meter Ledger Entry";
            begin
                testfield(Correction);

                If "Applies-to Entry No." <> 0 then
                    IF MLE.get("Applies-to Entry No.") then begin
                        validate("Meter No.", MLE."Meter No.");
                        validate("Serial No.", MLE."Serial No.");
                        "Current Meter Reading" := MLE."Current Meter Reading";
                        "Current Meter Reading Date" := MLE."Current Meter Reading Date";
                        If Mtr.get(MLE."Meter No.") then begin
                            mtr.CalcFields("Global Dimension 1 Code");
                            validate("Shortcut Dimension 1 Code", Mtr."Global Dimension 1 Code");
                            validate("Shortcut Dimension 2 Code", Mtr."Global Dimension 2 Code");
                        end;
                        //modify();
                    end;
            end;
        }
        field(205; "Curr. Mtr. Read (Original)"; decimal)
        {
            caption = 'Curr. Mtr. Read (Original)';
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }


    keys
    {
        key(PK; "Journal Template Name", "Journal Batch Name", "Line No.")
        {
            Clustered = true;
        }
    }


    var
        MtrJnlTemplate: Record "Meter Journal Template";
        MtrJnlBatch: Record "Meter Journal Batch";
        MtrJnlLine: Record "Meter Journal Line";
        MtrLedgEntry: Record "Meter Ledger Entry";
        Mtr: Record Meter;
        MtrActivity: Record "Meter Activity";
        MtrSetup: record "Meter Setup";
        Cust: record Customer;
        GLSetup: Record "General Ledger Setup";
        MtrReadOpp: record "Meter Read Opportunity";
        NoSeriesMgt: Codeunit "No. Series";
        DimMgt: Codeunit DimensionManagement;
        GLSetupRead: Boolean;
        Text001: TextConst ENU = 'Current Meter Reading of %1 cannot be less than Previous Meter Reading of %2.';


    trigger OnInsert()
    begin
        LOCKTABLE;
        MtrJnlTemplate.GET("Journal Template Name");
        MtrJnlBatch.GET("Journal Template Name", "Journal Batch Name");

        ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
        ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
    end;


    procedure EmptyLine(): Boolean
    begin
        EXIT("Meter No." = '');
    end;


    procedure SetUpNewLine(LastMtrJnlLine: Record "Meter Journal Line")
    begin
        MtrJnlTemplate.GET("Journal Template Name");
        MtrJnlBatch.GET("Journal Template Name", "Journal Batch Name");
        MtrJnlLine.SETRANGE("Journal Template Name", "Journal Template Name");
        MtrJnlLine.SETRANGE("Journal Batch Name", "Journal Batch Name");
        IF MtrJnlLine.FINDFIRST THEN BEGIN
            "Posting Date" := LastMtrJnlLine."Posting Date";
            "Document Date" := LastMtrJnlLine."Posting Date";
            "Document No." := LastMtrJnlLine."Document No.";
        END ELSE BEGIN
            "Posting Date" := WORKDATE;
            "Document Date" := WORKDATE;
            IF MtrJnlBatch."No. Series" <> '' THEN BEGIN
                CLEAR(NoSeriesMgt);
                //"Document No." := NoSeriesMgt.TryGetNextNo(MtrJnlBatch."No. Series", "Posting Date");
            END;
        END;
        "Source Code" := MtrJnlTemplate."Source Code";
        "Reason Code" := MtrJnlBatch."Reason Code";
        "Posting No. Series" := MtrJnlBatch."Posting No. Series";

        MtrActivity.reset;
        MtrActivity.setrange(Reading, true);
        IF MtrActivity.findfirst then
            "Meter Activity Code" := MtrActivity.Code;
    end;


    local procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20]; Type3: Integer; No3: Code[20])
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        TableID[3] := Type3;
        No[3] := No3;

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        //"Dimension Set ID" :=
        //  DimMgt.GetRecDefaultDimID(
        //    Rec, CurrFieldNo, TableID, No, "Source Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; VAR ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;


    procedure LookupShortcutDimCode(FieldNumber: Integer; VAR ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;


    procedure ShowShortcutDimCode(VAR ShortcutDimCode: ARRAY[8] OF Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;


    procedure CopyDocumentFields(DocNo: Code[20]; ExtDocNo: Text[35]; SourceCode: Code[10]; NoSeriesCode: Code[20])
    begin
        "Document No." := DocNo;
        "External Document No." := ExtDocNo;
        "Source Code" := SourceCode;
        IF NoSeriesCode <> '' THEN
            "Posting No. Series" := NoSeriesCode;
    end;


    local procedure GetGLSetup()
    begin
        IF NOT GLSetupRead THEN
            GLSetup.GET;
        GLSetupRead := TRUE;
    end;


    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2 %3', "Journal Template Name", "Journal Batch Name", "Line No."));
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;


    procedure IsOpenedFromBatch(): Boolean
    var
        MtrJournalBatch: Record "Meter Journal Batch";
        TemplateFilter: Text;
        BatchFilter: Text;
    begin
        BatchFilter := GETFILTER("Journal Batch Name");
        IF BatchFilter <> '' THEN BEGIN
            TemplateFilter := GETFILTER("Journal Template Name");
            IF TemplateFilter <> '' THEN
                MtrJournalBatch.SETFILTER("Journal Template Name", TemplateFilter);
            MtrJournalBatch.SETFILTER(Name, BatchFilter);
            MtrJournalBatch.FINDFIRST;
        END;

        EXIT((("Journal Batch Name" <> '') AND ("Journal Template Name" = '')) OR (BatchFilter <> ''));
    end;


    local procedure UpdateMeter()
    begin
        MtrSetup.get;

        "Re-read Required" := false;

        IF "Meter No." = '' THEN BEGIN
            "Previous Meter Reading" := 0;
            "Previous Meter Reading Date" := 0D;
            "Current Meter Reading" := 0;
            "Current Meter Reading Date" := 0D;
        END ELSE BEGIN
            MtrLedgEntry.RESET;
            MtrLedgEntry.SETCURRENTKEY("Meter No.", "Posting Date");
            MtrLedgEntry.SETRANGE("Meter No.", "Meter No.");
            MtrLedgEntry.setrange("Meter Reading", true);
            IF MtrLedgEntry.FINDLAST THEN BEGIN
                "Previous Meter Reading" := MtrLedgEntry."Current Meter Reading";
                "Previous Meter Reading Date" := MtrLedgEntry."Current Meter Reading Date";
                "Meter Reading Threshold" := "Previous Meter Reading" * (MtrSetup."Meter Reading Threshold" / 100);

                If Cust.get("Customer No.") then
                    If Cust."Meter Reading Threshold" <> 0 then begin
                        "Meter Reading Threshold" := "Previous Meter Reading" * (Cust."Meter Reading Threshold" / 100);
                    end;

            END ELSE BEGIN
                "Previous Meter Reading" := 0;
                "Previous Meter Reading Date" := 0D;
                "Meter Reading Threshold" := 0;
            END;
        end;
    end;


    local procedure UpdateMeter2()
    begin
        "Water Usage" := "Current Meter Reading" - "Previous Meter Reading";

        IF "Water Usage" > "Meter Reading Threshold" then
            "Re-read Required" := true;

        If "Current Meter Reading" = 0 then
            "Re-read Required" := false;

        If "Previous Meter Reading" = 0 then
            "Re-read Required" := false;
    end;


    procedure SwitchLinesWithErrorsFilter(var ShowAllLinesEnabled: Boolean)
    var
        TempErrorMessage: Record "Error Message" temporary;
        MtrJournalErrorsMgt: Codeunit "Meter Journal Errors Mgt.";
    begin
        if ShowAllLinesEnabled then begin
            MarkedOnly(false);
            ShowAllLinesEnabled := false;
        end else begin
            MtrJournalErrorsMgt.GetErrorMessages(TempErrorMessage);
            if TempErrorMessage.FindSet() then
                repeat
                    if Rec.Get(TempErrorMessage."Context Record ID") then
                        Rec.Mark(true)
                until TempErrorMessage.Next() = 0;
            MarkedOnly(true);
            ShowAllLinesEnabled := true;
        end;
    end;


    procedure CopyFromSalesHeader2(SalesHeader: Record "Sales Header")
    begin
        "Posting Date" := SalesHeader."Posting Date";
        "Document Date" := SalesHeader."Document Date";
        //"Document No." := SalesHeader."No.";
        //"Reason Code" := SalesHeader."Reason Code";
        "Customer No." := SalesHeader."Sell-to Customer No.";
        "Ship-to Code" := SalesHeader."Ship-to Code";
        //"External Document No." := SalesHeader."External Document No.";
    end;


    procedure CopyFromSalesLine2(SalesLine: Record "Sales Line")
    begin
        "Meter No." := SalesLine."No.";
        Description := SalesLine.Description;
        "Meter Activity Code" := SalesLine."Meter Activity Code";
        "Shortcut Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
        "Shortcut Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
        "Dimension Set ID" := SalesLine."Dimension Set ID";
        "Gen. Bus. Posting Group" := SalesLine."Gen. Bus. Posting Group";
        "Gen. Prod. Posting Group" := SalesLine."Gen. Prod. Posting Group";
    end;


    procedure CopyDocumentFields2(DocNo: Code[20]; ExtDocNo: Text[35]; SourceCode: Code[10]; NoSeriesCode: Code[20])
    begin
        "Document No." := DocNo;
        "External Document No." := ExtDocNo;
        "Source Code" := SourceCode;
        if NoSeriesCode <> '' then
            "Posting No. Series" := NoSeriesCode;
    end;


    procedure CreateTrouble(TroubleMtrJnlLine: Record "Meter Journal Line")
    begin
        MtrReadOpp.reset;
        MtrReadOpp.setrange("Customer No.", "Customer No.");
        MtrReadOpp.setrange("Ship-to Code", "Ship-to Code");
        MtrReadOpp.setrange("Meter No.", "Meter No.");
        MtrReadOpp.setrange("Trouble Code", "Meter Trouble Code");
        If Not MtrReadOpp.findfirst then begin
            MtrReadOpp.init;
            MtrReadOpp.validate("Journal Template Name", "Journal Template Name");
            MtrReadOpp.validate("Journal Batch Name", "Journal Batch Name");
            MtrReadOpp.validate("Line No.", "Line No.");
            MtrReadOpp.validate("Customer No.", "Customer No.");
            MtrReadOpp.validate("Ship-to Code", "Ship-to Code");
            MtrReadOpp.validate("Meter No.", "Meter No.");
            MtrReadOpp.validate("Trouble Code", "Meter Trouble Code");
            MtrReadOpp."Date Read" := "Posting Date";
            MtrReadOpp."Resource No." := "Journal Batch Name";
            MtrReadOpp.insert;
        end;
    end;


    procedure CreateSkip(SkipMtrJnlLine: Record "Meter Journal Line")
    begin
        MtrReadOpp.reset;
        MtrReadOpp.setrange("Customer No.", "Customer No.");
        MtrReadOpp.setrange("Ship-to Code", "Ship-to Code");
        MtrReadOpp.setrange("Meter No.", "Meter No.");
        MtrReadOpp.setrange("Skip Code", "Meter Skip Code");
        If Not MtrReadOpp.findfirst then begin
            MtrReadOpp.init;
            MtrReadOpp.validate("Customer No.", "Customer No.");
            MtrReadOpp.validate("Ship-to Code", "Ship-to Code");
            MtrReadOpp.validate("Meter No.", "Meter No.");
            MtrReadOpp.validate("Skip Code", "Meter Skip Code");
            MtrReadOpp."Date Read" := "Posting Date";
            MtrReadOpp."Resource No." := "Journal Batch Name";
            MtrReadOpp.insert;
        end;
    end;

}
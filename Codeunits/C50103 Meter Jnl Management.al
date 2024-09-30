codeunit 50103 "Meter Jnl Management"
{
    procedure TemplateSelection(PageID: Integer; VAR MtrJnlLine: Record "Meter Journal Line"; VAR JnlSelected: Boolean)
    var
        MtrJnlTemplate: record "Meter Journal Template";
    begin
        JnlSelected := TRUE;

        MtrJnlTemplate.RESET;
        MtrJnlTemplate.SETRANGE("Page ID", PageID);

        CASE MtrJnlTemplate.COUNT OF
            0:
                BEGIN
                    MtrJnlTemplate.INIT;
                    MtrJnlTemplate.Name := Text000;
                    MtrJnlTemplate.Description := Text001;
                    MtrJnlTemplate.VALIDATE("Page ID");
                    MtrJnlTemplate.INSERT;
                    COMMIT;
                END;
            1:
                MtrJnlTemplate.FINDFIRST;
            ELSE
                JnlSelected := PAGE.RUNMODAL(0, MtrJnlTemplate) = ACTION::LookupOK;
        END;
        IF JnlSelected THEN BEGIN
            MtrJnlLine.FILTERGROUP := 2;
            MtrJnlLine.SETRANGE("Journal Template Name", MtrJnlTemplate.Name);
            MtrJnlLine.FILTERGROUP := 0;
            IF OpenFromBatch THEN BEGIN
                MtrJnlLine."Journal Template Name" := '';
                PAGE.RUN(MtrJnlTemplate."Page ID", MtrJnlLine);
            END;
        END;
    end;


    procedure TemplateSelectionFromBatch(VAR MtrJnlBatch: Record "Meter Journal Batch")
    var
        MtrJnlLine: Record "Meter Journal Line";
        MtrJnlTemplate: Record "Meter Journal Template";
    begin
        OpenFromBatch := TRUE;
        MtrJnlTemplate.GET(MtrJnlBatch."Journal Template Name");
        MtrJnlTemplate.TESTFIELD("Page ID");
        MtrJnlBatch.TESTFIELD(Name);

        MtrJnlLine.FILTERGROUP := 2;
        MtrJnlLine.SETRANGE("Journal Template Name", MtrJnlTemplate.Name);
        MtrJnlLine.FILTERGROUP := 0;

        MtrJnlLine."Journal Template Name" := MtrJnlTemplate.Name;
        MtrJnlLine."Journal Batch Name" := MtrJnlBatch.Name;
        PAGE.RUN(MtrJnlTemplate."Page ID", MtrJnlLine);
    end;


    procedure OpenJnl(VAR CurrentJnlBatchName: Code[10]; VAR MtrJnlLine: Record "Meter Journal Line")
    begin
        CheckTemplateName(MtrJnlLine.GETRANGEMAX("Journal Template Name"), CurrentJnlBatchName);
        MtrJnlLine.FILTERGROUP := 2;
        MtrJnlLine.SETRANGE("Journal Batch Name", CurrentJnlBatchName);
        MtrJnlLine.FILTERGROUP := 0;
    end;


    procedure OpenJnlBatch(VAR MtrJnlBatch: Record "Meter Journal Batch")
    var
        MtrJnlTemplate: Record "Meter Journal Template";
        MtrJnlLine: Record "Meter Journal Line";
        JnlSelected: Boolean;
    begin
        IF MtrJnlBatch.GETFILTER("Journal Template Name") <> '' THEN
            EXIT;
        MtrJnlBatch.FILTERGROUP(2);
        IF MtrJnlBatch.GETFILTER("Journal Template Name") <> '' THEN BEGIN
            MtrJnlBatch.FILTERGROUP(0);
            EXIT;
        END;
        MtrJnlBatch.FILTERGROUP(0);

        IF NOT MtrJnlBatch.FIND('-') THEN BEGIN
            IF NOT MtrJnlTemplate.FINDFIRST THEN
                TemplateSelection(0, MtrJnlLine, JnlSelected);
            IF MtrJnlTemplate.FINDFIRST THEN
                CheckTemplateName(MtrJnlTemplate.Name, MtrJnlBatch.Name);
        END;
        MtrJnlBatch.FIND('-');
        JnlSelected := TRUE;
        IF MtrJnlBatch.GETFILTER("Journal Template Name") <> '' THEN
            MtrJnlTemplate.SETRANGE(Name, MtrJnlBatch.GETFILTER("Journal Template Name"));
        CASE MtrJnlTemplate.COUNT OF
            1:
                MtrJnlTemplate.FINDFIRST;
            ELSE
                JnlSelected := PAGE.RUNMODAL(0, MtrJnlTemplate) = ACTION::LookupOK;
        END;
        IF NOT JnlSelected THEN
            ERROR('');

        MtrJnlBatch.FILTERGROUP(0);
        MtrJnlBatch.SETRANGE("Journal Template Name", MtrJnlTemplate.Name);
        MtrJnlBatch.FILTERGROUP(2);
    end;


    local procedure CheckTemplateName(CurrentJnlTemplateName: Code[10]; VAR CurrentJnlBatchName: Code[10])
    var
        MtrJnlBatch: Record "Meter Journal Batch";
    begin
        MtrJnlBatch.SETRANGE("Journal Template Name", CurrentJnlTemplateName);
        IF NOT MtrJnlBatch.GET(CurrentJnlTemplateName, CurrentJnlBatchName) THEN BEGIN
            IF NOT MtrJnlBatch.FINDFIRST THEN BEGIN
                MtrJnlBatch.INIT;
                MtrJnlBatch."Journal Template Name" := CurrentJnlTemplateName;
                MtrJnlBatch.SetupNewBatch;
                MtrJnlBatch.Name := Text004;
                MtrJnlBatch.Description := Text005;
                MtrJnlBatch.INSERT(TRUE);
                COMMIT;
            END;
            CurrentJnlBatchName := MtrJnlBatch.Name;
        END;
    end;


    procedure CheckName(CurrentJnlBatchName: Code[10]; VAR MtrJnlLine: Record "Meter Journal Line")
    var
        MtrJnlBatch: record "Meter Journal Batch";
    begin
        MtrJnlBatch.GET(MtrJnlLine.GETRANGEMAX("Journal Template Name"), CurrentJnlBatchName);
    end;


    procedure SetName(CurrentJnlBatchName: Code[10]; VAR MtrJnlLine: Record "Meter Journal Line")
    begin
        MtrJnlLine.FILTERGROUP := 2;
        MtrJnlLine.SETRANGE("Journal Batch Name", CurrentJnlBatchName);
        MtrJnlLine.FILTERGROUP := 0;
        IF MtrJnlLine.FIND('-') THEN;
    end;


    procedure LookupName(VAR CurrentJnlBatchName: Code[10]; VAR MtrJnlLine: Record "Meter Journal Line")
    var
        MtrJnlBatch: record "Meter Journal Batch";
    begin
        COMMIT;
        MtrJnlBatch."Journal Template Name" := MtrJnlLine.GETRANGEMAX("Journal Template Name");
        MtrJnlBatch.Name := MtrJnlLine.GETRANGEMAX("Journal Batch Name");
        MtrJnlBatch.FILTERGROUP(2);
        MtrJnlBatch.SETRANGE("Journal Template Name", MtrJnlBatch."Journal Template Name");
        MtrJnlBatch.FILTERGROUP(0);
        IF PAGE.RUNMODAL(0, MtrJnlBatch) = ACTION::LookupOK THEN BEGIN
            CurrentJnlBatchName := MtrJnlBatch.Name;
            SetName(CurrentJnlBatchName, MtrJnlLine);
        END;
    end;


    procedure GetMtr(MtrNo: Code[20]; VAR MtrName: Text[100])
    var
        Mtr: record Meter;
    begin
        IF MtrNo <> OldMtrNo THEN BEGIN
            MtrName := '';
            IF MtrNo <> '' THEN
                IF Mtr.GET(MtrNo) THEN
                    MtrName := Mtr.Description;
            OldMtrNo := MtrNo;
        END;
    end;


    var
        OldMtrNo: Code[20];
        OpenFromBatch: Boolean;
        Text000: TextConst ENU = 'METERS';
        Text001: TextConst ENU = 'Meter Journals';
        Text004: TextConst ENU = 'DEFAULT';
        Text005: TextConst ENU = 'Default Journal';
}
codeunit 50102 "Meter Jnl.-Post Batch"
{
    TableNo = "Meter Journal Line";

    trigger OnRun()
    begin
        MtrJnlLine.COPY(Rec);
        Code;
        Rec := MtrJnlLine;
    end;


    procedure Code()
    var
        UpdateAnalysisView: Codeunit "Update Analysis View";
    begin
        MtrJnlLine.SETRANGE("Journal Template Name", MtrJnlLine."Journal Template Name");
        MtrJnlLine.SETRANGE("Journal Batch Name", MtrJnlLine."Journal Batch Name");
        MtrJnlLine.LOCKTABLE;

        MtrJnlTemplate.GET(MtrJnlLine."Journal Template Name");
        MtrJnlBatch.GET(MtrJnlLine."Journal Template Name", MtrJnlLine."Journal Batch Name");
        IF STRLEN(INCSTR(MtrJnlBatch.Name)) > MAXSTRLEN(MtrJnlBatch.Name) THEN
            MtrJnlBatch.FIELDERROR(
              Name,
              STRSUBSTNO(
                Text000,
                MAXSTRLEN(MtrJnlBatch.Name)));

        IF NOT MtrJnlLine.FIND('=><') THEN BEGIN
            MtrJnlLine."Line No." := 0;
            COMMIT;
            EXIT;
        END;

        Window.OPEN(
          Text001 +
          Text002 +
          Text005);
        Window.UPDATE(1, MtrJnlLine."Journal Batch Name");

        // Check lines
        LineCount := 0;
        StartLineNo := MtrJnlLine."Line No.";
        REPEAT
            LineCount := LineCount + 1;
            Window.UPDATE(2, LineCount);
            MtrJnlCheckLine.RunCheck(MtrJnlLine);
            IF MtrJnlLine.NEXT = 0 THEN
                MtrJnlLine.FIND('-');
        UNTIL MtrJnlLine."Line No." = StartLineNo;
        NoOfRecords := LineCount;

        // Find next register no.
        MtrLedgEntry.LOCKTABLE;
        IF MtrLedgEntry.FINDLAST THEN;
        MtrReg.LOCKTABLE;
        IF MtrReg.FINDLAST AND (MtrReg."To Entry No." = 0) THEN
            MtrRegNo := MtrReg."No."
        ELSE
            MtrRegNo := MtrReg."No." + 1;

        // Post lines
        LineCount := 0;
        LastDocNo := '';
        LastDocNo2 := '';
        LastPostedDocNo := '';
        MtrJnlLine.FIND('-');
        REPEAT
            LineCount := LineCount + 1;
            Window.UPDATE(3, LineCount);
            Window.UPDATE(4, ROUND(LineCount / NoOfRecords * 10000, 1));
            IF NOT MtrJnlLine.EmptyLine AND
               (MtrJnlBatch."No. Series" <> '') AND
               (MtrJnlLine."Document No." <> LastDocNo2)
            THEN
                MtrJnlLine.TESTFIELD("Document No.", NoSeriesMgt.GetNextNo(MtrJnlBatch."No. Series", MtrJnlLine."Posting Date", FALSE));
            IF NOT MtrJnlLine.EmptyLine THEN
                LastDocNo2 := MtrJnlLine."Document No.";
            IF MtrJnlLine."Posting No. Series" = '' THEN
                MtrJnlLine."Posting No. Series" := MtrJnlBatch."No. Series"
            ELSE
                IF NOT MtrJnlLine.EmptyLine THEN
                    IF MtrJnlLine."Document No." = LastDocNo THEN
                        MtrJnlLine."Document No." := LastPostedDocNo
                    ELSE BEGIN
                        IF NOT TempNoSeries.GET(MtrJnlLine."Posting No. Series") THEN BEGIN
                            NoOfPostingNoSeries := NoOfPostingNoSeries + 1;
                            IF NoOfPostingNoSeries > ARRAYLEN(NoSeriesMgt2) THEN
                                ERROR(
                                  Text006,
                                  ARRAYLEN(NoSeriesMgt2));
                            TempNoSeries.Code := MtrJnlLine."Posting No. Series";
                            TempNoSeries.Description := FORMAT(NoOfPostingNoSeries);
                            TempNoSeries.INSERT;
                        END;
                        LastDocNo := MtrJnlLine."Document No.";
                        EVALUATE(PostingNoSeriesNo, TempNoSeries.Description);
                        MtrJnlLine."Document No." := NoSeriesMgt2[PostingNoSeriesNo].GetNextNo(MtrJnlLine."Posting No. Series", MtrJnlLine."Posting Date", FALSE);
                        LastPostedDocNo := MtrJnlLine."Document No.";
                    END;
            MtrJnlPostLine.RunWithCheck(MtrJnlLine);
        UNTIL MtrJnlLine.NEXT = 0;

        // Copy register no. and current journal batch name to the res. journal
        IF NOT MtrReg.FINDLAST OR (MtrReg."No." <> MtrRegNo) THEN
            MtrRegNo := 0;

        MtrJnlLine.INIT;
        MtrJnlLine."Line No." := MtrRegNo;

        // Update/delete lines
        IF MtrRegNo <> 0 THEN BEGIN
            MtrJnlLine2.COPYFILTERS(MtrJnlLine);
            MtrJnlLine2.SETFILTER("Meter No.", '<>%1', '');
            IF MtrJnlLine2.FIND('+') THEN; // Remember the last line
            MtrJnlLine3.COPY(MtrJnlLine);
            MtrJnlLine3.DELETEALL;
            MtrJnlLine3.RESET;
            MtrJnlLine3.SETRANGE("Journal Template Name", MtrJnlLine."Journal Template Name");
            MtrJnlLine3.SETRANGE("Journal Batch Name", MtrJnlLine."Journal Batch Name");
            IF NOT MtrJnlLine3.FINDLAST THEN
                IF INCSTR(MtrJnlLine."Journal Batch Name") <> '' THEN BEGIN
                    MtrJnlBatch.DELETE;
                    MtrJnlBatch.Name := INCSTR(MtrJnlLine."Journal Batch Name");
                    IF MtrJnlBatch.INSERT THEN;
                    MtrJnlLine."Journal Batch Name" := MtrJnlBatch.Name;
                END;

            MtrJnlLine3.SETRANGE("Journal Batch Name", MtrJnlLine."Journal Batch Name");
            IF (MtrJnlBatch."No. Series" = '') AND NOT MtrJnlLine3.FINDLAST THEN BEGIN
                MtrJnlLine3.INIT;
                MtrJnlLine3."Journal Template Name" := MtrJnlLine."Journal Template Name";
                MtrJnlLine3."Journal Batch Name" := MtrJnlLine."Journal Batch Name";
                MtrJnlLine3."Line No." := 10000;
                MtrJnlLine3.INSERT;
                MtrJnlLine3.SetUpNewLine(MtrJnlLine2);
                MtrJnlLine3.MODIFY;
            END;
        END;

        IF MtrJnlBatch."No. Series" <> '' THEN
            //NoSeriesMgt.SaveNoSeries;
        IF TempNoSeries.FIND('-') THEN
                REPEAT
                    EVALUATE(PostingNoSeriesNo, TempNoSeries.Description);
                //NoSeriesMgt2[PostingNoSeriesNo].SaveNoSeries;
                UNTIL TempNoSeries.NEXT = 0;

        COMMIT;
        UpdateAnalysisView.UpdateAll(0, TRUE);
        COMMIT;
    end;


    var
        AccountingPeriod: Record "Accounting Period";
        MtrJnlTemplate: Record "Meter Journal Template";
        MtrJnlBatch: Record "Meter Journal Batch";
        MtrJnlLine: Record "Meter Journal Line";
        MtrJnlLine2: Record "Meter Journal Line";
        MtrJnlLine3: Record "Meter Journal Line";
        MtrLedgEntry: Record "Meter Ledger Entry";
        MtrReg: Record "Meter Register";
        NoSeries: Record "No. Series";
        TempNoSeries: Record "No. Series" temporary;
        MtrJnlCheckLine: Codeunit "Meter Jnl.-Check Line";
        MtrJnlPostLine: Codeunit "Meter Jnl.-Post Line";
        NoSeriesMgt: Codeunit "No. Series";
        NoSeriesMgt2: array[10] of Codeunit "No. Series";
        Window: Dialog;
        MtrRegNo: Integer;
        StartLineNo: Integer;
        Day: Integer;
        Week: Integer;
        Month: Integer;
        MonthText: Text[30];
        LineCount: Integer;
        NoOfRecords: Integer;
        LastDocNo: Code[20];
        LastDocNo2: Code[20];
        LastPostedDocNo: Code[20];
        NoOfPostingNoSeries: Integer;
        PostingNoSeriesNo: Integer;
        Text000: TextConst ENU = 'exceed %1 characters';
        Text001: TextConst ENU = 'Journal Batch Name    #1##########\\';
        Text002: TextConst ENU = 'Checking lines        #2######\';
        Text003: TextConst ENU = 'Posting lines         #3###### @4@@@@@@@@@@@@@\';
        Text004: TextConst ENU = 'Updating lines        #5###### @6@@@@@@@@@@@@@';
        Text005: TextConst ENU = 'Posting lines         #3###### @4@@@@@@@@@@@@@';
        Text006: TextConst ENU = 'A maximum of %1 posting number series can be used in each journal.';
        Text007: TextConst ENU = '<Month Text>';
}
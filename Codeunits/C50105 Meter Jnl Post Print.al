codeunit 50105 "Meter Jnl.-Post+Print"
{
    TableNo = "Meter Journal Line";

    trigger OnRun()
    begin
        MtrJnlLine.COPY(Rec);
        Code;
        Rec := MtrJnlLine;
    end;


    procedure Code()
    begin
        MtrJnlTemplate.GET(MtrJnlLine."Journal Template Name");
        MtrJnlTemplate.TESTFIELD("Posting Report ID");

        IF NOT CONFIRM(Text001) THEN
            EXIT;

        TempJnlBatchName := MtrJnlLine."Journal Batch Name";

        CODEUNIT.RUN(CODEUNIT::"Res. Jnl.-Post Batch", MtrJnlLine);

        IF MtrReg.GET(MtrJnlLine."Line No.") THEN BEGIN
            MtrReg.SETRECFILTER;
            REPORT.RUN(MtrJnlTemplate."Posting Report ID", FALSE, FALSE, MtrReg);
        END;

        IF MtrJnlLine."Line No." = 0 THEN
            MESSAGE(Text002)
        ELSE
            IF TempJnlBatchName = MtrJnlLine."Journal Batch Name" THEN
                MESSAGE(Text003)
            ELSE
                MESSAGE(
                  Text004 +
                  Text005,
                  MtrJnlLine."Journal Batch Name");

        IF NOT MtrJnlLine.FIND('=><') OR (TempJnlBatchName <> MtrJnlLine."Journal Batch Name") THEN BEGIN
            MtrJnlLine.RESET;
            MtrJnlLine.FILTERGROUP(2);
            MtrJnlLine.SETRANGE("Journal Template Name", MtrJnlLine."Journal Template Name");
            MtrJnlLine.SETRANGE("Journal Batch Name", MtrJnlLine."Journal Batch Name");
            MtrJnlLine.FILTERGROUP(0);
            MtrJnlLine."Line No." := 1;
        END;
    end;



    var
        MtrJnlTemplate: Record "Meter Journal Template";
        MtrJnlLine: Record "Meter Journal Line";
        MtrReg: Record "Meter Register";
        TempJnlBatchName: Code[10];
        Text000: TextConst ENU = 'cannot be filtered when posting recurring journals';
        Text001: TextConst ENU = 'Do you want to post the journal lines and print the posting report?';
        Text002: TextConst ENU = 'There is nothing to post.';
        Text003: TextConst ENU = 'The journal lines were successfully posted.';
        Text004: TextConst ENU = 'The journal lines were successfully posted.';
        Text005: TextConst ENU = 'You are now in the %1 journal.';
}
codeunit 50106 "Meter Jnl.-B.Post"
{
    TableNo = "Meter Journal Batch";

    trigger OnRun()
    begin
        MtrJnlBatch.COPY(Rec);
        Code;
        Rec := MtrJnlBatch;
    end;


    procedure Code()
    begin
        MtrJnlTemplate.GET(MtrJnlBatch."Journal Template Name");
        MtrJnlTemplate.TESTFIELD("Force Posting Report", FALSE);

        IF NOT CONFIRM(Text000) THEN
            EXIT;

        MtrJnlBatch.FIND('-');
        REPEAT
            MtrJnlLine."Journal Template Name" := MtrJnlBatch."Journal Template Name";
            MtrJnlLine."Journal Batch Name" := MtrJnlBatch.Name;
            MtrJnlLine."Line No." := 1;
            CLEAR(MtrJnlPostBatch);
            IF MtrJnlPostBatch.RUN(MtrJnlLine) THEN
                MtrJnlBatch.MARK(FALSE)
            ELSE BEGIN
                MtrJnlBatch.MARK(TRUE);
                JnlWithErrors := TRUE;
            END;
        UNTIL MtrJnlBatch.NEXT = 0;

        IF NOT JnlWithErrors THEN
            MESSAGE(Text001)
        ELSE
            MESSAGE(
              Text002 +
              Text003);

        IF NOT MtrJnlBatch.FIND('=><') THEN BEGIN
            MtrJnlBatch.RESET;
            MtrJnlBatch.FILTERGROUP(2);
            MtrJnlBatch.SETRANGE("Journal Template Name", MtrJnlBatch."Journal Template Name");
            MtrJnlBatch.FILTERGROUP(0);
            MtrJnlBatch.Name := '';
        END;
    end;


    var
        MtrJnlTemplate: Record "Meter Journal Template";
        MtrJnlBatch: Record "Meter Journal Batch";
        MtrJnlLine: Record "Meter Journal Line";
        MtrJnlPostBatch: Codeunit "Meter Jnl.-Post Batch";
        JnlWithErrors: Boolean;
        Text000: TextConst ENU = 'Do you want to post the journals?';
        Text001: TextConst ENU = 'The journals were successfully posted.';
        Text002: TextConst ENU = 'It was not possible to post all of the journals.';
        Text003: TextConst ENU = 'The journals that were not successfully posted are now marked.';
}

codeunit 50101 "Meter Jnl.-Post Line"
{
    TableNo = "Meter Journal Line";

    trigger OnRun()
    begin
        GetGLSetup;
        RunWithCheck(Rec);
    end;


    procedure RunWithCheck(VAR MtrJnlLine2: Record "Meter Journal Line")
    begin
        MtrJnlLine.COPY(MtrJnlLine2);
        Code;
        MtrJnlLine2 := MtrJnlLine;
    end;


    procedure Code()
    begin
        IF MtrJnlLine.EmptyLine THEN
            EXIT;

        MtrJnlCheckLine.RunCheck(MtrJnlLine);

        IF NextEntryNo = 0 THEN BEGIN
            MtrLedgEntry.LOCKTABLE;
            IF MtrLedgEntry.FINDLAST THEN
                NextEntryNo := MtrLedgEntry."Entry No.";
            NextEntryNo := NextEntryNo + 1;
        END;

        IF MtrJnlLine."Document Date" = 0D THEN
            MtrJnlLine."Document Date" := MtrJnlLine."Posting Date";

        IF MtrReg."No." = 0 THEN BEGIN
            MtrReg.LOCKTABLE;
            IF (NOT MtrReg.FINDLAST) OR (MtrReg."To Entry No." <> 0) THEN BEGIN
                MtrReg.INIT;
                MtrReg."No." := MtrReg."No." + 1;
                MtrReg."From Entry No." := NextEntryNo;
                MtrReg."To Entry No." := NextEntryNo;
                MtrReg."Creation Date" := TODAY;
                MtrReg."Source Code" := MtrJnlLine."Source Code";
                MtrReg."Journal Batch Name" := MtrJnlLine."Journal Batch Name";
                MtrReg."User ID" := USERID;
                MtrReg.INSERT;
            END;
        END;
        MtrReg."To Entry No." := NextEntryNo;
        MtrReg.MODIFY;

        Mtr.GET(MtrJnlLine."Meter No.");
        Mtr.TESTFIELD(Blocked, FALSE);

        IF (GenPostingSetup."Gen. Bus. Posting Group" <> MtrJnlLine."Gen. Bus. Posting Group") OR
           (GenPostingSetup."Gen. Prod. Posting Group" <> MtrJnlLine."Gen. Prod. Posting Group")
        THEN
            GenPostingSetup.GET(MtrJnlLine."Gen. Bus. Posting Group", MtrJnlLine."Gen. Prod. Posting Group");

        MtrJnlLine."Meter Group Code" := Mtr."Meter Group Code";

        MtrLedgEntry.INIT;
        MtrLedgEntry.CopyFromMtrJnlLine(MtrJnlLine);

        GetGLSetup;
        MtrLedgEntry."User ID" := USERID;
        MtrLedgEntry."Entry No." := NextEntryNo;

        MtrLedgEntry.INSERT(TRUE);

        NextEntryNo := NextEntryNo + 1;
    end;


    local procedure GetGLSetup()
    begin
        IF NOT GLSetupRead THEN
            GLSetup.GET;
        GLSetupRead := TRUE;
    end;


    var
        GLSetup: Record "General Ledger Setup";
        MtrJnlLine: Record "Meter Journal Line";
        MtrLedgEntry: Record "Meter Ledger Entry";
        Mtr: Record Meter;
        MtrReg: Record "Meter Register";
        GenPostingSetup: Record "General Posting Setup";
        MtrJnlCheckLine: Codeunit "Meter Jnl.-Check Line";
        NextEntryNo: Integer;
        GLSetupRead: Boolean;
}
codeunit 50100 "Meter Jnl.-Check Line"
{
    TableNo = "Meter Journal Line";

    trigger OnRun()
    begin
        GLSetup.GET;
        RunCheck(Rec);
    end;


    procedure RunCheck(VAR MtrJnlLine: Record "Meter Journal Line")
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        IF MtrJnlLine.EmptyLine THEN
            EXIT;

        // If journal line has a nonblank Skip Code, delete it so it does not post.
        IF MtrJnlLine."Meter Skip Code" <> '' then
            MtrJnlLine.delete;

        MtrJnlLine.TESTFIELD("Meter No.");
        MtrJnlLine.TESTFIELD("Posting Date");
        MtrJnlLine.TESTFIELD("Gen. Prod. Posting Group");

        IF MtrJnlLine."Posting Date" <> NORMALDATE(MtrJnlLine."Posting Date") THEN
            MtrJnlLine.FIELDERROR("Posting Date", Text000);

        IF (AllowPostingFrom = 0D) AND (AllowPostingTo = 0D) THEN BEGIN
            IF USERID <> '' THEN
                IF UserSetup.GET(USERID) THEN BEGIN
                    AllowPostingFrom := UserSetup."Allow Posting From";
                    AllowPostingTo := UserSetup."Allow Posting To";
                END;
            IF (AllowPostingFrom = 0D) AND (AllowPostingTo = 0D) THEN BEGIN
                GLSetup.GET;
                AllowPostingFrom := GLSetup."Allow Posting From";
                AllowPostingTo := GLSetup."Allow Posting To";
            END;
            IF AllowPostingTo = 0D THEN
                AllowPostingTo := DMY2DATE(31, 12, 9999);
        END;
        IF (MtrJnlLine."Posting Date" < AllowPostingFrom) OR (MtrJnlLine."Posting Date" > AllowPostingTo) THEN
            MtrJnlLine.FIELDERROR("Posting Date", Text001);

        IF MtrJnlLine."Document Date" <> 0D THEN
            IF MtrJnlLine."Document Date" <> NORMALDATE(MtrJnlLine."Document Date") THEN
                MtrJnlLine.FIELDERROR("Document Date", Text000);

        IF NOT DimMgt.CheckDimIDComb(MtrJnlLine."Dimension Set ID") THEN
            ERROR(
              Text002,
              MtrJnlLine.TABLECAPTION, MtrJnlLine."Journal Template Name", MtrJnlLine."Journal Batch Name", MtrJnlLine."Line No.",
              DimMgt.GetDimCombErr);

        TableID[1] := DATABASE::Meter;
        No[1] := MtrJnlLine."Meter No.";
        TableID[2] := DATABASE::"Meter Group";
        No[2] := MtrJnlLine."Meter Group Code";
        IF NOT DimMgt.CheckDimValuePosting(TableID, No, MtrJnlLine."Dimension Set ID") THEN
            IF MtrJnlLine."Line No." <> 0 THEN
                ERROR(
                  Text003,
                  MtrJnlLine.TABLECAPTION, MtrJnlLine."Journal Template Name", MtrJnlLine."Journal Batch Name", MtrJnlLine."Line No.",
                  DimMgt.GetDimValuePostingErr)
            ELSE
                ERROR(DimMgt.GetDimValuePostingErr);
    end;


    var
        GLSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";
        DimMgt: Codeunit DimensionManagement;
        TimeSheetMgt: Codeunit "Time Sheet Management";
        AllowPostingFrom: Date;
        AllowPostingTo: Date;
        Text000: TextConst ENU = 'cannot be a closing date';
        Text001: TextConst ENU = 'is not within your range of allowed posting dates';
        Text002: TextConst ENU = 'The combination of dimensions used in %1 %2, %3, %4 is blocked. %5';
        Text003: TextConst ENU = 'A dimension used in %1 %2, %3, %4 has caused an error. %5';
}
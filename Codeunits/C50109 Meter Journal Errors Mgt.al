codeunit 50109 "Meter Journal Errors Mgt."
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;



    var
        TempErrorMessage: Record "Error Message" temporary;
        TempMtrJnlLineModified: Record "Meter Journal Line" temporary;
        TempDeletedMtrJnlLine: Record "Meter Journal Line" temporary;
        BackgroundErrorHandlingMgt: Codeunit "Background Error Handling Mgt.";
        FullBatchCheck: Boolean;


    procedure SetErrorMessages(var SourceTempErrorMessage: Record "Error Message" temporary)
    begin
        TempErrorMessage.Copy(SourceTempErrorMessage, true);
    end;


    procedure GetErrorMessages(var NewTempErrorMessage: Record "Error Message" temporary)
    begin
        NewTempErrorMessage.Copy(TempErrorMessage, true);
    end;


    procedure SetMtrJnlLineOnModify(Rec: Record "Meter Journal Line")
    begin
        if BackgroundErrorHandlingMgt.BackgroundValidationFeatureEnabled() then
            SaveMtrJournalLineToBuffer(Rec, TempMtrJnlLineModified);
    end;


    local procedure SaveMtrJournalLineToBuffer(MtrJournalLine: Record "Meter Journal Line"; var BufferLine: Record "Meter Journal Line" temporary)
    begin
        if BufferLine.Get(MtrJournalLine."Journal Template Name", MtrJournalLine."Journal Batch Name", MtrJournalLine."Line No.") then begin
            BufferLine.TransferFields(MtrJournalLine);
            BufferLine.Modify();
        end else begin
            BufferLine := MtrJournalLine;
            BufferLine.Insert();
        end;
    end;


    procedure GetResJnlLinePreviousLineNo() PrevLineNo: Integer
    begin
        if TempMtrJnlLineModified.FindFirst() then begin
            PrevLineNo := TempMtrJnlLineModified."Line No.";
            if TempMtrJnlLineModified.Delete() then;
        end;
    end;


    procedure SetFullBatchCheck(NewFullBatchCheck: Boolean)
    begin
        FullBatchCheck := NewFullBatchCheck;
    end;


    procedure GetDeletedResJnlLine(var TempMtrJnlLine: Record "Meter Journal Line" temporary; ClearBuffer: Boolean): Boolean
    begin
        if TempDeletedMtrJnlLine.FindSet() then begin
            repeat
                TempMtrJnlLine := TempDeletedMtrJnlLine;
                TempMtrJnlLine.Insert();
            until TempDeletedMtrJnlLine.Next() = 0;

            if ClearBuffer then
                TempDeletedMtrJnlLine.DeleteAll();
            exit(true);
        end;

        exit(false);
    end;


    procedure CollectResJnlCheckParameters(ResJnlLine: Record "Res. Journal Line"; var ErrorHandlingParameters: Record "Error Handling Parameters")
    begin
        ErrorHandlingParameters."Journal Template Name" := ResJnlLine."Journal Template Name";
        ErrorHandlingParameters."Journal Batch Name" := ResJnlLine."Journal Batch Name";
        ErrorHandlingParameters."Line No." := ResJnlLine."Line No.";
        ErrorHandlingParameters."Full Batch Check" := FullBatchCheck;
        ErrorHandlingParameters."Previous Line No." := GetResJnlLinePreviousLineNo();
    end;


    procedure InsertDeletedResJnlLine(MtrJnlLine: Record "Meter Journal Line")
    begin
        if BackgroundErrorHandlingMgt.BackgroundValidationFeatureEnabled() then begin
            TempDeletedMtrJnlLine := MtrJnlLine;
            if TempDeletedMtrJnlLine.Insert() then;
        end;
    end;


    [EventSubscriber(ObjectType::Page, Page::"Meter Journal", 'OnDeleteRecordEvent', '', false, false)]
    local procedure OnDeleteRecordEventMtrJournal(var Rec: Record "Meter Journal Line"; var AllowDelete: Boolean)
    begin
        InsertDeletedMtrJnlLine(Rec);
    end;


    [EventSubscriber(ObjectType::Page, Page::"Meter Journal", 'OnModifyRecordEvent', '', false, false)]
    local procedure OnModifyRecordEventResJournal(var Rec: Record "Meter Journal Line"; var xRec: Record "Meter Journal Line"; var AllowModify: Boolean)
    begin
        SetMtrJnlLineOnModify(Rec);
    end;


    [EventSubscriber(ObjectType::Page, Page::"Meter Journal", 'OnInsertRecordEvent', '', false, false)]
    local procedure OnInsertRecordEventResJournal(var Rec: Record "Meter Journal Line"; var xRec: Record "Meter Journal Line"; var AllowInsert: Boolean)
    begin
        SetMtrJnlLineOnModify(Rec);
    end;


    procedure InsertDeletedMtrJnlLine(MtrJnlLine: Record "Meter Journal Line")
    begin
        if BackgroundErrorHandlingMgt.BackgroundValidationFeatureEnabled() then begin
            TempDeletedMtrJnlLine := MtrJnlLine;
            if TempDeletedMtrJnlLine.Insert() then;
        end;
    end;
}
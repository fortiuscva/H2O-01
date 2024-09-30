pageextension 50113 "Navigate Ext" extends Navigate
{


    [IntegrationEvent(true, false)]
    local procedure OnBeforeFindMtrLedgerEntry(var MtrLedgerEntry: Record "Meter Ledger Entry"; DocNoFilter: Text; PostingDateFilter: Text; ExtDocNo: Text; var IsHandled: Boolean)
    begin
    end;


    procedure InsertIntoDocEntry2(DocTableID: Integer; DocTableName: Text; DocNoOfRecords: Integer)
    begin
        InsertIntoDocEntry(Rec, DocTableID, "Document Entry Document Type"::" ", DocTableName, DocNoOfRecords);
    end;



    procedure InsertIntoDocEntry2(var TempDocumentEntry: Record "Document Entry" temporary; DocTableID: Integer; DocTableName: Text; DocNoOfRecords: Integer)
    begin
        InsertIntoDocEntry(TempDocumentEntry, DocTableID, "Document Entry Document Type"::" ", DocTableName, DocNoOfRecords);
    end;



    procedure InsertIntoDocEntry2(var TempDocumentEntry: Record "Document Entry" temporary; DocTableID: Integer; DocType: Enum "Document Entry Document Type"; DocTableName: Text; DocNoOfRecords: Integer)
    begin
        if DocNoOfRecords = 0 then
            exit;

        TempDocumentEntry.Init();
        TempDocumentEntry."Entry No." := TempDocumentEntry."Entry No." + 1;
        TempDocumentEntry."Table ID" := DocTableID;
        TempDocumentEntry."Document Type" := DocType;
        TempDocumentEntry."Table Name" := CopyStr(DocTableName, 1, MaxStrLen(Rec."Table Name"));
        TempDocumentEntry."No. of Records" := DocNoOfRecords;
        TempDocumentEntry.Insert();
    end;


    var
        MtrLedgEntry: Record "Meter Ledger Entry";
}

report 50100 "Create Meters"
{
    ApplicationArea = All;
    Caption = 'Create Meters';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    UseRequestPage = false;
    Permissions = TableData "Item Ledger Entry" = rm;

    dataset
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            DataItemTableView = SORTING(Meter, "Meter Created") WHERE(Meter = CONST(true), "Meter Created" = CONST(false), "Entry Type" = CONST(Sale), "Source No." = FILTER(<> ''));

            trigger OnPreDataItem()
            begin
                Cntr := COUNT;
                DefaultDim.LOCKTABLE;
                Mtr.LOCKTABLE;
                MtrSetup.get;
            end;

            trigger OnAfterGetRecord()
            begin
                CLEAR(ILE);
                ILE.GET(ItemLedgerEntry."Entry No.");

                CLEAR(Item);
                Item.GET("Item No.");

                CLEAR(Mtr);
                Mtr.INSERT(TRUE);
                Mtr."System Created" := true;
                Mtr.VALIDATE(Description, Item.Description);
                Mtr."Description 2" := Item."Description 2";
                Mtr.VALIDATE("Gen. Prod. Posting Group", Item."Gen. Prod. Posting Group");
                Mtr."Last Date Modified" := TODAY;
                Mtr."Serial No." := ILE."Serial No.";
                Mtr."Customer Owned" := true;
                Mtr.VALIDATE("Customer No.", ILE."Source No.");
                Mtr.VALIDATE("Ship-to Code", ILE."Source Sub No.");
                Mtr.validate("Global Dimension 1 Code", ILE."Global Dimension 1 Code");
                Mtr.validate("Global Dimension 2 Code", ILE."Global Dimension 2 Code");
                Mtr.validate("Warranty Start Date", ILE."Posting Date");
                Mtr.validate("Purchase Date", ILE."Posting Date");
                Mtr.MODIFY;

                MtrCnt += 1;

                ILE."Meter Created" := TRUE;
                ILE."Meter No." := Mtr."No.";
                ILE.MODIFY
            end;
        }
    }

    var
        Mtr: Record Meter;
        MtrSetup: record "Meter Setup";
        DefaultDim: Record "Default Dimension";
        Item: Record Item;
        ShipToAddr: Record "Ship-to Address";
        ILE: Record "Item Ledger Entry";
        Cntr: Integer;
        I: Integer;
        MtrCnt: Integer;
        Text001: TextConst ENU = '%1 meters created.';
        Text002: TextConst ENU = '1 meter created.';
        Text003: TextConst ENU = 'Zero meters created.';
        ManualFlag: boolean;


    trigger OnInitReport()
    begin
        ManualFlag := true;
    end;



    trigger OnPostReport()
    begin
        IF GuiAllowed AND ManualFlag then begin
            IF MtrCnt = 0 THEN
                MESSAGE(Text003);

            IF MtrCnt > 1 THEN
                MESSAGE(Text001, FORMAT(MtrCnt))
            ELSE
                IF MtrCnt = 1 THEN
                    MESSAGE(Text002);
        end;
    end;


    procedure SetManual(SetFlag: boolean)
    begin
        ManualFlag := SetFlag;
    end;
}
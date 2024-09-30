report 50112 "Create Work Orders"
{
    ApplicationArea = All;
    Caption = 'Create Work Orders';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem(SalesDocumentTemplate; "Sales Document Template")
        {

            trigger OnAfterGetRecord()
            var
                TemplateSalesHeader: record "Sales Header";
                TemplateSalesLine: record "Sales Line";
                NewSalesHeader: record "Sales Header";
                NewSalesLine: record "Sales Line";
                Day: Integer;
                Month: Integer;
                Year: Integer;
            begin
                Day := "Creation Day";
                Month := Date2DMY(WorkDate(), 2);
                Year := Date2DMY(WorkDate(), 3);
                OutputDate := DMY2Date(Day, Month, Year);

                If OutputDate <> WorkDate then
                    CurrReport.skip;

                TemplateSalesHeader.reset;
                TemplateSalesHeader.setrange("Sell-to Customer No.", "Customer No.");
                TemplateSalesHeader.setrange("Document Type", "Source Document Type");
                TemplateSalesHeader.setrange("No.", "Source Document No.");
                IF TemplateSalesHeader.findfirst then begin
                    NewSalesHeader.init;
                    NewSalesHeader := TemplateSalesHeader;
                    NewSalesHeader."No." := '';
                    NewSalesHeader.validate("Document Type", "Target Document Type");
                    NewSalesHeader.validate("Order Date", OutputDate);
                    NewSalesHeader.validate("Document Date", OutputDate);

                    NewSalesHeader."Auto-Generated" := true;
                    NewSalesHeader."Generated From Source No." := "Source Document No.";
                    NewSalesHeader.insert(true);

                    TemplateSalesLine.reset;
                    TemplateSalesLine.setrange("Document Type", "Source Document Type");
                    TemplateSalesLine.setrange("Document No.", "Source Document No.");
                    IF TemplateSalesLine.findset then
                        repeat
                            clear(NewSalesLine);
                            NewSalesLine.init;
                            NewSalesLine := TemplateSalesLine;
                            NewSalesLine.validate("Document Type", "Target Document Type");
                            NewSalesLine.validate("Document No.", NewSalesHeader."No.");
                            NewSalesLine.insert(false);
                        until TemplateSalesLine.next = 0;
                end;

                "Last Creation Date" := OutputDate;
                "Last Document No. Created" := NewSalesHeader."No.";

                modify;
            end;


            trigger OnPreDataItem()
            begin
                setfilter("Last Creation Date", '<>%1', WorkDate());
            end;
        }
    }



    var
        OutputDate: Date;

}

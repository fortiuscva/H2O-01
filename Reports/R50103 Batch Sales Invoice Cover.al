report 50103 "Batch Sales Invoice Cover"
{
    ApplicationArea = All;
    Caption = 'Batch Sales Invoice Cover';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Local/BSICover.rdlc';


    dataset
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.") where("Batch Invoice" = const(TRUE));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Sell-to Customer No.";
            RequestFilterHeading = 'Batch Sales Invoice Summary';


            dataitem(RevTypeDim; "Dimension Value")
            {
                DataItemTableView = sorting("Dimension Code", Code);

                column(InvNo; SalesInvoiceHeader."No.") { }
                column(DocDate; SalesInvoiceHeader."Document Date") { }
                column(DimCode; BSICover."Dimension Value Code") { }
                column(DimName; BSICover."Dimension Value Name") { }
                column(Amt; BSICover.Amount) { }
                column(CompanyAddr1; CompanyAddr[1]) { }
                column(CompanyAddr2; CompanyAddr[2]) { }
                column(CompanyAddr3; CompanyAddr[3]) { }
                column(CompanyAddr4; CompanyAddr[4]) { }
                column(CompanyAddr5; CompanyAddr[5]) { }
                column(CompanyAddr6; CompanyAddr[6]) { }
                column(CompanyAddr7; CompanyAddr[7]) { }
                column(CompanyAddr8; CompanyAddr[8]) { }
                column(Logo; CompanyInfo.Picture) { }
                column(BillToAddr1; BillToAddr[1]) { }
                column(BillToAddr2; BillToAddr[2]) { }
                column(BillToAddr3; BillToAddr[3]) { }
                column(BillToAddr4; BillToAddr[4]) { }
                column(BillToAddr5; BillToAddr[5]) { }
                column(BillToAddr6; BillToAddr[6]) { }
                column(BillToAddr7; BillToAddr[7]) { }
                column(BillToAddr8; BillToAddr[8]) { }
                column(Phrase; Phrase) { }
                column(DatePrint; DatePrint) { }





                trigger OnPreDataItem()
                var
                    GLSetup: record "General Ledger Setup";
                begin
                    GLSetup.get;
                    RevTypeDim.setrange("Dimension Code", GLSetup."Global Dimension 2 Code");
                end;


                trigger OnAfterGetRecord()
                var
                begin
                    BSICover.Init;
                    BSICover."Dimension Value Code" := RevTypeDim.Code;
                    BSICover."Dimension Value Name" := RevTypeDim.Name;
                    BSICover.insert;

                    SalesInvLine.reset;
                    SalesInvLine.SetCurrentKey("Line No.", "Shortcut Dimension 2 Code");
                    SalesInvLine.setrange("Document No.", SalesInvoiceHeader."No.");
                    SalesInvLine.setrange("Shortcut Dimension 2 Code", BSICover."Dimension Value Code");
                    IF SalesInvLine.findset then
                        repeat
                            BSICover.Amount += SalesInvLine.Amount;
                            BSICover.modify;
                        until SalesInvLine.next = 0;
                end;
            }


            trigger OnAfterGetRecord()
            begin
                SalesInvHeader := SalesInvoiceHeader;

                FormatAddr.SalesInvBillTo(BillToAddr, SalesInvoiceHeader);

                DateYear := Date2DMY("Document Date", 3);
                DateMonth := Date2DMY("Document Date", 2);

                If DateMonth = 1 then
                    DateYear := DateYear - 1;

                DateYearText := format(DateYear);


                If DateMonth = 1 then
                    DateText := 'December';
                If DateMonth = 2 then
                    DateText := 'Janurary';
                If DateMonth = 3 then
                    DateText := 'February';
                If DateMonth = 4 then
                    DateText := 'March';
                If DateMonth = 5 then
                    DateText := 'April';
                If DateMonth = 6 then
                    DateText := 'May';
                If DateMonth = 7 then
                    DateText := 'June';
                If DateMonth = 8 then
                    DateText := 'July';
                If DateMonth = 9 then
                    DateText := 'August';
                If DateMonth = 10 then
                    DateText := 'September';
                If DateMonth = 11 then
                    DateText := 'October';
                If DateMonth = 12 then
                    DateText := 'November';

                DatePrint := DateText + ' ' + DateYearText;
            end;


            trigger OnPostDataItem()
            begin
                //BSIReport.SetTableView(SalesInvoiceHeader);
                //BSIReport.Run();

            end;
        }
    }



    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(PrintCompany; PrintCompany)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    labels
    {
        LblTitle = 'INVOICE';
        LblInvNo = 'Invoice No.:';
        LblInvDate = 'Date:';
        LblChecks = 'Please make checks payable to H2O Consulting, Inc.';
        LblBillTo = 'Bill To:';
        LblCat = 'Category';
        LblAmt = 'Amount';
        LblTotal = 'Total:';
    }



    var
        GLSetup: record "General Ledger Setup";
        BSICover: record "BSI Cover Page";
        BSICover2: record "BSI Cover Page";
        SalesInvLine: record "Sales Invoice Line";
        CompanyInfo: record "Company Information";
        SalesInvHeader: record "Sales Invoice Header";
        FormatAddr: codeunit "Format Address";
        CompanyAddr: array[8] of Text[100];
        BillToAddr: array[8] of Text[100];
        PrintCompany: boolean;
        MOTitle: Text[100];
        DateMonth: Integer;
        DateYear: integer;
        DateYearText: text[10];
        Phrase: TextConst ENU = 'Maintenance and Operational Services for the month of ';
        NoCopies: integer;
        LogInteraction: boolean;
        LogInteractionEnable: boolean;
        SummaryLines: boolean;
        DetailLines: boolean;
        DateText: text[10];
        DatePrint: text;
        BSIReport: report BSI;



    trigger OnInitReport()
    begin
        PrintCompany := true;
    end;



    trigger OnPreReport()
    begin
        BSICover.deleteall;

        CompanyInfo.Get();
        //SalesSetup.Get();

        if PrintCompany then begin
            FormatAddr.Company(CompanyAddr, CompanyInfo);
            CompanyInfo.CalcFields(Picture);
        end else
            Clear(CompanyAddr);
    end;


    trigger OnPostReport()
    begin
        Report.Run(50105, false, false, SalesInvHeader);
    end;
}

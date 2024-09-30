report 50105 BSI
{
    ApplicationArea = All;
    Caption = 'BSI';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    //RDLCLayout = './Local/BSIDetail.rdlc';

    dataset
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.") where("Batch Invoice" = const(TRUE));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Sell-to Customer No.";
            RequestFilterHeading = 'Batch Sales Invoice';

            column(SIHNo; "No.") { }
            column(LineType; LineType) { }
            column(DateText; DateText) { }
            column(DocDate; "Document Date") { }
            column(Logo; CompanyInfo.Picture) { }
            column(CompanyAddr1; CompanyAddr[1]) { }
            column(CompanyAddr2; CompanyAddr[2]) { }
            column(CompanyAddr3; CompanyAddr[3]) { }
            column(CompanyAddr4; CompanyAddr[4]) { }
            column(CompanyAddr5; CompanyAddr[5]) { }
            column(CompanyAddr6; CompanyAddr[6]) { }
            column(CompanyAddr7; CompanyAddr[7]) { }
            column(CompanyAddr8; CompanyAddr[8]) { }
            column(BillToAddr1; BillToAddr[1]) { }
            column(BillToAddr2; BillToAddr[2]) { }
            column(BillToAddr3; BillToAddr[3]) { }
            column(BillToAddr4; BillToAddr[4]) { }
            column(BillToAddr5; BillToAddr[5]) { }
            column(BillToAddr6; BillToAddr[6]) { }
            column(BillToAddr7; BillToAddr[7]) { }
            column(BillToAddr8; BillToAddr[8]) { }
            column(MOTitle; MOTitle) { }


            dataitem(SalesInvoiceLineSum; "Sales Invoice Line")    //Summary Line
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Original Document No.", "Original Line No.");

                column(SILSumLineNo; "Line No.") { }
                column(SILSumType; Type) { }
                column(SILSumDimName; DimName) { }
                column(SILSumSD1Code; "Shortcut Dimension 1 Code") { }
                column(SILSumSD2Code; "Shortcut Dimension 2 Code") { }
                column(SILSumQty; Quantity) { }
                column(SILSumAmount; "Amount Including VAT") { }
                column(PageBreak; PageBreak) { }
                column(DateYearText; DateYearText) { }
                column(Phrase; Phrase) { }
                column(CompDate; "Original Completed Date") { }
                column(PrintLine; PrintLine) { }
                column(SummaryLines; SummaryLines) { }



                trigger OnPreDataItem()
                begin
                    PageBreak := false;
                    PrintLine := false;
                end;


                trigger OnAfterGetRecord()     //Sales Invoice Line Summary
                begin
                    If Type = Type::" " then
                        CurrReport.Skip();

                    GLSetup.get;
                    IF DimValue.get(GLSetup."Global Dimension 2 Code", SalesInvoiceLineSum."Shortcut Dimension 2 Code") then
                        DimName := DimValue.Name;
                    LineType := LineType::Summary;
                    PrintLine := true;
                    SummaryLines := true;
                    DetailLines := false;

                end;


                trigger OnPostDataItem()       //Sales Invoice Line Summary
                begin
                    PageBreak := true;
                    PrintLine := false;
                end;
            }


            dataitem(SalesInvLineDet; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");

                column(SILDetLineNo; "Line No.") { }
                column(SILDetType; Type) { }
                column(SILDesc; Description) { }
                column(SILDetDocNo; "Document No.") { }
                column(SILDetCompDate; "Original Completed Date") { }
                column(SILDetMaterial; "Material Amount") { }
                column(SILDetLabor; "Labor Amount") { }
                column(SILDetEquipment; "Equipment Amount") { }
                column(SILDetLineTot; LineTotal) { }
                column(SILDetOrigDocNo; "Original Document No.") { }
                column(SILDetAmount; "Amount Including VAT") { }
                column(CommentLine; CommentLine) { }
                column(LocComment; "Location Comment") { }
                column(DetailLines; DetailLines) { }



                trigger OnAfterGetRecord()     //Sales Invoice Line Detail
                begin
                    LineTotal := "Material Amount" + "Labor Amount" + "Equipment Amount";
                    LineType := LineType::Detail;

                    If Type = Type::" " then
                        CommentLine := true
                    else
                        CommentLine := false;

                    DetailLines := true;
                    SummaryLines := false;
                end;
            }


            trigger OnAfterGetRecord()      //Sales Invoice Header
            begin
                //DateText := format(Date2DMY("Document Date", 2) + ' ' + Date2DMY("Document Date", 3));
                DateYear := Date2DMY("Document Date", 3);
                DateYearText := format(DateYear);
                DateMonth := Date2DMY("Document Date", 2);

                If DateMonth = 1 then
                    DateText := 'January';
                If DateMonth = 2 then
                    DateText := 'February';
                If DateMonth = 3 then
                    DateText := 'March';
                If DateMonth = 4 then
                    DateText := 'April';
                If DateMonth = 5 then
                    DateText := 'May';
                If DateMonth = 6 then
                    DateText := 'June';
                If DateMonth = 7 then
                    DateText := 'July';
                If DateMonth = 8 then
                    DateText := 'August';
                If DateMonth = 9 then
                    DateText := 'September';
                If DateMonth = 10 then
                    DateText := 'October';
                If DateMonth = 11 then
                    DateText := 'November';
                If DateMonth = 12 then
                    DateText := 'December';

                FormatAddress.SalesInvBillTo(BillToAddr, SalesInvoiceHeader);

                LineType := LineType::Header;

                SummaryLines := false;
                DetailLines := false;

            end;
        }
    }




    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoCopies; NoCopies)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Number of Copies';
                        ToolTip = 'Specifies the number of copies of each document (in addition to the original) that you want to print.';
                    }
                    field(PrintCompanyAddress; PrintCompany)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Company Address';
                        ToolTip = 'Specifies if your company address is printed at the top of the sheet, because you do not use pre-printed paper. Leave this check box blank to omit your company''s address.';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies if you want to record the related interactions with the involved contact person in the Interaction Log Entry table.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := true;
            PrintCompany := true;
        end;

        trigger OnOpenPage()
        begin
            //InitLogInteraction();
            LogInteractionEnable := LogInteraction;
        end;

    }


    labels
    {
        LblTitle = 'INVOICE';
        LblInvNo = 'Invoice No.';
        LblDate = 'Invoice Date';
        LblAmt = 'Amount';
        LblLineTot = 'Line Total';
        LblTot = 'Total';
        LblPhrase = 'Maintenance and Operational Services for the month of';
        LblTotDue = 'Total Amount Due';
    }


    trigger OnInitReport()
    begin
        GLSetup.Get();
    end;


    trigger OnPreReport()
    begin
        //ShipmentLine.SetCurrentKey("Order No.", "Order Line No.");
        //if not CurrReport.UseRequestPage then
        //    InitLogInteraction();

        CompanyInfo.Get();
        SalesSetup.Get();

        if PrintCompany then begin
            FormatAddress.Company(CompanyAddr, CompanyInfo);
            CompanyInfo.CalcFields(Picture);
        end else
            Clear(CompanyAddr);
    end;




    var
        GLSetup: record "General Ledger Setup";
        DimValue: record "Dimension Value";
        CompanyInfo: record "Company Information";
        SalesSetup: record "Sales & Receivables Setup";
        DimName: text[50];
        LineTotal: Decimal;
        DateText: text[10];
        PageBreak: boolean;
        PrintCompany: Boolean;
        FormatAddress: codeunit "Format Address";
        CompanyAddr: array[8] of Text[100];
        BillToAddr: array[8] of Text[100];
        MOTitle: Text[100];
        DateMonth: Integer;
        DateYear: integer;
        DateYearText: text[10];
        Phrase: TextConst ENU = 'Maintenance and Operational Services for the month of';
        NoCopies: integer;
        LogInteraction: boolean;
        LogInteractionEnable: boolean;
        SummaryLines: boolean;
        DetailLines: boolean;
        LineType: enum "Invoice Report Line Type";
        CommentLine: boolean;
        PrintLine: boolean;



}

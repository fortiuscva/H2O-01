report 50104 "Batch Sales Invoice Detail"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Local/BSIDetail.rdlc';
    ApplicationArea = All;
    Caption = 'Batch Sales Invoice Detail';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.") where("Batch Invoice" = const(TRUE));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Sell-to Customer No.";
            RequestFilterHeading = 'Batch Sales Invoice';

            column(SIHNo; "No.") { }
            column(Logo; CompanyInfo.picture) { }


            dataitem(SalesInvLineA; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("original Document No.", "original Line No.");

                column(SILALineNo; "Line No.") { }
                column(SILAType; Type) { }
                column(SILADimName; DimName) { }
                column(SILASD1Code; "Shortcut Dimension 1 Code") { }
                column(SILASD2Code; "Shortcut Dimension 2 Code") { }
                column(SILAQty; Quantity) { }
                column(SILAAmount; "Amount Including VAT") { }

                trigger OnAfterGetRecord()
                begin
                    GLSetup.get;
                    IF DimValue.get(GLSetup."Global Dimension 1 Code", SalesInvLineA."Shortcut Dimension 1 Code") then
                        DimName := DimValue.Name;
                end;
            }

            dataitem(SalesInvLineB; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");

                column(SILBLineNo; "Line No.") { }
                column(SILBType; Type) { }
                column(SILBDocNo; "Document No.") { }
                column(SILBCompDate; "Original Completed Date") { }
                column(SILBMaterial; "Material Amount") { }
                column(SILBLabor; "Labor Amount") { }
                column(SILBEquipment; "Equipment Amount") { }

            }
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
    }


    labels
    {
        LblTitle = 'SALES INVOICE';
        LblDate = 'Invoice Date';
        LblCompDate = 'Completion Date';
        LblMat = 'Material/Vendor';
        LblLabor = 'Labor';
        LblEquip = 'Equipment';
        LblLineTot = 'Total';
        LblAmt = 'Amount';
        LblTot = 'Total';
        LblPhrase = '';
        LblWO = 'Work Order';
        LblTotWO = 'Total Work Order';
        LblTotDue = 'Total Due';

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
            FormatAddress.Company(CompanyAddress, CompanyInfo);
            CompanyInfo.CalcFields(Picture);
        end else
            Clear(CompanyAddress);
    end;


    var
        CompanyInfo: record "Company Information";
        SalesSetup: record "Sales & Receivables Setup";
        TempSalesInvLineA: record "Sales Invoice Line";
        TempSalesInvLineB: record "Sales Invoice Line";
        Dim: record Dimension;
        DimValue: record "Dimension Value";
        GLSetup: record "General Ledger Setup";
        DimName: text[50];
        NoCopies: integer;
        PrintCompany: Boolean;
        LogInteraction: Boolean;
        LogInteractionEnable: Boolean;
        SegManagement: Codeunit SegManagement;
        FormatAddress: codeunit "Format Address";
        CompanyAddress: array[8] of Text[100];
        BillToAddress: array[8] of Text[100];






    procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractionTemplateCode("Interaction Log Entry Document Type"::"Sales Inv.") <> '';
    end;

}

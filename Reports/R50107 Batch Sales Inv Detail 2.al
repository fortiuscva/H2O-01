report 50107 "Batch Sales Inv Detail 2"
{
    ApplicationArea = All;
    Caption = 'Batch Sales Invoice Detail';
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
            column(Logo; CompanyInfo.picture) { }
            column(CompanyAddress1; CompanyAddress[1]) { }
            column(CompanyAddress2; CompanyAddress[2]) { }
            column(CompanyAddress3; CompanyAddress[3]) { }
            column(CompanyAddress4; CompanyAddress[4]) { }
            column(CompanyAddress5; CompanyAddress[5]) { }
            column(CompanyAddress6; CompanyAddress[6]) { }
            column(CompanyAddress7; CompanyAddress[7]) { }
            column(CompanyAddress8; CompanyAddress[8]) { }
            column(BillToAddress1; BillToAddress[1]) { }
            column(BillToAddress2; BillToAddress[2]) { }
            column(BillToAddress3; BillToAddress[3]) { }
            column(BillToAddress4; BillToAddress[4]) { }
            column(BillToAddress5; BillToAddress[5]) { }
            column(BillToAddress6; BillToAddress[6]) { }
            column(BillToAddress7; BillToAddress[7]) { }
            column(BillToAddress8; BillToAddress[8]) { }



            dataitem(SalesInvLine; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("original Document No.", "Original Line No.");


                column(DimName; DimName) { }
                column(DimValue; DimValue.Code) { }
                column(Description; Description) { }    //Ship-to Address
                column(Purpose; Purpose) { }
                column(WONo; WONo) { }
                column(CompDate; CompDate) { }
                column(Labor; "Labor Amount") { }
                column(Equipment; "Equipment Amount") { }
                column(Material; "Material Amount") { }
                column(LineTot; LineTot) { }
                column(Type; type) { }
                column(WOPurpose; "WO Purpose") { }
                column(OriginalNo; "Original No.") { }
                column(OrigLineNo; "Original Line No.") { }




                trigger OnPreDataItem()    //Sales Invoice Line
                begin
                end;


                trigger OnAfterGetRecord()   //Sales Invoice Line
                begin
                    If Dim.get(GLSetup."Global Dimension 2 Code") then
                        If DimValue.get(Dim.Code, "Shortcut Dimension 2 Code") then
                            DimName := DimValue.Name;

                    Purpose := SalesInvoiceHeader.Purpose;
                    WONo := SalesInvLine."Original Document No.";
                    CompDate := SalesInvLine."Original Completed Date";
                    LineTot := "Material Amount" + "Labor Amount" + "Equipment Amount";
                end;

                trigger OnPostDataItem()     //Sales Invoice Line
                begin
                end;
            }

            trigger OnPreDataItem()    //Sales Invoice Header
            begin
            end;

            trigger OnAfterGetRecord()  //Sales Invoice Header
            begin
                FormatAddress.SalesInvBillTo(BillToAddress, SalesInvoiceHeader);

            end;

            trigger OnPostDataItem()    //Sales Invoice Header
            begin
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
            area(processing)
            {
            }
        }
    }


    labels
    {
        LblTitle = 'Sales Invoice Detail';
        LblPage = 'Page No.';
        LblLoc = 'Location';
        LblWO = 'Work Order';
        LblCompDate = 'Completion Date';
        LblMat = 'Materials';
        LblLabor = 'Labor';
        LblEquip = 'Equipment';
        LblLineTot = 'Total';
        LblTotDue = 'Total Amount Due';
    }


    trigger OnInitReport()
    begin
        GLSetup.Get();
        PrintCompany := true;
    end;


    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        SalesSetup.Get();

        if PrintCompany then begin
            FormatAddress.Company(CompanyAddress, CompanyInfo);
            CompanyInfo.CalcFields(Picture);
        end else
            Clear(CompanyAddress);
    end;


    trigger OnPostReport()
    begin

    end;


    var
        CompanyInfo: record "Company Information";
        SalesSetup: record "Sales & Receivables Setup";
        Dim: record Dimension;
        DimValue: record "Dimension Value";
        GLSetup: record "General Ledger Setup";
        ShipToAddr: record "Ship-to Address";
        DimName: text[50];
        ShipAddr: text[100];
        Purpose: text[100];
        WONo: code[20];
        CompDate: date;
        LineTot: decimal;
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

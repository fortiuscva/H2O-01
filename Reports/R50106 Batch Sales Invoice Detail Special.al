report 50106 "Batch Sales Inv Detail Spl"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Local/BSIDetailSpecial.rdlc';
    ApplicationArea = All;
    Caption = 'Batch Sales Invoice Detail Special';
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
            column(SIInvDate; "Document Date") { }
            column(Logo; companyinfo.picture) { }
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
            column(CompDate; "Completed Date") { }
            column(Purpose; Purpose) { }
            column(ShipToAddr; "Ship-to Address") { }
            column(GrandTot; GrandTot) { }


            dataitem(SalesInvLineMat; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("original Document No.", "original Line No.") where(Type = filter(Item));


                column(MatWONo; "Original Document No.") { }
                column(MatDocDate; "Posting Date") { }
                //column(MatVendor; vendor)
                column(MatLineNo; "Original Line No.") { }
                column(MatType; MatType) { }
                column(MatItem; "No.") { }
                column(MatDesc; Description) { }
                column(MatQty; Quantity) { }
                column(MatCompDate; "Original Completed Date") { }
                column(MatUnitPrice; "Unit Price") { }
                column(MatAmt; "Material Amount") { }



                trigger OnAfterGetRecord()
                begin
                    GLSetup.get;
                    IF DimValue.get(GLSetup."Global Dimension 1 Code", SalesInvLineMat."Shortcut Dimension 1 Code") then
                        DimName := DimValue.Name;

                    LaborType := false;
                    EquipType := false;
                    MatType := true;

                    MatTot += "Material Amount";
                end;
            }

            dataitem(SalesInvLineLabor; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("original Document No.", "original Line No.") where(Type = filter(Resource | Meter), Rental = const(false));


                column(LaborWONo; "Original Document No.") { }
                column(LaborLineNo; "Line No.") { }
                column(LaborType; LaborType) { }
                column(LaborNo; "No.") { }
                column(LaborInits; LaborInits) { }
                column(LaborDocNo; "Document No.") { }
                column(LaborCompDate; "Original Completed Date") { }
                column(LaborUnitPrice; "Unit Price") { }
                column(LaborAmt; "Labor Amount") { }
                column(StdRate; StdRate) { }
                column(OTRate; OTRate) { }
                column(StdHrs; StdHrs) { }
                column(OTHrs; OTHrs) { }
                column(RateType; RateType) { }
                column(LaborQty; Quantity) { }


                trigger OnAfterGetRecord()
                begin
                    LaborType := true;
                    EquipType := false;
                    MatType := false;

                    clear(RateType);

                    If (Type = Type::Resource) and (Not rental) then begin
                        If Res.get("No.") then
                            LaborInits := Res."Technician Initials";

                        IF WorkType.get("Work Type Code") then begin
                            IF WorkType.Contract then begin
                                StdRate := "Unit Price";
                                OTRate := 0;

                                StdHrs := quantity;
                                OTHrs := 0;

                                RateType := 'STD';
                            end;

                            If WorkType.Overtime then begin
                                StdRate := 0;
                                OTRate := "Unit Price";

                                StdHrs := 0;
                                OTHrs := Quantity;

                                RateType := 'OT';

                            end;
                        end;
                    end;

                    LaborTot += "Labor Amount";
                end;
            }


            dataitem(SalesInvLineEquip; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("original Document No.", "original Line No.") where(Type = filter(Resource), Rental = const(true));


                column(EquipWONo; "Original Document No.") { }
                column(EquipLineNo; "Line No.") { }
                column(EquipType; EquipType) { }
                column(EquipDocNo; "Document No.") { }
                column(EquipDesc; Description) { }
                column(EquipQty; Quantity) { }
                column(EquipPrice; "unit price") { }
                column(EquipCompDate; "Original Completed Date") { }
                column(EquipAmt; "Equipment Amount") { }


                trigger OnAfterGetRecord()
                begin
                    LaborType := false;
                    EquipType := true;
                    MatType := false;

                    EquipTot += "Equipment Amount";
                end;
            }

            trigger OnPreDataItem()    //Sales Invoice Header
            begin
            end;


            trigger OnAfterGetRecord()  //Sales Invoice Header
            begin
                FormatAddress.SalesInvBillTo(BillToAddress, SalesInvoiceHeader);

                calcfields("Material Amount", "Labor Amount", "Equipment Amount");
                GrandTot := "Material Amount" + "Labor Amount" + "Equipment Amount";

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
        }
    }


    labels
    {
        LblTitle = 'SALES INVOICE';
        LblInvDate = 'Invoice Date';
        LblCompDate = 'Date Completed';
        LblCompBy = 'Completed By';
        LblMat = 'Parts and Materials, Work Order No. -';
        LblLabor = 'Labor, Work Order No. -';
        LblEquip = 'Equipment, Work Order No. -';
        LblLineTot = 'Total';
        LblWONo = 'Work Order NO.';
        LblServFor = 'Service For';
        LblPurpose = 'Task';
        LblDate = 'Date';
        LblVend = 'Vendor';
        LblQty = 'Qty.';
        LblPO = 'POs / Parts Description';
        LblMarkup = 'Markup';
        LblUnitPrice = 'Price Each';
        LblAmt = 'Amount';
        LblTotParts = 'Total Parts and Materials';
        LblServPerson = 'Service Person';
        LblServTech = 'Service Tech';
        LblInits = 'Initials';
        LblReg = 'Reg. Hours';
        LblOT = 'O/T Hours';
        LblRate = 'Rate';
        LblOTRate = 'O/T Rate';
        LblTotLabor = 'Total Labor';
        LblRegHrs = 'Regular Hours';
        LblRateHr = 'Rate / Hour';
        LblTotEquip = 'Total Equipment';
        LblAmtDue = 'Amount Due';
        LblRateType = 'Rate Type';

    }


    trigger OnInitReport()
    begin
        GLSetup.Get();
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


    var
        CompanyInfo: record "Company Information";
        SalesSetup: record "Sales & Receivables Setup";
        Dim: record Dimension;
        DimValue: record "Dimension Value";
        GLSetup: record "General Ledger Setup";
        Cust: record Customer;
        PurchHeader: record "purchase header";
        PurchInvHeader: record "Purch. Inv. Header";
        Res: record resource;
        WorkType: record "Work Type";
        DimName: text[50];
        NoCopies: integer;
        PrintCompany: Boolean;
        LogInteraction: Boolean;
        LogInteractionEnable: Boolean;
        SegManagement: Codeunit SegManagement;
        FormatAddress: codeunit "Format Address";
        CompanyAddress: array[8] of Text[100];
        BillToAddress: array[8] of Text[100];
        LineType: option Material,Labor,Equipment;
        Vend: code[20];
        LaborType: boolean;
        EquipType: boolean;
        MatType: boolean;
        LaborInits: text;
        StdRate: decimal;
        OTRate: decimal;
        StdHrs: decimal;
        OTHrs: decimal;
        RateType: text;
        MatTot: decimal;
        LaborTot: decimal;
        EquipTot: decimal;
        GrandTot: decimal;





    procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractionTemplateCode("Interaction Log Entry Document Type"::"Sales Inv.") <> '';
    end;

}

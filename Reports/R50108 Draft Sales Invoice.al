report 50108 "Draft Sales Invoice"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Local/DraftInvoice.rdlc';
    ApplicationArea = All;
    Caption = 'Draft Sales Invoice';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            DataItemTableView = SORTING("No.") where("Batch Invoice" = const(false));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Sell-to Customer No.";
            RequestFilterHeading = 'Draft Sales Invoice';

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


            dataitem(SalesLineMat; "Sales Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.") where(Type = filter(Item));


                column(MatWONo; "Document No.") { }
                column(MatDocDate; "Posting Date") { }
                //column(MatVendor; vendor)
                column(MatLineNo; "Line No.") { }
                column(MatType; MatType) { }
                column(MatItem; "No.") { }
                column(MatDesc; Description) { }
                column(MatQty; Quantity) { }
                column(MatCompDate; SalesHeader."Completed Date") { }
                column(MatUnitPrice; "Unit Price") { }
                column(MatAmt; "Material Amount") { }



                trigger OnAfterGetRecord()
                begin
                    GLSetup.get;
                    IF DimValue.get(GLSetup."Global Dimension 1 Code", SalesLineMat."Shortcut Dimension 1 Code") then
                        DimName := DimValue.Name;

                    LaborType := false;
                    EquipType := false;
                    MatType := true;

                    MatTot += "Material Amount";
                end;
            }

            dataitem(SalesLineLabor; "Sales Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.") where(Type = filter(Resource | Meter), Rental = const(false));


                column(LaborWONo; "Document No.") { }
                column(LaborLineNo; "Line No.") { }
                column(LaborType; LaborType) { }
                column(LaborNo; "No.") { }
                column(LaborInits; LaborInits) { }
                column(LaborDocNo; "Document No.") { }
                column(LaborCompDate; SalesHeader."Completed Date") { }
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


            dataitem(SalesLineEquip; "Sales Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.") where(Type = filter(Resource), Rental = const(true));


                column(EquipWONo; "Document No.") { }
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


            dataitem(SalesCommentLine; "Sales Comment Line")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") WHERE("Document Type" = CONST(Invoice), "Print On Invoice" = CONST(true), "Document Line No." = CONST(0));


                column(No; "No.") { }
                column(CommentCode1; CommentCode[1]) { }
                column(CommentCode2; CommentCode[2]) { }
                column(CommentCode3; CommentCode[3]) { }
                column(CommentCode4; CommentCode[4]) { }
                column(CommentCode5; CommentCode[5]) { }


                trigger OnAfterGetRecord()
                begin
                    Cntr += 1;

                    If Cntr > 5 then
                        exit
                    else begin
                        IF Cntr = 1 then
                            CommentCode[1] := Comment;
                        IF Cntr = 2 then
                            CommentCode[2] := Comment;
                        IF Cntr = 3 then
                            CommentCode[3] := Comment;
                        IF Cntr = 4 then
                            CommentCode[4] := Comment;
                        IF Cntr = 5 then
                            CommentCode[5] := Comment;

                    end;
                end;
            }

            trigger OnPreDataItem()    //Sales Invoice Header
            begin
            end;


            trigger OnAfterGetRecord()  //Sales Invoice Header
            begin
                IF "Batch Invoice" then
                    error(Text001);

                FormatAddress.SalesHeaderBillTo(BillToAddress, SalesHeader);

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
        LblMat = 'Parts and Materials';
        LblLabor = 'Labor';
        LblEquip = 'Equipment';
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
        LblComment = 'Comments:';

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
        Cntr: integer;
        CommentCode: array[5] of Text[80];
        Text001: TextConst ENU = 'Batch invoices are not work orders and cannot be printed from here.';
        Text002: TextConst ENU = '';





    procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractionTemplateCode("Interaction Log Entry Document Type"::"Sales Inv.") <> '';
    end;

}

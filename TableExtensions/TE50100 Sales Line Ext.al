tableextension 50100 "Sales Line Ext" extends "Sales Line"
{
    DrillDownPageId = "Ship-to Address List";

    fields
    {
        modify("No.")
        {
            CaptionClass = GetCaptionClass(FIELDNO("No."));
            TableRelation = IF (Type = CONST(" ")) "Standard Text"
            ELSE
            IF (Type = CONST("G/L Account"), "System-Created Entry" = CONST(false)) "G/L Account" WHERE("Direct Posting" = CONST(true), "Account Type" = CONST(Posting), Blocked = CONST(false))
            ELSE
            IF (Type = CONST("G/L Account"), "System-Created Entry" = CONST(true)) "G/L Account"
            ELSE
            IF (Type = CONST(Resource)) Resource
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF (Type = CONST("Charge (Item)")) "Item Charge"
            ELSE
            IF (Type = CONST(Item)) Item
            else
            IF (Type = CONST(Meter)) Meter where("Customer No." = field("Sell-to Customer No."), "Ship-to Code" = field("Original Ship-to Code"));

            trigger OnAfterValidate()
            var
                MeterSetup: record "Meter Setup";
            begin
                If Type = Type::Meter then begin
                    IF Mtr.get("No.") then begin
                        IF MeterSetup."Req. Ship-to Code Sale" then begin
                            SalesHeader.testfield("Ship-to Code");
                            validate("Original Ship-to Code", SalesHeader."Ship-to Code");
                        end;
                        Description := Mtr.Description;
                        "Description 2" := Mtr."Description 2";
                        validate("Gen. Prod. Posting Group", Mtr."Gen. Prod. Posting Group");
                        validate("Tax Group Code", Mtr."Tax Group Code");
                        validate("Shortcut Dimension 1 Code", Mtr."Global Dimension 1 Code");
                        validate("Shortcut Dimension 2 Code", Mtr."Global Dimension 2 Code");
                        validate(Quantity, 1);
                        "Unit Price" := CalcMtrPrice.CalculateMeterPrice(Rec);
                    end;
                end;
                IF Type = Type::Resource then
                    If Res.get("No.") then begin
                        validate("Work Type Code", Res."Work Type Code");
                        validate("WO Supervisor", Res.Supervisor);
                        validate("Resource Type", Res.Type);
                    end;
                "Original No." := "No.";
            END;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                CalcResPrice(rec);
                UpdateMEL;
            end;
        }
        modify("Unit Price")
        {
            trigger OnAfterValidate()
            begin
                UpdateMEL;
            end;
        }
        modify("Work Type Code")
        {
            trigger OnAfterValidate()
            begin
                CalcResPrice(rec);
            end;
        }
        modify("Unit of Measure Code")
        {
            trigger OnAfterValidate()
            begin
                CalcResPrice(rec);
            end;
        }
        field(50100; Meter; Boolean)
        {
            Caption = 'Meter';
            DataClassification = ToBeClassified;
        }
        field(50105; "Meter Activity Code"; code[10])
        {
            Caption = 'Meter Activity Code';
            DataClassification = ToBeClassified;
            TableRelation = "Meter Activity" where(Reading = CONST(false));

            trigger OnValidate()
            begin
                testfield(Type, Type::Meter);
                If Type = Type::Meter then begin
                    validate("Unit Price", CalcMtrPrice.CalculateMeterPrice(Rec));
                end;
            end;
        }
        field(50110; "Meter Serial No."; code[20])
        {
            caption = 'Meter Serial No.';
            FieldClass = FlowField;
            CalcFormula = Lookup(Meter."Serial No." WHERE("No." = FIELD("No.")));
            Editable = false;
        }
        field(50120; Rental; Boolean)
        {
            caption = 'Rental';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50130; "Rental Start Date"; date)
        {
            caption = 'Rental Start Date';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                testfield(Rental);
                CalcRentDate;
            end;
        }
        field(50140; "Rental End Date"; date)
        {
            caption = 'Rental End Date';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                testfield(Rental);
                CalcRentDate;
            end;
        }
        field(50145; "Rental Days"; integer)
        {
            caption = 'Rental Days';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50150; "On Rent"; boolean)
        {
            caption = 'On Rent';
            DataClassification = ToBeClassified;
        }
        field(50155; "Resource Type"; Enum "Resource Type")
        {
            caption = 'Resource Type';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50160; "Associated No."; code[20])
        {
            caption = 'Associated No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50165; "Sent To Mendix"; Boolean)
        {
            Caption = 'Sent To Mendix';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50170; "Sent To Mendix Date"; Date)
        {
            Caption = 'Sent To Mendix Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50175; "Sent To Mendix Time"; Time)
        {
            Caption = 'Sent To Mendix Time';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50180; "Received From Mendix"; Boolean)
        {
            Caption = 'Received From Mendix';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50185; "Received From Mendix Date"; Date)
        {
            Caption = 'Received From Mendix Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50190; "Received From Mendix Time"; Time)
        {
            Caption = 'Received From Mendix Time';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50200; "Original Document No."; code[20])
        {
            Caption = 'Original Document No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50205; "Original Line No."; integer)
        {
            Caption = 'Original Line No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50207; "Original Ship-to Code"; code[10])
        {
            Caption = 'Original Ship-to Code';
            DataClassification = ToBeClassified;
            //Editable = false;
            TableRelation = "Ship-to Address".Code where("Customer No." = field("Sell-to Customer No."));
        }
        field(50208; "Original No."; code[20])
        {
            Caption = 'Original No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50210; "Vendor No."; code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = ToBeClassified;
            TableRelation = vendor;
        }
        field(50215; "Purchase Order No. 2"; code[20])
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            Caption = 'Purchase Order No.';
            //Editable = false;
            DataClassification = ToBeClassified;
            TableRelation = IF ("Drop Shipment 2" = CONST(true)) "Purchase Header"."No." WHERE("Document Type" = CONST(Order));

            trigger OnValidate()
            var
                SalesWhseMgt: codeunit "Sales Warehouse Mgt.";
            begin
                if (xRec."Purchase Order No. 2" <> "Purchase Order No. 2") and (Quantity <> 0) then begin
                    VerifyChangeForSalesLineReserve(FieldNo("Purchase Order No. 2"));
                    SalesWhseMgt.SalesLineVerifyChange(Rec, xRec);
                end;
            end;
        }
        field(50217; "Purch. Order Line No. 2"; integer)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            Caption = 'Purch. Order Line No.';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Drop Shipment 2" = CONST(true)) "Purchase Line"."Line No." WHERE("Document Type" = CONST(Order), "Document No." = FIELD("Purchase Order No. 2"));

            trigger OnValidate()
            var
                SalesWhseMgt: codeunit "Sales Warehouse Mgt.";
            begin
                if (xRec."Purch. Order Line No. 2" <> "Purch. Order Line No. 2") and (Quantity <> 0) then begin
                    VerifyChangeForSalesLineReserve(FieldNo("Purch. Order Line No. 2"));
                    SalesWhseMgt.SalesLineVerifyChange(Rec, xRec);
                end;
            end;
        }
        field(50220; "Drop Shipment 2"; Boolean)
        {
            AccessByPermission = TableData "Drop Shpt. Post. Buffer" = R;
            Caption = 'Drop Shipment (INv)';
            Editable = true;
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                IsHandled: Boolean;
                SalesWhseMgt: codeunit "Sales Warehouse Mgt.";
            begin
                IsHandled := false;
                //OnBeforeValidateDropShipment(Rec, xRec, CurrFieldNo, IsHandled);
                if IsHandled then exit;
                TestField("Document Type", "Document Type"::Invoice);
                IF (Type <> Type::Item) AND (Type <> Type::Resource) then error(Text50003);
                TestField("Quantity Shipped", 0);
                IsHandled := false;
                //OnValidateDropShipmentOnBeforeTestJobNo(Rec, IsHandled);
                if not IsHandled then
                    TestField("Job No.", '');
                If Type = Type::Item then
                    TestField("Qty. to Asm. to Order (Base)", 0);
                if "Drop Shipment" then
                    TestField("Special Order", false);
                CheckAssocPurchOrder(FieldCaption("Drop Shipment"));
                if "Special Order" then
                    Reserve := Reserve::Never
                else
                    if "Drop Shipment" then begin
                        Reserve := Reserve::Never;
                        Evaluate("Outbound Whse. Handling Time", '<0D>');
                        Evaluate("Shipping Time", '<0D>');
                        UpdateDates();
                        "Bin Code" := '';
                    end
                    else
                        If Type = Type::Item then SetReserveWithoutPurchasingCode();
                If Type = Type::Item then begin
                    CheckItemAvailable(FieldNo("Drop Shipment"));
                    AddOnIntegrMgt.CheckReceiptOrderStatus(Rec);
                    if (xRec."Drop Shipment" <> "Drop Shipment") and (Quantity <> 0) then begin
                        if not "Drop Shipment" then begin
                            InitQtyToAsm();
                            AutoAsmToOrder();
                            UpdateWithWarehouseShip();
                        end
                        else
                            InitQtyToShip();
                        SalesWhseMgt.SalesLineVerifyChange(Rec, xRec);
                        if not FullReservedQtyIsForAsmToOrder() then VerifyChangeForSalesLineReserve(FieldNo("Drop Shipment"));
                    end;
                end;
            end;
        }
        field(50250; "Start Time"; time)
        {
            Caption = 'Start Time';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "Start Date" = 0D then "Start Date" := today;
                StartDT := CreateDateTime("Start Date", "Start Time");
                If Rec."Start Time" <> xRec."Start Time" then begin
                    "End Date" := 0D;
                    "End Time" := 0T;
                end;
            end;
        }
        field(50260; "End Time"; time)
        {
            Caption = 'End Time';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                testfield("Start Date");
                testfield("Start Time");
                IF "End Date" = 0D then
                    "End Date" := today;
                EndDT := CreateDateTime("End Date", "End Time");
                IF "Start Date" = "End Date" then
                    If "Start Time" > "End Time" then error(Text50006);
                IF NOT H2OCal.findfirst then
                    error(Text50011)
                else
                    IF H2OCal.get("Start Date") then begin
                        // Contract Start Contract Day (Normal Day)
                        IF (StartDT > H2OCal.ContractST) AND (EndDT < H2OCal.ContractET) AND ("End Date" = "Start Date") then CalcTimeInterval.NormalDay(rec, SalesHeader, H2OCal);
                        // Early Start - Contract End
                        IF (StartDT < H2OCal.ContractST) AND (EndDT < H2OCal.ContractET) and ("End Date" = "Start Date") then CalcTimeInterval.EarlyStartContractEnd(rec, SalesHeader, H2OCal);
                        // Early Start - Late End
                        IF (StartDT < H2OCal.ContractST) AND (EndDT > H2OCal.ContractET) AND ("End Date" = "Start Date") then CalcTimeInterval.EarlyStartLateEnd(rec, SalesHeader, H2OCal);
                        // Contract Start - Late End
                        If (StartDT > H2OCal.ContractST) AND (StartDT < H2OCal.ContractET) AND (EndDT > H2OCal.ContractET) AND ("End Date" = "Start Date") then CalcTimeInterval.ContractStartLateEnd(rec, SalesHeader, H2OCal);
                        // Late Start after End Day - End Late
                        If (StartDT > H2OCal.ContractST) AND (StartDT > H2OCal.ContractET) AND (EndDT > H2OCal.ContractET) AND ("End Date" = "Start Date") then CalcTimeInterval.LateStartLateEnd(rec, SalesHeader, H2OCal);
                        // Overnight
                        IF (StartDT > H2OCal.ContractET) AND (EndDT > H2OCal.ContractST) AND ("End Date" > "Start Date") then begin
                            DateDiff := "End Date" - "Start Date";
                            IF DateDiff = 1 then //overnight
                                CalcTimeInterval.Overnight(rec, SalesHeader, H2OCal);
                        end;
                        // Multiple Days
                        IF H2OCalEnd.get("End Date") then
                            IF ("End Date" > "Start Date") then begin
                                DateDiff := "End Date" - "Start Date";
                                IF DateDiff >= 1 then //many days
                                    CalcTimeInterval.ManyDays(rec, SalesHeader, H2OCal, H2OCalEnd)
                            end;
                    end;
            end;
        }
        field(50270; "Start Date"; Date)
        {
            Caption = 'Start Date';
            DataClassification = ToBeClassified;
        }
        field(50280; "End Date"; Date)
        {
            Caption = 'End Date';
            DataClassification = ToBeClassified;
        }
        field(50290; StartDT; DateTime)
        {
            Caption = 'StartDT';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50300; EndDT; DateTime)
        {
            Caption = 'EndDT';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50310; "WO Supervisor"; code[20])
        {
            Caption = 'Work Order Supervisor';
            DataClassification = ToBeClassified;
            TableRelation = Resource where(Type = Const(Person));
        }
        field(50320; "Rental Work Order No."; code[20])
        {
            Caption = 'Rental Work Order No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50330; "Original Completed Date"; date)
        {
            Caption = 'Original Completed Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50340; "Work Order Type Code"; code[10])
        {
            Caption = 'Work Order Type Code';
            DataClassification = ToBeClassified;
            TableRelation = "Work Order Type";
        }
        field(50345; "Material Amount"; Decimal)
        {
            Caption = 'Material Amount';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50350; "Labor Amount"; Decimal)
        {
            Caption = 'Labor Amount';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50355; "Equipment Amount"; Decimal)
        {
            Caption = 'Equipment Amount';
            DataClassification = ToBeClassified;
            editable = false;
        }
        field(50360; "Location Comment"; boolean)
        {
            Caption = 'Equipment Amount';
            DataClassification = ToBeClassified;
            editable = false;
        }
        field(50379; "WO Purpose"; boolean)
        {
            Caption = 'WO Purpose';
            DataClassification = ToBeClassified;
            editable = false;
        }
    }



    keys
    {
        key(Key40; "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Document No.", "Line No.")
        {
            IncludedFields = "Outstanding Qty. (Base)";
        }
    }



    var
        MtrSetup: record "Meter Setup";
        Mtr: record Meter;
        Res: record Resource;
        SalesHeader: record "Sales Header";
        AssocRes: record "Associated Resource";
        SalesLine2: record "Sales Line";
        SalesLine3: record "Sales Line";
        ResSetup: record "Resources Setup";
        H2OCal: record "H2O Calendar";
        H2OCalEnd: record "H2O Calendar";
        WT: record "Work Type";
        CalcMtrPrice: codeunit "Meter Price Calculation";
        CalcResCustPrice: codeunit "Res. Cust. Price Calc.";
        CalcTimeInterval: codeunit "Calc Time Interval";
        LineNo: integer;
        Text50000: TextConst ENU = 'Meter No. %1 is already assigned to Customer No. %2 and Ship-to Code %3.';
        Text50002: TextConst ENU = 'Rental Start Date cannot be greater than Rental End Date.';
        Text50003: TextConst ENU = 'Type must be either Item or Resource.';
        Text50004: TextConst ENU = 'End Time must be greater than Start Time.';
        Text50005: TextConst ENU = 'Start Time cannot be blank.';
        Text50006: TextConst ENU = 'End Date must be greater than or equal to Start Date';
        Text50011: TextConst ENU = 'The H2O Calendar is not set up.';
        AddOnIntegrMgt: Codeunit AddOnIntegrManagement;
        WhseValidateSourceLine: Codeunit "Whse. Validate Source Line";
        TempDate: date;
        DateDiff: integer;



    trigger OnAfterInsert()
    var
        SalesHeader: record "Sales Header";
    begin
        "Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
        IF SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then
            "Original Ship-to Code" := SalesHeader."Ship-to Code";

        //Associated 
        If rec.Type = rec.Type::Resource then begin
            AssocRes.reset;
            AssocRes.setrange("Resource No.", rec."No.");
            if AssocRes.findset then begin
                LineNo := "Line No.";
                repeat
                    LineNo += 10;
                    SalesLine2.reset;
                    SalesLine2.setrange("Document Type", rec."Document Type");
                    SalesLine2.setrange("Document No.", rec."Document No.");
                    SalesLine2.setrange(Type, rec.Type::Resource);
                    SalesLine2.setrange("No.", rec."No.");
                    If SalesLine2.findfirst then begin
                        SalesLine3.init;
                        SalesLine3."Document Type" := SalesLine2."Document Type";
                        SalesLine3."Document No." := SalesLine2."Document No.";
                        SalesLine3."Line No." := LineNo;
                        SalesLine3.insert(false);
                        SalesLine3.Type := AssocRes."Assoc. Type";
                        SalesLine3.validate("No.", AssocRes."Associated No.");
                        SalesLine3.validate("Associated No.", AssocRes."Associated No.");
                        SalesLine3.Description := AssocRes.Name;
                        SalesLine3."Description 2" := AssocRes."Name 2";
                        SalesLine3.Rental := AssocRes.Rental;
                        SalesLine3."Unit of Measure Code" := AssocRes."Base Unit of Measure";
                        If Res.get(AssocRes."Resource No.") then
                            SalesLine3.validate("Tax Group Code", Res."Tax Group Code");
                        SalesLine3.validate(Quantity, AssocRes.Quantity);
                        SalesLine3.UpdateUnitPriceByField(FieldNo("Associated No."));
                        If SalesLine3."Work Type Code" <> '' then
                            SalesLine3.UpdateUnitPriceByField(FieldNo("Work Type Code"));
                        SalesLine3.modify(false);
                    end;
                until AssocRes.next = 0;
            end;
        end;
        IF SalesHeader.get("Document Type", "Document No.") then begin
            "Original Ship-to Code" := SalesHeader."Ship-to Code";
            "Original Document No." := SalesHeader."No.";
            "Original Completed Date" := SalesHeader."Completed Date";
            "Original Line No." := "Line No.";
            "Original No." := "No.";
        end;
    end;



    /*
    trigger OnBeforeModify()
    var
        SalesHeader: record "Sales Header";
    begin
        IF SalesHeader.get("Document Type", "Document No.") then begin
            "Original Ship-to Code" := SalesHeader."Ship-to Code";
            "Original Document No." := SalesHeader."No.";
            "Original Completed Date" := SalesHeader."Completed Date";
            "Original Line No." := "Line No.";
            "Original No." := "No.";
        end;
    end;
    */



    procedure CalcRentDate()
    var
        StartDay: integer;
        EndDay: integer;
    begin
        IF "Rental End Date" <> 0D then begin
            IF "Rental Start Date" > "Rental End Date" then
                error(Text50002);
            IF ("Rental Start Date" <= today) AND ("Rental End Date" >= today) then
                "On Rent" := true;
            StartDay := DATE2DMY("Rental Start Date", 1);
            EndDay := DATE2DMY("Rental End Date", 1);
            "Rental Days" := EndDay - StartDay + 1;
            If "On Rent" then
                "Rental Work Order No." := "Document No.";
        end;
    end;



    local procedure FullReservedQtyIsForAsmToOrder(): Boolean
    begin
        if "Qty. to Asm. to Order (Base)" = 0 then
            exit(false);
        CalcFields("Reserved Qty. (Base)");
        exit("Reserved Qty. (Base)" = "Qty. to Asm. to Order (Base)");
    end;



    local procedure ChooseWorkType(var
                                       SalesLine: record "Sales Line";
                                       SalesHeader: record "Sales Header")
    begin
        IF NOT H2OCal.findfirst then
            error(Text50011)
        else
            If H2OCal.get(SalesHeader."Posting Date") then // If Nonworking day, OT regardless
                IF H2OCal."Nonworking Day" then begin
                    WT.setrange(Overtime, true);
                    IF WT.findfirst then
                        SalesLine."Work Type Code" := WT.Code;
                end
                else begin
                    //If before start time or after end time, then OT
                    IF (rec."Start Time" < H2OCal."Contract Start Time") OR (rec."End Time" > H2OCal."Contract End Time") then begin
                        WT.setrange(Overtime, true);
                        IF WT.FindFirst then
                            SalesLine."Work Type Code" := WT.Code;
                    end
                    else begin
                        //else Contract
                        WT.setrange(Contract, true);
                        IF WT.FindFirst then
                            SalesLine."Work Type Code" := WT.Code;
                    end;
                end;
    end;



    procedure CalcResPrice(var SalesLine: record "Sales Line")
    var
        UsePrice: decimal;
    begin
        If SalesLine.Type = SalesLine.Type::Resource then
            If Res.get(SalesLine."No.") then begin
                SalesLine.Rental := Res.Rental;
                If ResSetup.get then
                    If ResSetup."Use Resource Customer Prices" then begin
                        UsePrice := CalcResCustPrice.CalculateResPrice(SalesLine);
                        //SalesLine.validate("Unit Price", CalcResCustPrice.CalculateResPrice(SalesLine));
                        SalesLine.validate("Unit Price", UsePrice);

                    end;
            end;
    end;



    procedure UpdateMEL()
    var
        Res: record Resource;
    begin
        IF Type = Type::Item then "Material Amount" := "Amount Including VAT";
        If Type = Type::Resource then begin
            Res.get("No.");
            If Res.Type = Res.Type::Machine then "Equipment Amount" := "Amount Including VAT";
            IF Res.Type = Res.Type::Person then "Labor Amount" := "Amount Including VAT";
        end;
        If Type = Type::Meter then "Labor Amount" := "Amount Including VAT";
        //SalesLine.modify;
    end;
}

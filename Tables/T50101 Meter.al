table 50101 Meter
{
    Caption = 'Meter';
    DataCaptionFields = "No.", Description;
    DataClassification = ToBeClassified;
    LookupPageId = "Meter List";
    DrillDownPageId = "Meter List";
    Permissions = TableData "Meter Ledger Entry" = r,
                    tabledata "Meter Activity" = r,
                    tabledata "Meter Journal Line" = rimd,
                    tabledata "Meter Journal Template" = r,
                    tabledata "Meter Journal Batch" = r,
                    tabledata "Meter Group" = r,
                    tabledata "Meter Price" = r,
                    tabledata "Meter Setup" = r,
                    tabledata Meter = rim;


    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;

            /*
            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    MtrSetup.GET;
                    NoSeriesMgt.TestManual(MtrSetup."Meter Nos.");
                    "No. Series" := '';

                    validate("Serial No.", "No.");
                END;
            end;
            */

            trigger OnValidate()
            begin
                TestNoSeries();
            end;



        }
        field(5; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                IF ("Search Name" = UPPERCASE(xRec.Description)) OR ("Search Name" = '') THEN
                    "Search Name" := Description;
            end;
        }
        field(10; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
            DataClassification = ToBeClassified;
        }
        field(12; "Serial No."; code[20])
        {
            Caption = 'Serial No.';
            DataClassification = ToBeClassified;
        }
        field(15; "Search Name"; Code[100])
        {
            Caption = 'Search Name';
            DataClassification = ToBeClassified;
        }
        field(20; "Meter Group Code"; Code[10])
        {
            Caption = 'Meter Group Code';
            DataClassification = ToBeClassified;
            TableRelation = "Meter Group";
            trigger OnValidate()
            begin
                IF "Meter Group Code" = xRec."Meter Group Code" THEN
                    EXIT;

                IF xRec."Meter Group Code" <> '' THEN
                    IF NOT CONFIRM(Text001, FALSE, FIELDCAPTION("Meter Group Code")) THEN BEGIN
                        "Meter Group Code" := xRec."Meter Group Code";
                        EXIT;
                    END;

                IF xRec.GETFILTER("Meter Group Code") <> '' THEN
                    SETFILTER("Meter Group Code", "Meter Group Code");

                IF MtrGrp.get("Meter Group Code") then
                    "Inspection Interval Gallons" := MtrGrp."Inspection Interval Gallons";
            end;
        }
        field(27; "Customer Owned"; Boolean)
        {
            Caption = 'Customer Owned';
            DataClassification = ToBeClassified;
        }
        Field(25; "Customer No."; code[20])
        {
            Caption = 'Customer No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer;

            trigger OnValidate()
            begin
                If Cust.get("Customer No.") then begin
                    Name := Cust.Name;
                    "Name 2" := Cust."Name 2";
                    Address := Cust.Address;
                    "Address 2" := Cust."Address 2";
                    City := Cust.City;
                    County := Cust.County;
                    "Post Code" := Cust."Post Code";

                    Rte.reset;
                    Rte.setrange("Customer No.", Cust."No.");
                    IF Rte.findfirst then
                        "Route No." := Rte."No.";

                    CheckExistingCust();
                end;

                IF "Customer No." = '' then begin
                    "Ship-to Code" := '';
                    Name := '';
                    "Name 2" := '';
                    Address := '';
                    "Address 2" := '';
                    City := '';
                    County := '';
                    "Post Code" := '';
                    "Route No." := 0;
                end;
            end;
        }
        field(30; "Ship-to Code"; code[10])
        {
            Caption = 'Property No.';
            DataClassification = ToBeClassified;
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Customer No."));

            trigger OnValidate()
            var
                ShipToAddr: record "Ship-to Address";
            begin
                testfield("Customer No.");

                /*
                If ShipToAddr.get("Customer No.", "Ship-to Code") then begin
                    Name := ShipToAddr.Name;
                    "Name 2" := ShipToAddr."Name 2";
                    Address := ShipToAddr.Address;
                    "Address 2" := ShipToAddr."Address 2";
                    City := ShipToAddr.City;
                    County := ShipToAddr.County;
                    "Post Code" := ShipToAddr."Post Code";
                    "Route No." := ShipToAddr."Route No.";

                    CheckExistingShipTo();
                end;

                IF "Ship-to Code" = '' then begin
                    IF Cust.get("Customer No.") then begin
                        Name := Cust.Name;
                        "Name 2" := Cust."Name 2";
                        Address := Cust.Address;
                        "Address 2" := Cust."Address 2";
                        City := Cust.City;
                        County := Cust.County;
                        "Post Code" := Cust."Post Code";
                        "Route No." := 0;
                    end;
                end;
                */
            end;
        }
        field(35; Name; Text[100])
        {
            Caption = 'Customer Name';
            FieldClass = flowfield;
            CalcFormula = lookup("Ship-to Address".Name WHERE("Customer No." = FIELD("Customer No."), Code = FIELD("Ship-to Code")));
            Editable = false;
        }
        field(40; "Name 2"; Text[100])
        {
            Caption = 'customer Name 2';
            FieldClass = flowfield;
            CalcFormula = lookup("Ship-to Address"."Name 2" WHERE("Customer No." = FIELD("Customer No."), Code = FIELD("Ship-to Code")));
            Editable = false;
        }
        field(45; Address; text[100])
        {
            Caption = 'Address';
            FieldClass = flowfield;
            CalcFormula = lookup("Ship-to Address".Address WHERE("Customer No." = FIELD("Customer No."), Code = FIELD("Ship-to Code")));
            Editable = false;
        }
        field(50; "Address 2"; text[100])
        {
            Caption = 'Address 2';
            FieldClass = flowfield;
            CalcFormula = lookup("Ship-to Address"."Address 2" WHERE("Customer No." = FIELD("Customer No."), Code = FIELD("Ship-to Code")));
            Editable = false;
        }
        field(55; City; text[30])
        {
            Caption = 'City';
            FieldClass = flowfield;
            CalcFormula = lookup("Ship-to Address".City WHERE("Customer No." = FIELD("Customer No."), Code = FIELD("Ship-to Code")));
            Editable = false;

            /*
            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);
            end;

            trigger OnLookup()
            begin
                PostCode.LookupPostCode(City, "Post Code", County, "Country/Region Code");
            end;
            */
        }
        field(60; County; text[30])
        {
            Caption = 'State';
            FieldClass = flowfield;
            CalcFormula = lookup("Ship-to Address".County WHERE("Customer No." = FIELD("Customer No."), Code = FIELD("Ship-to Code")));
            Editable = false;
        }
        field(65; "Post Code"; code[20])
        {
            Caption = 'ZIP Code';
            FieldClass = flowfield;
            CalcFormula = lookup("Ship-to Address"."Post Code" WHERE("Customer No." = FIELD("Customer No."), Code = FIELD("Ship-to Code")));
            Editable = false;
        }
        field(67; "Country/Region Code"; code[10])
        {
            Caption = 'Country Code';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                PostCode.CheckClearPostCodeCityCounty(City, "Post Code", County, "Country/Region Code", xRec."Country/Region Code");
            end;
        }
        field(70; "Last Date Modified"; date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(75; Blocked; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = ToBeClassified;
        }
        field(80; "Date Filter"; date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(85; "Gen. Prod. Posting Group"; code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group";
        }
        field(86; "Global Dimension 1 Code"; code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            //DataClassification = ToBeClassified;
            //TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
            //                                              Blocked = CONST(false));
            TableRelation = Customer."Global Dimension 1 Code" where("No." = field("Customer No."));
            FieldClass = flowfield;
            CalcFormula = Lookup(Customer."Global Dimension 1 Code" WHERE("No." = FIELD("Customer No.")));

            //trigger OnValidate()
            //begin
            //    ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            //end;
        }
        field(88; "Global Dimension 2 Code"; code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(90; "No. Series"; code[10])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
        }
        field(95; Comment; Boolean)
        {
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Exist("Comment Line" WHERE("Table Name" = CONST(Meter),
                                                      "No." = FIELD("No.")));
        }
        field(100; "Previous Meter Reading"; decimal)
        {
            Caption = 'Previous Meter Reading';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(105; "Current Meter Reading"; decimal)
        {
            Caption = 'Current Meter Reading';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(110; "Water Usage"; Decimal)
        {
            Caption = 'Water Usage';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(115; "Previous Meter Reading Date"; date)
        {
            caption = 'Previous Meter Reading Date';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(120; "Current Meter Reading Date"; date)
        {
            caption = 'Current Meter Reading Date';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(125; "Created From ILE Entry No."; Integer)
        {
            caption = 'Created From ILE Entry No.';
            BlankZero = true;
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup("Item Ledger Entry"."Entry No." WHERE("Serial No." = FIELD("Serial No."), "Entry Type" = CONST(Sale)));
        }
        field(130; "Sent To Opus"; Boolean)
        {
            caption = 'Sent To Opus';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(135; "Sent To Opus Date"; date)
        {
            caption = 'Sent To Opus Date';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(140; "Sent To Opus Time"; time)
        {
            caption = 'Sent To Opus Time';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(145; "Warranty Start Date"; date)
        {
            caption = 'Warranty Start Date';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                MtrSetup.get;
                "Warranty End Date" := CalcDate(MtrSetup."Default Warranty Period", "Warranty Start Date");
            end;
        }
        field(150; "Warranty End Date"; date)
        {
            caption = 'Warranty End Date';
            DataClassification = ToBeClassified;
        }
        field(155; "Inspection Interval Gallons"; Decimal)
        {
            caption = 'Inspection Interval Gallons';
            DataClassification = ToBeClassified;
        }
        field(160; "Meter Blocked Reason"; code[10])
        {
            caption = 'Meter Blocked Reason';
            DataClassification = ToBeClassified;

            TableRelation = "Meter Activity" where(Reading = CONST(false));
            trigger OnValidate()
            begin
                testfield(Blocked, TRUE)
            end;
        }
        field(165; "New Meter No."; code[20])
        {
            caption = 'New Meter No.';
            DataClassification = ToBeClassified;
            TableRelation = Meter;
            trigger OnValidate()
            begin
                If MtrActivity.get("Meter Blocked Reason") then
                    MtrActivity.testfield("Requires New Meter", true);
            end;
        }
        field(170; "Must Send To Opus"; Boolean)
        {
            caption = 'Must Send To Opus';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(175; "System Created"; Boolean)
        {
            caption = 'System Created';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(180; "Must Send To Mendix"; Boolean)
        {
            caption = 'Must Send To Mendix';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(185; "Sent To Mendix"; Boolean)
        {
            caption = 'Sent To Mendix';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(190; "Sent To Mendix Date"; date)
        {
            caption = 'Sent To Mendix Date';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(195; "Sent To Mendix Time"; time)
        {
            caption = 'Sent To Mendix Time';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(200; "EID No."; code[20])
        {
            Caption = 'Endpoint ID';
            DataClassification = ToBeClassified;
        }
        field(205; "Endpoint Type"; code[10])
        {
            Caption = 'Endpoint Type';
            DataClassification = ToBeClassified;
        }
        field(210; "Service Address ID"; code[10])
        {
            Caption = 'Service Address ID';
            DataClassification = ToBeClassified;
        }
        field(215; "Service Address Type"; code[10])
        {
            Caption = 'Service Address Type';
            DataClassification = ToBeClassified;
        }
        field(220; "Service Address Class Code"; code[10])
        {
            Caption = 'Service Address Class Code';
            DataClassification = ToBeClassified;
            TableRelation = "Meter Service Address Class";
        }
        field(225; "Meter Install Date"; date)
        {
            Caption = 'Meter Install Date';
            DataClassification = ToBeClassified;
        }
        field(230; "Meter Register Resolution"; enum "Meter Register Resolution")
        {
            Caption = 'Meter Register Resolution';
            DataClassification = ToBeClassified;
        }
        field(235; "Reg. Unit of Measure Code"; code[10])
        {
            Caption = 'Meter Register Unit of Measure';
            DataClassification = ToBeClassified;
            TableRelation = "Unit of Measure";
        }
        field(240; "Endpoint Install Date"; date)
        {
            Caption = 'Endpoint Install Date';
            DataClassification = ToBeClassified;
        }
        field(245; "Meter Manufacturer Code"; code[10])
        {
            Caption = 'Meter Manufacturer Code';
            DataClassification = ToBeClassified;
            TableRelation = "Meter Manufacturer";
        }
        field(250; "Tax Group Code"; code[10])
        {
            Caption = 'Tax Group Code';
            DataClassification = ToBeClassified;
            TableRelation = "Tax Group";
        }
        field(255; "Phone No."; text[30])
        {
            Caption = 'Phone No.';
            DataClassification = ToBeClassified;
        }
        field(260; "Opus Account No."; code[20])
        {
            Caption = 'Opus Account No.';
            //DataClassification = ToBeClassified;
            FieldClass = flowfield;
            CalcFormula = lookup("Ship-to Address"."Opus Account No." WHERE("Customer No." = FIELD("Customer No."), Code = FIELD("Ship-to Code")));
            Editable = false;
        }
        field(265; "Route No."; Integer)
        {
            Caption = 'Route No.';
            TableRelation = Route."No." where("Customer No." = field("Customer No."));
            FieldClass = flowfield;
            CalcFormula = lookup("Ship-to Address"."Route No." WHERE("Customer No." = FIELD("Customer No."), Code = FIELD("Ship-to Code")));
            Editable = false;
        }
        field(267; "Installation Date"; date)
        {
            Caption = 'Installation Date';
            DataClassification = ToBeClassified;
            ObsoleteState = Pending;
            ObsoleteReason = 'Not Needed';
        }
        field(270; "Purchase Date"; date)
        {
            caption = 'Meter Purchase Date';
            DataClassification = ToBeClassified;
        }
        field(275; "Inspection Date"; date)
        {
            caption = 'Meter Inspection Date';
            DataClassification = ToBeClassified;
        }
        field(280; "Scrap Date"; date)
        {
            caption = 'Scrap Date';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                MtrActivity.reset;
                MtrActivity.setrange(Scrapped, true);
                If MtrActivity.findfirst then begin
                    IF "Scrap Date" <> 0D then begin
                        Blocked := true;
                        "Meter Blocked Reason" := MtrActivity.Code;
                    end else begin
                        Blocked := false;
                        "Meter Blocked Reason" := '';
                    end;
                end;
            end;
        }
        field(285; Size; enum "Meter Size")
        {
            caption = 'Meter Size';
            DataClassification = ToBeClassified;
        }
        field(290; "No. of Dials"; enum "No. Of Dials")
        {
            caption = 'No. Of Dials';
            DataClassification = ToBeClassified;
        }
        field(295; "Meter Type"; enum "Meter Type")
        {
            caption = 'Meter Type';
            DataClassification = ToBeClassified;
        }
        field(300; "Utility Type"; enum "Utility Type")
        {
            caption = 'Utility Type';
            DataClassification = ToBeClassified;
        }
        field(305; "Service Type"; enum "Service Type")
        {
            caption = 'Service Type';
            DataClassification = ToBeClassified;
        }
        field(310; "Opus Location"; code[10])
        {
            caption = 'Opus Location';
            DataClassification = ToBeClassified;
        }
        Field(315; "Location Stop"; Code[20])
        {
            caption = 'Location Stop';
            //TableRelation = "Location Stop"."Location Stop" where("Route No." = field("Route No."));
            FieldClass = flowfield;
            CalcFormula = lookup("Ship-to Address"."Location Stop" WHERE("Customer No." = FIELD("Customer No."), Code = FIELD("Ship-to Code")));
            Editable = false;
        }
        field(320; "Smart Meter"; boolean)
        {
            caption = 'Smart Meter';
            DataClassification = ToBeClassified;
        }
        field(325; "Route-Location"; text[100])
        {
            Editable = false;
            Caption = 'Route-Location Concatenation';
            DataClassification = ToBeClassified;
        }
    }




    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key("Route-Location"; "Route-Location")
        { }
    }


    var
        Mtr: Record Meter;
        MtrSetup: Record "Meter Setup";
        MtrGrp: record "Meter Group";
        MtrLedgEntry: record "Meter Ledger Entry";
        MtrActivity: record "Meter Activity";
        MtrServCass: record "Meter Service Address Class";
        SalesLine: Record "Sales Line";
        PostCode: Record "Post Code";
        Cust: record customer;
        Rte: record route;
        //NoSeriesMgt: Codeunit "No. Series";
        NoSeries: Codeunit "No. Series";
        DimMgt: Codeunit DimensionManagement;
        Text001: TextConst ENU = 'Do you want to change %1?';
        Text002: TextConst ENU = 'You cannot change %1 because there are ledger entries for this non-owned asset.';
        Text003: TextConst ENU = 'Meter No. %1 is already assigned to this Customer and Ship-to Address.';
        Text004: TextConst ENU = 'Meter No. %1 cannot be deleted as there are meter ledger entries for this meter.';
        Text005: TextConst ENU = 'Meter No. %1 is already assigned to Customer No. %2';
        Text006: TextConst ENU = 'Meter No. %1 is already assigned to Ship-to Code %2';


    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            MtrSetup.GET;
            MtrSetup.TESTFIELD("Meter Nos.");
            //NoSeriesMgt.InitSeries(MtrSetup."Meter Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;

        IF GETFILTER("Meter Group Code") <> '' THEN
            IF GETRANGEMIN("Meter Group Code") = GETRANGEMAX("Meter Group Code") THEN
                VALIDATE("Meter Group Code", GETRANGEMIN("Meter Group Code"));

        DimMgt.UpdateDefaultDim(
          DATABASE::Meter, "No.",
          "Global Dimension 1 Code", "Global Dimension 2 Code");

        "Gen. Prod. Posting Group" := MtrSetup."Gen. Prod. Posting Group";
        "Last Date Modified" := today;

        "Must Send To Opus" := true;
        "Sent To Opus" := false;
        "Sent To Opus Date" := 0D;
        "Sent To Opus Time" := 0T;

        "Must Send To Mendix" := true;
        "Sent To Mendix" := false;
        "Sent To Mendix Date" := 0D;
        "Sent To Mendix Time" := 0T;

        CalcFields("Route No.", "Location Stop");
        "Route-Location" := format("Route No.") + '-' + format("Location Stop");
    end;


    trigger OnModify()
    begin
        "Last Date Modified" := TODAY;

        If (rec.Name <> xrec.Name) or
            (rec."Name 2" <> xrec."Name 2") or
            (rec.Address <> xrec.Address) or
            (rec."Address 2" <> xrec."Address 2") or
            (rec.City <> xrec.City) or
            (rec.County <> xrec.County) or
            (rec."Country/Region Code" <> xrec."Country/Region Code") or
            (rec."Post Code" <> xrec."Post Code") or
            (rec.Blocked <> xrec.Blocked) or
            (rec."Serial No." <> xrec."Serial No.") or
            (rec."Customer No." <> xrec."Customer No.") or
            (rec."Ship-to Code" <> xrec."Ship-to Code") then begin

            "Must Send To Opus" := true;
            "Sent To Opus" := false;
            "Sent To Opus Date" := 0D;
            "Sent To Opus Time" := 0T;

            "Must Send To Mendix" := true;
            "Sent To Mendix" := false;
            "Sent To Mendix Date" := 0D;
            "Sent To Mendix Time" := 0T;
        end;

        CalcFields("Route No.", "Location Stop");
        "Route-Location" := format("Route No.") + '-' + format("Location Stop");

    end;


    trigger OnDelete()
    begin
        //MtrLedgEntry.reset;
        //MtrLedgEntry.setrange("Meter No.", "No.");
        //IF MtrLedgEntry.findfirst then
        //    error(Text004);
    end;


    trigger OnRename()
    begin
        SalesLine.RenameNo(SalesLine.Type::Meter, xRec."No.", "No.");

        "Last Date Modified" := TODAY;

        "Must Send To Opus" := true;
        "Sent To Opus" := false;
        "Sent To Opus Date" := 0D;
        "Sent To Opus Time" := 0T;

        "Must Send To Mendix" := true;
        "Sent To Mendix" := false;
        "Sent To Mendix Date" := 0D;
        "Sent To Mendix Time" := 0T;
    end;


    /*
    procedure AssistEdit(OldMtr: Record Meter): Boolean
    begin
        Mtr := Rec;
        MtrSetup.GET;
        MtrSetup.TESTFIELD("Meter Nos.");
        IF NoSeriesMgt.SelectSeries(MtrSetup."Meter Nos.", OldMtr."No. Series", "No. Series") THEN BEGIN
            MtrSetup.GET;
            MtrSetup.TESTFIELD("Meter Nos.");
            NoSeriesMgt.SetSeries("No.");
            Rec := Mtr;
            EXIT(TRUE);
    END;
    */

    // Rel 24.0 new procedure
    procedure AssistEdit(OldMtr: Record Meter): Boolean
    var
        Mtr: Record Meter;
    begin
        Mtr := Rec;
        MtrSetup.Get();
        MtrSetup.TestField("Meter Nos.");
        if NoSeries.LookupRelatedNoSeries(MtrSetup."Meter Nos.", OldMtr."No. Series", Mtr."No. Series") then begin
            Cust."No." := NoSeries.GetNextNo(Cust."No. Series");
            Rec := Mtr;
            OnAssistEditOnBeforeExit(Mtr);
            exit(true);
        end;
    end;



    local procedure ValidateShortcutDimCode(FieldNumber: Integer; VAR ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::Meter, "No.", FieldNumber, ShortcutDimCode);
        MODIFY;
    end;


    local procedure TestNoEntriesExist(CurrentFieldName: Text[100])
    begin
        MtrLedgEntry.SETRANGE("Meter No.", "No.");
        IF NOT MtrLedgEntry.ISEMPTY THEN
            ERROR(Text002, CurrentFieldName);
    end;


    local procedure CheckExistingCust()
    begin
        if MtrSetup.get then
            If MtrSetup."Verify Customer No." then
                IF "Customer No." <> '' then begin
                    Mtr.reset;
                    Mtr.setrange("No.", "No.");
                    IF Mtr.findfirst then begin
                        IF Mtr."Customer No." <> rec."Customer No." then
                            error(Text005, Mtr."No.", Mtr."Customer No.");
                    end;
                end;
    end;

    local procedure CheckExistingShipTo()
    begin
        if MtrSetup.get then
            If MtrSetup."Verify Ship-to Code" then
                If "Ship-to Code" <> '' then begin
                    Mtr.reset;
                    Mtr.setrange("No.", "No.");
                    Mtr.setrange("Customer No.", "Customer No.");
                    IF Mtr.findfirst then begin
                        IF Mtr."Ship-to Code" <> '' then
                            IF Mtr."Ship-to Code" <> rec."Ship-to Code" then
                                error(Text006, Mtr."No.", Mtr."Ship-to Code");
                    end;
                end;
    end;


    local procedure ConcatenateRouteLoc()
    begin
        CalcFields("Route No.", "Location Stop");
        "Route-Location" := format("Route No.") + '-' + format("Location Stop");
    end;


    // Rel 24.0 new procedure
    local procedure TestNoSeries()
    var
        Meter: Record Meter;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestNoSeries(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        if "No." <> xRec."No." then
            if not Meter.Get(Rec."No.") then begin
                MtrSetup.Get();
                NoSeries.TestManual(MtrSetup."Meter Nos.");
                "No. Series" := '';
            end;
    end;



    [IntegrationEvent(false, false)]
    local procedure OnAssistEditOnBeforeExit(var Meter: Record Meter)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestNoSeries(var Meter: Record Meter; xMeter: Record Meter; var IsHandled: Boolean)
    begin
    end;


}
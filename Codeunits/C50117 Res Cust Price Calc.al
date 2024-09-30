codeunit 50117 "Res. Cust. Price Calc."
{
    TableNo = "Resource Customer Price";
    Permissions = TableData "Resource Customer Price" = rm,
                TableData Resource = r;


    trigger OnRun()
    begin
    end;

    procedure CalculateResPrice(VAR SalesLine: Record "Sales Line") UsePrice: Decimal;
    begin
        ResCustPrice := 0;
        GroupPrice := 0;
        AllPrice := 0;
        UsePrice := 0;

        IF SalesHeader.get(SalesLine."Document Type", SalesLine."Document No.") then begin
            If SalesLine.Type = SalesLine.Type::Resource then begin
                If Res.get(SalesLine."No.") then begin

                    //Look for "All" pricing = "All Customers" sales code
                    ResCustPr.reset;
                    ResCustPr.setrange(Type, ResCustPr.Type::All);
                    ResCustPr.setrange("Sales Type", ResCustPr."Sales Type"::"All Customers");
                    ResCustPr.setrange("Work Type Code", SalesLine."Work Type Code");
                    ResCustPr.setrange("Unit Of Measure Code", SalesLine."Unit of Measure Code");
                    ResCustPr.setfilter("Starting Date", '<=%1', SalesHeader."Document Date");
                    If ResCustPr.Findlast then begin
                        IF ResCustPr."Ending Date" <> 0D then begin
                            ResCustPr.setfilter("Ending Date", '>=%1', SalesHeader."Document Date");
                            IF ResCustPr.findlast then
                                AllPrice := ResCustPr."Unit Price";
                        end else
                            AllPrice := ResCustPr."Unit Price";
                    end;

                    //Look for "All" pricing = "Customer" sales code
                    ResCustPr.reset;
                    ResCustPr.setrange(Type, ResCustPr.Type::All);
                    ResCustPr.setrange("Sales Type", ResCustPr."Sales Type"::Customer);
                    ResCustPr.setrange("Sales Code", SalesLine."Sell-to Customer No.");
                    ResCustPr.setrange("Work Type Code", SalesLine."Work Type Code");
                    ResCustPr.setrange("Unit Of Measure Code", SalesLine."Unit of Measure Code");
                    ResCustPr.setfilter("Starting Date", '<=%1', SalesHeader."Document Date");
                    If ResCustPr.Findlast then begin
                        IF ResCustPr."Ending Date" <> 0D then begin
                            ResCustPr.setfilter("Ending Date", '>=%1', SalesHeader."Document Date");
                            IF ResCustPr.findlast then
                                AllPrice := ResCustPr."Unit Price";
                        end else
                            AllPrice := ResCustPr."Unit Price";
                    end;

                    //Look for "All" pricing = "Customer Price Group" sales code
                    ResCustPr.reset;
                    ResCustPr.setrange(Type, ResCustPr.Type::All);
                    ResCustPr.setrange("Sales Type", ResCustPr."Sales Type"::"Customer Price Group");
                    ResCustPr.setrange("Work Type Code", SalesLine."Work Type Code");
                    ResCustPr.setrange("Unit Of Measure Code", SalesLine."Unit of Measure Code");
                    ResCustPr.setfilter("Starting Date", '<=%1', SalesHeader."Document Date");
                    If ResCustPr.Findlast then begin
                        IF ResCustPr."Ending Date" <> 0D then begin
                            ResCustPr.setfilter("Ending Date", '>=%1', SalesHeader."Document Date");
                            IF ResCustPr.findlast then
                                AllPrice := ResCustPr."Unit Price";
                        end else
                            AllPrice := ResCustPr."Unit Price";
                    end;

                    //Look for "resource" pricing, "All Customers" Sales Type
                    ResCustPr.reset;
                    ResCustPr.setrange(Type, ResCustPr.Type::Resource);
                    ResCustPr.setrange("No.", Res."No.");
                    ResCustPr.setrange("Sales Type", ResCustPr."Sales Type"::"All Customers");
                    ResCustPr.setrange("Work Type Code", SalesLine."Work Type Code");
                    ResCustPr.setrange("Unit Of Measure Code", SalesLine."Unit of Measure Code");
                    ResCustPr.setfilter("Starting Date", '<=%1', SalesHeader."Document Date");
                    If ResCustPr.findlast then begin
                        IF ResCustPr."Ending Date" <> 0D then begin
                            ResCustPr.setfilter("Ending Date", '>=%1', SalesHeader."Document Date");
                            IF ResCustPr.findlast then
                                ResCustPrice := ResCustPr."Unit Price";
                        end else
                            ResCustPrice := ResCustPr."Unit Price";
                    end;

                    //Look for "resource" pricing, "Customer" Sales Type
                    ResCustPr.reset;
                    ResCustPr.setrange(Type, ResCustPr.Type::Resource);
                    ResCustPr.setrange("No.", Res."No.");
                    ResCustPr.setrange("Sales Type", ResCustPr."Sales Type"::Customer);
                    ResCustPr.setrange("Sales Code", SalesLine."Sell-to Customer No.");
                    ResCustPr.setrange("Work Type Code", SalesLine."Work Type Code");
                    ResCustPr.setrange("Unit Of Measure Code", SalesLine."Unit of Measure Code");
                    ResCustPr.setfilter("Starting Date", '<=%1', SalesHeader."Document Date");
                    If ResCustPr.findfirst then begin
                        IF ResCustPr."Ending Date" <> 0D then begin
                            ResCustPr.setfilter("Ending Date", '>=%1', SalesHeader."Document Date");
                            IF ResCustPr.findfirst then
                                ResCustPrice := ResCustPr."Unit Price";
                        end else
                            ResCustPrice := ResCustPr."Unit Price";
                    end;

                    //Look for "resource" pricing, "Customer Price Group" Sales Type
                    ResCustPr.reset;
                    ResCustPr.setrange(Type, ResCustPr.Type::Resource);
                    ResCustPr.setrange("No.", Res."No.");
                    ResCustPr.setrange("Sales Type", ResCustPr."Sales Type"::"Customer Price Group");
                    rescustpr.setrange("Sales Code", SalesHeader."Customer Price Group");
                    ResCustPr.setrange("Work Type Code", SalesLine."Work Type Code");
                    ResCustPr.setfilter("Starting Date", '<=%1', SalesHeader."Document Date");
                    If ResCustPr.findlast then begin
                        If ResCustPr.findlast then begin
                            IF ResCustPr."Ending Date" <> 0D then begin
                                ResCustPr.setfilter("Ending Date", '>=%1', SalesHeader."Document Date");
                                IF ResCustPr.findlast then
                                    ResCustPrice := ResCustPr."Unit Price";
                            end else
                                ResCustPrice := ResCustPr."Unit Price";
                        end;
                    end;

                    //Look for "Group" pricing, "All Customers" Sales Type
                    ResCustPr.reset;
                    ResCustPr.setrange(Type, ResCustPr.Type::"Group(Resource)");
                    ResCustPr.setrange("No.", ResGroup."No.");
                    ResCustPr.setrange("Sales Type", ResCustPr."Sales Type"::"All Customers");
                    ResCustPr.setrange("Work Type Code", SalesLine."Work Type Code");
                    ResCustPr.setfilter("Starting Date", '<=%1', SalesHeader."Document Date");
                    IF ResCustPr.Findlast then begin
                        IF ResCustPr."Ending Date" <> 0D then begin
                            ResCustPr.setfilter("Ending Date", '>=%1', SalesHeader."Document Date");
                            IF ResCustPr.findlast then
                                GroupPrice := ResCustPr."Unit Price";
                        end else
                            GroupPrice := ResCustPr."Unit Price";
                    end;

                    //Look for "Group" pricing, "Customer" Sales Type
                    ResCustPr.reset;
                    ResCustPr.setrange(Type, ResCustPr.Type::"Group(Resource)");
                    ResCustPr.setrange("No.", Res."Resource Group No.");
                    ResCustPr.setrange("Sales Type", ResCustPr."Sales Type"::Customer);
                    ResCustPr.setrange("Work Type Code", SalesLine."Work Type Code");
                    ResCustPr.setfilter("Starting Date", '<=%1', SalesHeader."Document Date");
                    IF ResCustPr.Findlast then begin
                        IF ResCustPr."Ending Date" <> 0D then begin
                            ResCustPr.setfilter("Ending Date", '>=%1', SalesHeader."Document Date");
                            IF ResCustPr.findlast then
                                ResCustPrice := ResCustPr."Unit Price";
                        end else
                            GroupPrice := ResCustPr."Unit Price";
                    end;

                    //Look for "Group" pricing, "Customer Price Group" Sales Type
                    ResCustPr.reset;
                    ResCustPr.setrange(Type, ResCustPr.Type::"Group(Resource)");
                    ResCustPr.setrange("No.", Res."Resource Group No.");
                    ResCustPr.setrange("Sales Type", ResCustPr."Sales Type"::"Customer Price Group");
                    rescustpr.setrange("Sales Code", SalesHeader."Customer Price Group");
                    ResCustPr.setrange("Work Type Code", SalesLine."Work Type Code");
                    ResCustPr.setfilter("Starting Date", '<=%1', SalesHeader."Document Date");
                    IF ResCustPr.Findlast then begin
                        IF ResCustPr."Ending Date" <> 0D then begin
                            ResCustPr.setfilter("Ending Date", '>=%1', SalesHeader."Document Date");
                            IF ResCustPr.findlast then
                                ResCustPrice := ResCustPr."Unit Price";
                        end else
                            GroupPrice := ResCustPr."Unit Price"
                    end;
                end;

                If AllPrice <> 0 then
                    UsePrice := Allprice;

                If GroupPrice <> 0 then
                    UsePrice := GroupPrice;

                If ResCustPrice <> 0 then
                    UsePrice := ResCustPrice;
            end;
        end;
        exit(UsePrice);
    end;


    var
        SalesHeader: record "Sales Header";
        Res: record Resource;
        ResCustPr: record "Resource Customer Price";
        ResGroup: record "Resource Group";
        CustPrGroup: record "Customer Price Group";
        ResCustPrice: Decimal;
        GroupPrice: Decimal;
        AllPrice: decimal;
        UsePrice: Decimal;
}
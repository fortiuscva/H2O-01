codeunit 50111 "Meter Price Calculation"
{
    TableNo = "Meter Price";
    permissions = tabledata Meter = rim,
                tabledata "Meter Price" = r;

    trigger OnRun()
    begin
    end;


    procedure CalculateMeterPrice(VAR SalesLine: Record "Sales Line") UsePrice: Decimal;
    begin
        MeterPrice := 0;
        GroupPrice := 0;
        AllPrice := 0;
        UsePrice := 0;

        If SalesLine.Type = SalesLine.Type::Meter then begin
            If SalesLine."Meter Activity Code" <> '' then begin
                If Mtr.get(SalesLine."No.") then begin
                    //Look for "All" pricing = "All Customers" sales code
                    MtrPrice.reset;
                    MtrPrice.setrange(Type, MtrPrice.Type::All);
                    MtrPrice.setrange("Sales Type", MtrPrice."Sales Type"::"All Customers");
                    MtrPrice.setrange("Meter Activity Code", SalesLine."Meter Activity Code");
                    If MtrPrice.FindFirst then
                        AllPrice := MtrPrice."Unit Price";

                    //Look for "All" pricing = "Customer" sales code
                    MtrPrice.reset;
                    MtrPrice.setrange(Type, MtrPrice.Type::All);
                    MtrPrice.setrange("Sales Type", MtrPrice."Sales Type"::Customer);
                    MtrPrice.setrange("Meter Activity Code", SalesLine."Meter Activity Code");
                    If MtrPrice.FindFirst then
                        AllPrice := MtrPrice."Unit Price";

                    //Look for "All" pricing = "Customer Price Group" sales code
                    MtrPrice.reset;
                    MtrPrice.setrange(Type, MtrPrice.Type::All);
                    MtrPrice.setrange("Sales Type", MtrPrice."Sales Type"::"Customer Price Group");
                    MtrPrice.setrange("Meter Activity Code", SalesLine."Meter Activity Code");
                    If MtrPrice.FindFirst then
                        AllPrice := MtrPrice."Unit Price";

                    //Look for "meter" pricing, "All Customers" Sales Type
                    MtrPrice.reset;
                    MtrPrice.setrange(Type, MtrPrice.Type::Meter);
                    MtrPrice.setrange("No.", Mtr."No.");
                    MtrPrice.setrange("Sales Type", MtrPrice."Sales Type"::"All Customers");
                    MtrPrice.setrange("Meter Activity Code", SalesLine."Meter Activity Code");
                    If MtrPrice.findfirst then
                        MeterPrice := MtrPrice."Unit Price";

                    //Look for "meter" pricing, "Customer" Sales Type
                    MtrPrice.reset;
                    MtrPrice.setrange(Type, MtrPrice.Type::Meter);
                    MtrPrice.setrange("No.", Mtr."No.");
                    MtrPrice.setrange("Sales Type", MtrPrice."Sales Type"::Customer);
                    MtrPrice.setrange("Meter Activity Code", SalesLine."Meter Activity Code");
                    If MtrPrice.findfirst then
                        MeterPrice := MtrPrice."Unit Price";

                    //Look for "meter" pricing, "Customer Price Group" Sales Type
                    MtrPrice.reset;
                    MtrPrice.setrange(Type, MtrPrice.Type::Meter);
                    MtrPrice.setrange("No.", Mtr."No.");
                    MtrPrice.setrange("Sales Type", MtrPrice."Sales Type"::"Customer Price Group");
                    MtrPrice.setrange("Meter Activity Code", SalesLine."Meter Activity Code");
                    If MtrPrice.findfirst then
                        MeterPrice := MtrPrice."Unit Price";

                    //Look for "Group" pricing, "All Customers" Sales Type
                    IF MtrGroup.get(Mtr."Meter Group Code") then begin
                        MtrPrice.reset;
                        MtrPrice.setrange(Type, MtrPrice.Type::"Group(Meter)");
                        MtrPrice.setrange("No.", MtrGroup."Code");
                        MtrPrice.setrange("Sales Type", MtrPrice."Sales Type"::"All Customers");
                        MtrPrice.setrange("Meter Activity Code", SalesLine."Meter Activity Code");
                        IF MtrPrice.FindFirst then
                            GroupPrice := MtrPrice."Unit Price"
                    end else
                        GroupPrice := MeterPrice;

                    //Look for "Group" pricing, "Customer" Sales Type
                    IF MtrGroup.get(Mtr."Meter Group Code") then begin
                        MtrPrice.reset;
                        MtrPrice.setrange(Type, MtrPrice.Type::"Group(Meter)");
                        MtrPrice.setrange("No.", MtrGroup."Code");
                        MtrPrice.setrange("Sales Type", MtrPrice."Sales Type"::Customer);
                        MtrPrice.setrange("Meter Activity Code", SalesLine."Meter Activity Code");
                        IF MtrPrice.FindFirst then
                            GroupPrice := MtrPrice."Unit Price"
                    end else
                        GroupPrice := MeterPrice;

                    //Look for "Group" pricing, "Customer Price Group" Sales Type
                    IF MtrGroup.get(Mtr."Meter Group Code") then begin
                        MtrPrice.reset;
                        MtrPrice.setrange(Type, MtrPrice.Type::"Group(Meter)");
                        MtrPrice.setrange("No.", MtrGroup."Code");
                        MtrPrice.setrange("Sales Type", MtrPrice."Sales Type"::"Customer Price Group");
                        MtrPrice.setrange("Meter Activity Code", SalesLine."Meter Activity Code");
                        IF MtrPrice.FindFirst then
                            GroupPrice := MtrPrice."Unit Price"
                    end else
                        GroupPrice := MeterPrice;

                    UsePrice := AllPrice;

                    If GroupPrice <> 0 then
                        IF GroupPrice <= UsePrice then
                            UsePrice := GroupPrice;

                    If MeterPrice <> 0 then
                        If MeterPrice <= UsePrice then
                            UsePrice := MeterPrice;

                end;
            end;
            exit(UsePrice);
        end;
    end;


    var
        Mtr: record Meter;
        MtrPrice: record "Meter Price";
        MtrGroup: record "Meter Group";
        MeterPrice: Decimal;
        GroupPrice: Decimal;
        AllPrice: decimal;
        UsePrice: Decimal;
}
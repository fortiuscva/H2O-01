report 50111 "Create Meter Reading Routes"
{
    ApplicationArea = All;
    Caption = 'Create Meter Reading Routes';
    UsageCategory = Tasks;
    ProcessingOnly = true;


    dataset
    {
        dataitem(ShipTo; "Ship-to Address")
        {
            DataItemTableView = sorting("Location Stop");
            RequestFilterFields = "Customer No.", Code, "Location Stop";
            RequestFilterHeading = 'Property Nos.';


            trigger OnAfterGetRecord()
            begin
                ShipTo.testfield("Route No.");

                Mtr.reset;
                Mtr.setrange("Customer No.", "Customer No.");
                Mtr.setrange("Ship-to Code", Code);
                Mtr.setrange("Smart Meter", false);
                If Mtr.findfirst then begin
                    MeterRoute.init;
                    MeterRoute."Resource No." := Res."No.";
                    MeterRoute."Customer No." := ShipTo."Customer No.";
                    MeterRoute."Ship-to Code" := ShipTo.Code;
                    MeterRoute."Route No." := ShipTo."Route No.";
                    MeterRoute."Location Stop" := ShipTo."Location Stop";
                    //MeterRoute."Smart Meter" := Meter."Smart Meter";
                    MeterRoute."Reading Date" := ReadDate;
                    MeterRoute."Meter No." := Mtr."No.";
                    MeterRoute."Serial No." := Mtr."Serial No.";
                    MeterRoute.Address := ShipTo.Address;
                    MeterRoute."Address 2" := ShipTo."Address 2";
                    MeterRoute.City := ShipTo.City;
                    MeterRoute.County := ShipTo.County;
                    MeterRoute."Post Code" := ShipTo."Post Code";
                    MeterRoute."Meter Journal Template" := Res."Meter Journal Template";
                    MeterRoute."Meter Journal Batch" := res."Meter Journal Batch";
                    Mtr.CalcFields("Global Dimension 1 Code");
                    MeterRoute."Shortcut Dimension 1 Code" := Mtr."Global Dimension 1 Code";
                    MeterRoute."Shortcut Dimension 2 Code" := Mtr."Global Dimension 2 Code";
                    LineNo += 10000;
                    MeterRoute."Line No." := LineNo;
                    If MeterRoute.insert then;
                end;
            end;


            trigger OnPreDataItem()
            begin
                If DelExisting then begin
                    MeterRoute.reset;
                    MeterRoute.DeleteAll();
                end;

                If MtrRte.findlast then
                    LineNo := MtrRte."Line No." + 10000
                else
                    LineNo := 0;

                clear(Res);
                If Res.get(ResNo) then begin
                    Res.testfield("Meter Journal Template");
                    Res.testfield("Meter Journal Batch");
                end;

                //If ReadDate = 0D then
                //    error(Text004);

                CustNo := getfilter("Customer No.");
                IF CustNo = '' then
                    error(Text001)
                else begin
                    IF Cust.get(CustNo) then begin
                        Cust.TestField("Meter Reading Day");
                        ReadDay := Cust."Meter Reading Day";
                        TempReadDate := Today();
                        Month := Date2DMY(TempReadDate, 2);
                        Year := Date2DMY(TempReadDate, 3);
                        ReadDate := DMY2Date(ReadDay, Month, Year);

                        //calcfields(Cust."Route No.");
                    end;
                end;
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
                    field(ResNo; ResNo)
                    {
                        TableRelation = Resource where(Type = CONST(Person));
                        Caption = 'Technician';
                        ApplicationArea = all;
                    }
                    //field(ReadDate; ReadDate)
                    //{
                    //    Caption = 'Meter Reading Date';
                    //}
                    field(DelExisting; DelExisting)
                    {
                        caption = 'Delete existing route records';
                        ApplicationArea = all;
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


    var
        MeterRoute: record "Meter Reading Route";
        MtrRte: record "Meter Reading Route";
        Res: record Resource;
        Mtr: record Meter;
        Cust: record Customer;
        Route: record Route;
        LocStop: Text;
        RouteNo: text;
        CustNo: Code[20];
        ResNo: Code[20];
        DelExisting: boolean;
        ReadDate: Date;
        TempReadDate: Date;
        ReadDay: integer;
        Month: integer;
        Year: integer;
        LineNo: integer;
        Text001: TextConst ENU = 'Customer No. filter cannot be blank';
        Text002: TextConst ENU = 'Resource No. filter cannot be blank';
        Text003: TextConst ENU = 'Route No. filter cannot be blank';
        Text004: TextConst ENU = 'Meter Reading Date cannot be blank';



    trigger OnInitReport()
    begin
        DelExisting := false;
    end;
}

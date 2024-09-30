xmlport 50105 "Meters to Mendix"
{
    Caption = 'Meters to Mendix';
    format = VariableText;
    FieldSeparator = ',';
    FieldDelimiter = '"';
    FileName = 'MetersToMendix.txt';

    schema
    {
        textelement(RootNodeName)
        {
            tableelement(Meter; Meter)
            {
                SourceTableView = WHERE("Must Send To Mendix" = CONST(true));
                fieldelement(CustNo; Meter."Customer No.")
                {
                }
                fieldelement(Code; Meter."No.")
                {
                }
                fieldelement(CustNo; Meter."Customer No.")
                {
                }
                fieldelement(ShipToCode; Meter."Ship-to Code")
                {
                }
                fieldelement(SerialNo; Meter."Serial No.")
                {
                }
                fieldelement(Name; Meter.Name)
                {
                }
                fieldelement(Name2; Meter."Name 2")
                {
                }
                fieldelement(Address; Meter.Address)
                {
                }
                fieldelement(Address2; Meter."Address 2")
                {
                }
                fieldelement(City; Meter.City)
                {
                }
                fieldelement(County; Meter.County)
                {
                }
                fieldelement(PostCode; Meter."Post Code")
                {
                }
            }
        }
    }


    trigger OnPostXmlPort()
    var
        ShipToAddr: record "Ship-to Address";
    begin
        Meter.reset;
        Meter.setrange("Must Send To Mendix", true);
        If Meter.findset then
            repeat
                Meter."Must Send To Mendix" := false;
                Meter."Sent To Mendix" := true;
                Meter."Sent To Mendix Date" := today;
                Meter."Sent To Mendix Time" := time;
                Meter.modify;
            until Meter.next = 0;
    end;
}

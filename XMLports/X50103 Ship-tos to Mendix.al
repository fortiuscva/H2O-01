xmlport 50103 "Ship-tos to Mendix"
{
    Caption = 'Ship-tos to Mendix';
    format = VariableText;
    FieldSeparator = ',';
    FieldDelimiter = '"';
    FileName = 'ShipTosToMendix.txt';

    schema
    {
        textelement(RootNodeName)
        {
            tableelement(ShiptoAddr; "Ship-to Address")
            {
                SourceTableView = WHERE("Must Send To Mendix" = CONST(true));
                fieldelement(CustNo; ShiptoAddr."Customer No.")
                {
                }
                fieldelement(Code; ShiptoAddr.Code)
                {
                }

                fieldelement(Name; ShiptoAddr.Name)
                {
                }
                fieldelement(Name2; ShiptoAddr."Name 2")
                {
                }
                fieldelement(Address; ShiptoAddr.Address)
                {
                }
                fieldelement(Address2; ShiptoAddr."Address 2")
                {
                }
                fieldelement(City; ShiptoAddr.City)
                {
                }
                fieldelement(County; ShiptoAddr.County)
                {
                }
                fieldelement(PostCode; ShiptoAddr."Post Code")
                {
                }
                fieldelement(PhoneNo; ShiptoAddr."Phone No.")
                {
                }
                fieldelement(EMail; ShiptoAddr."E-Mail")
                {
                }
            }
        }
    }


    trigger OnPostXmlPort()
    var
        ShipToAddr: record "Ship-to Address";
    begin
        ShipToAddr.reset;
        ShipToAddr.setrange("Must Send To Mendix", true);
        If ShiptoAddr.findset then
            repeat
                ShiptoAddr."Must Send To Mendix" := false;
                ShiptoAddr."Sent To Mendix" := true;
                ShiptoAddr."Sent To Mendix Date" := today;
                ShiptoAddr."Sent To Mendix Time" := time;
                ShiptoAddr.modify;
            until ShiptoAddr.next = 0;
    end;
}

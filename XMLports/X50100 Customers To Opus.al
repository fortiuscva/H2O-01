xmlport 50100 "Customers To Opus"
{
    Caption = 'Customers To Opus';
    format = VariableText;
    FieldSeparator = ',';
    FieldDelimiter = '"';
    FileName = 'CustToOpus.txt';

    schema
    {
        textelement(RootNodeName)
        {
            tableelement(Customer; Customer)
            {
                SourceTableView = WHERE("Must Send To Opus" = CONST(true));
                fieldelement(No; Customer."No.")
                {
                }
                fieldelement(Name; Customer.Name)
                {
                }
                fieldelement(Name2; Customer."Name 2")
                {
                }
                fieldelement(Address; Customer.Address)
                {
                }
                fieldelement(Address2; Customer."Address 2")
                {
                }
                fieldelement(City; Customer.City)
                {
                }
                fieldelement(County; Customer.County)
                {
                }
                fieldelement(PostCode; Customer."Post Code")
                {
                }
                fieldelement(PhoneNo; Customer."Phone No.")
                {
                }
                fieldelement(EMail; Customer."E-Mail")
                {
                }
                fieldelement(OurAccountNo; Customer."Our Account No.")
                {
                }
                fieldelement(PaymentTermsCode; Customer."Payment Terms Code")
                {
                }
            }
        }
    }


    trigger OnPostXmlPort()
    var
        cust: record customer;
    begin
        Cust.reset;
        Cust.setrange("Must Send To Opus", true);
        If Cust.findset then
            repeat
                Cust."Must Send To Opus" := false;
                Cust."Sent To Opus" := true;
                Cust."Sent To Opus Date" := today;
                Cust."Sent To Opus Time" := time;
                Cust.modify;
            until Cust.next = 0;
    end;
}

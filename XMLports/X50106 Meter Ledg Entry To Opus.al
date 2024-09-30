xmlport 50106 "Meter Ledg Entry to Opus"
{
    Caption = 'Meter Ledger Entries to Opus';
    format = VariableText;
    FieldSeparator = ',';
    FieldDelimiter = '"';
    FileName = 'MtrLedgEntryToOpus.txt';

    schema
    {
        textelement(RootNodeName)
        {
            tableelement(MLE; "Meter Ledger Entry")
            {
                SourceTableView = WHERE("Must Send To Opus" = CONST(true), "Meter Activity Code" = FILTER('READING'),
                                        "Sent To Opus" = filter(false));
                fieldelement(PostDate; MLE."Posting Date")
                {
                }
                fieldelement(DocDate; MLE."Document Date")
                {
                }
                fieldelement(DocNo; MLE."Document No.")
                {
                }
                fieldelement(MtrNo; MLE."Meter No.")
                {
                }
                fieldelement(SerialNo; MLE."Serial No.")
                {
                }
                fieldelement(CustNo; MLE."Customer No.")
                {
                }
                fieldelement(ShiptoCode; MLE."Ship-to Code")
                {
                }
                fieldelement(CurrMtrRead; MLE."Current Meter Reading")
                {
                }
                fieldelement(CurrMtrReadDate; MLE."Current Meter Reading Date")
                {
                }
                fieldelement(WaterUsage; MLE."Water Usage")
                {
                }
            }
        }
    }


    trigger OnPostXmlPort()
    var
        MtrLedg: record "Meter Ledger Entry";
        MtrActivity: record "Meter Activity";
    begin
        MtrActivity.reset;
        MtrActivity.setrange(Reading, true);
        If MtrActivity.findfirst then begin
            MtrLedg.reset;
            MtrLedg.setrange("Must Send To Opus", true);
            MtrLedg.setrange("Sent To Opus", false);
            MtrLedg.setrange("Meter Activity Code", MtrActivity.Code);
            If MtrLedg.findset then
                repeat
                    MtrLedg."Must Send To Opus" := false;
                    MtrLedg."Sent To Opus" := true;
                    MtrLedg."Sent To Opus Date" := today;
                    MtrLedg."Sent To Opus Time" := time;
                    MtrLedg.modify;
                until MtrLedg.next = 0;
        end;
    end;
}

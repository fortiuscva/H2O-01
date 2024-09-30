tableextension 50126 "Work Type Ext" extends "Work Type"
{
    fields
    {
        field(50100; Contract; Boolean)
        {
            Caption = 'Contract';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                If (rec.Contract <> xrec.Contract and rec.Contract) then begin
                    WT.reset;
                    WT.setrange(Contract, true);
                    IF WT.findfirst then
                        error(Text001);
                end;
            end;
        }
        field(50101; Overtime; Boolean)
        {
            Caption = 'Overtime';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                If (rec.Overtime <> xrec.Overtime and rec.Overtime) then begin
                    WT.reset;
                    WT.setrange(Overtime, true);
                    IF WT.findfirst then
                        error(Text002);
                end;
            end;

        }
    }



    var
        WT: record "Work Type";
        text001: TextConst ENU = 'Only 1 work type code can be flagged as Contract.';
        text002: TextConst ENU = 'Only 1 work type code can be flagged as Overtime.';

}

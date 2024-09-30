tableextension 50111 "Resource Group Ext" extends "Resource Group"
{
    fields
    {
        field(50100; Rental; Boolean)
        {
            Caption = 'Rental';
            DataClassification = ToBeClassified;
        }
    }


    var
        ResCustPr: record "Resource Customer Price";


    trigger OnBeforeDelete()
    begin
        ResCustPr.setrange(Type, ResCustPr.Type::"Group(Resource)");
        ResCustPr.setrange("No.", "No.");
        ResCustPr.deleteall;
    end;

}

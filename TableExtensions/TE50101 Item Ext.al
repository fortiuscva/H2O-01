tableextension 50101 "Item Ext" extends Item
{
    fields
    {
        field(50100; Meter; Boolean)
        {
            Caption = 'Meter';
            DataClassification = ToBeClassified;
        }
        field(50103; "Must Send To Mendix"; boolean)
        {
            Caption = 'Must Send To Mendix';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50105; "Sent To Mendix"; Boolean)
        {
            Caption = 'Sent To Mendix';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50110; "Sent To Mendix Date"; Date)
        {
            Caption = 'Sent To Mendix Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50115; "Sent To Mendix Time"; Time)
        {
            Caption = 'Sent To Mendix Time';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50120; "Highest Unit Cost"; decimal)
        {
            Caption = 'Sent To Mendix Time';
            //DataClassification = ToBeClassified;
            Editable = false;
            FieldClass = flowfield;
            CalcFormula = max("Value Entry"."Cost per unit" where("Item No." = field("No.")));
        }
    }


    trigger OnAfterInsert()
    begin
        "Must Send To Mendix" := true;
        "Sent To Mendix" := false;
        "Sent To Mendix Date" := 0D;
        "Sent To Mendix Time" := 0T;
    end;


    trigger OnAfterModify()
    begin
        /*
        If "Last Date Modified" > "Sent to Mendix Date" then begin
            "Must Send To Mendix" := true;
            "Sent To Mendix" := false;
            "Sent To Mendix Date" := 0D;
            "Sent To Mendix Time" := 0T;
        end;
        */
    end;

}

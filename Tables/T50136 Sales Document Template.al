table 50136 "Sales Document Template"
{
    Caption = 'Sales Document Template';
    DataClassification = ToBeClassified;
    LookupPageId = "Sales Document Template";
    DrillDownPageId = "Sales Document Template";


    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(2; "Source Document Type"; Enum "Sales Document Type")
        {
            Caption = 'From Document Type';
            DataClassification = ToBeClassified;
        }
        field(3; "Source Document No."; Code[20])
        {
            Caption = 'From Document No.';
            DataClassification = ToBeClassified;
            TableRelation = "Sales Header"."No." where("Document Type" = FIELD("Source Document Type"), "Sell-to Customer No." = field("Customer No."));
        }
        field(4; "Creation Day"; Integer)
        {
            Caption = 'Creation Day';
            DataClassification = ToBeClassified;
            MinValue = 1;
            MaxValue = 31;
        }
        field(10; "Target Document Type"; Enum "Sales Document Type")
        {
            Caption = 'To Document Type';
            DataClassification = ToBeClassified;
        }
        field(15; "Last Creation Date"; date)
        {
            Caption = 'To Document Type';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(20; "Source Document Status"; enum "Sales Document Status")
        {
            Caption = 'Source Document Status';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(25; "Last Document No. Created"; code[20])
        {
            Caption = 'Last Document No. Created';
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }



    keys
    {
        key(PK; "Customer No.", "Source Document Type", "Source Document No.", "Creation Day")
        {
            Clustered = true;
        }
    }


    var
        Text001: TextConst ENU = 'Source Document Type and Target Document Type cannot be the same.';


    trigger OnInsert()
    begin
        IF "Source Document Type" = "Target Document Type" then
            error(Text001);
    end;
}

table 50124 "Meter Reading Pull Calendar"
{
    Caption = 'Meter Reading Pull Calendar';
    DataClassification = ToBeClassified;
    LookupPageId = "Meter Pull Calendar";
    DrillDownPageId = "Meter Pull Calendar";

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer;
            trigger OnValidate()
            begin
                If Cust.get("Customer No.") then
                    Name := Cust.Name;
            end;
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "Pull Date"; Date)
        {
            Caption = 'Pull Date';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                SetPullDay();
            end;
        }
        field(4; Pulled; Boolean)
        {
            Caption = 'Pulled';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Pull Day"; Integer)
        {
            Caption = 'Pulled';
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }


    keys
    {
        key(PK; "Customer No.", "Pull Date")
        {
            Clustered = true;
        }
        key(Date; "Pull Date")
        { }
    }


    var
        Cust: record Customer;


    local Procedure SetPullDay()
    begin
        "Pull Day" := DATE2DMY("Pull Date", 1);
    end;
}

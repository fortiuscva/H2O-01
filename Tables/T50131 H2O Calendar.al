table 50131 "H2O Calendar"
{
    Caption = 'H2O Calendar';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = ToBeClassified;
        }
        field(2; "Day of Week"; Enum "Day Of Week")
        {
            Caption = 'Day of Week';
            DataClassification = ToBeClassified;
        }
        field(3; "Nonworking Day"; Boolean)
        {
            Caption = 'Nonworking Day';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                If "Nonworking Day" then begin
                    "Contract Start Time" := 0T;
                    "Contract End Time" := 0T;
                end;
            end;
        }
        field(4; Description; Text[30])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(5; "Contract Start Time"; Time)
        {
            Caption = 'Contract Start Time';
            DataClassification = ToBeClassified;
        }
        field(6; "Contract End Time"; Time)
        {
            Caption = 'Contract End Time';
            DataClassification = ToBeClassified;
        }
        field(7; Month; integer)
        {
            Caption = 'Month';
            DataClassification = ToBeClassified;
        }
        field(8; Day; integer)
        {
            Caption = 'Day';
            DataClassification = ToBeClassified;
        }
        field(9; ContractST; DateTime)
        {
            Caption = 'ContractST';
            DataClassification = ToBeClassified;
        }
        field(10; ContractET; DateTime)
        {
            Caption = 'ContractET';
            DataClassification = ToBeClassified;
        }
    }


    keys
    {
        key(PK; "Date")
        {
            Clustered = true;
        }
    }
}

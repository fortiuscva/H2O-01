table 50133 "BSI Cover Page"
{
    Caption = 'BSI Cover Page';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Dimension Value Code"; Code[20])
        {
            Caption = 'Dimension Value Code';
        }
        field(2; "Dimension Value Name"; Text[50])
        {
            Caption = 'Dimension Value Name';
        }
        field(3; Amount; Decimal)
        {
            Caption = 'Amount';
        }
    }



    keys
    {
        key(PK; "Dimension Value Code")
        {
            Clustered = true;
        }
    }
}

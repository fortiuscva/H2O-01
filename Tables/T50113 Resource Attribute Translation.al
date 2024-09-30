table 50113 "Resource Attribute Translation"
{
    Caption = 'Resource Attribute Translation';

    fields
    {
        field(1; "Attribute ID"; Integer)
        {
            Caption = 'Attribute ID';
            NotBlank = true;
            TableRelation = "Resource Attribute";
        }
        field(2; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            NotBlank = true;
            TableRelation = Language;
        }
        field(3; Name; Text[250])
        {
            Caption = 'Name';
        }
    }



    keys
    {
        key(Key1; "Attribute ID", "Language Code")
        {
            Clustered = true;
        }
    }


    fieldgroups
    {
    }
}


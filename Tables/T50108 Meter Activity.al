table 50108 "Meter Activity"
{
    Caption = 'Meter Activity';
    DataClassification = ToBeClassified;
    LookupPageId = "Meter Activities";
    DrillDownPageId = "Meter Activities";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[30])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(5; Reading; Boolean)
        {
            Caption = 'Meter Reading Activity';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                MtrAct: record "Meter Activity";
                Text001: TextConst ENU = 'Only one Activity Code can be set for Meter Reading.';
            begin
                if Rec.Reading <> xRec.Reading then
                    IF rec.Reading = false then
                        exit;

                MtrAct.setrange(Reading, true);
                If MtrAct.findfirst then
                    error(Text001);
            end;
        }
        field(10; "Requires New Meter"; Boolean)
        {
            Caption = 'Requires New Meter';
            DataClassification = ToBeClassified;
        }
        field(15; Scrapped; boolean)
        {
            Caption = 'Scrapped';
            DataClassification = ToBeClassified;
        }
        field(20; Sale; boolean)
        {
            Caption = 'Scrapped';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                MtrAct: record "Meter Activity";
                Text002: TextConst ENU = 'Only one Activity Code can be set for Meter Sales.';
            begin
                if Rec.Sale <> xRec.Sale then
                    IF rec.Sale = false then
                        exit;

                MtrAct.setrange(Sale, true);
                If MtrAct.findfirst then
                    error(Text002);
            end;
        }
        field(25; "Meter Reading Opportunity"; boolean)
        {
            caption = 'Meter Reading Opportunity';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                MtrAct: record "Meter Activity";
                Text003: TextConst ENU = 'Only one Activity Code can be set for Meter Reading Opportunity.';
            begin
                if Rec."Meter Reading Opportunity" <> xRec."Meter Reading Opportunity" then
                    IF rec."Meter Reading Opportunity" = false then
                        exit;

                MtrAct.setrange("Meter Reading Opportunity", true);
                If MtrAct.findfirst then
                    error(Text003);
            end;
        }
    }


    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}

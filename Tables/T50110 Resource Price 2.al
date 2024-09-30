table 50110 "Resource Price 2"
{
    Caption = 'Resource Price';
    DrillDownPageID = "Resource Prices";
    LookupPageID = "Resource Prices";
    ObsoleteState = Pending;
    ObsoleteTag = '16.0';

    fields
    {
        field(2; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Resource,Group(Resource),All';
            OptionMembers = Resource,"Group(Resource)",All;
        }
        field(3; "Code"; Code[20])
        {
            Caption = 'Code';
            TableRelation = IF (Type = CONST(Resource)) Resource
            ELSE
            IF (Type = CONST("Group(Resource)")) "Resource Group";

            trigger OnValidate()
            begin
                if (Code <> '') and (Type = Type::All) then
                    FieldError(Code, StrSubstNo(Text000, FieldCaption(Type), Format(Type)));

                case Type of
                    Type::Resource:
                        begin
                            If Res.get(Code) then
                                Rental := Res.Rental;
                        end;
                    Type::"Group(Resource)":
                        begin
                            If ResGrp.get(Code) then
                                Rental := ResGrp.Rental;
                        end;
                end;
            end;
        }
        field(4; "Work Type Code"; Code[10])
        {
            Caption = 'Work Type Code';
            TableRelation = "Work Type";
        }
        field(5; "Unit Price"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Price';
        }
        field(6; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(10; Rental; boolean)
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
    }

    keys
    {
        key(Key1; Type, "Code", "Work Type Code", "Currency Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Text000: Label 'cannot be specified when %1 is %2';
        Res: record Resource;
        ResGrp: record "Resource Group";
}


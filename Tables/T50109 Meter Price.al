table 50109 "Meter Price"
{
    Caption = 'Meter Price';
    DataClassification = ToBeClassified;
    LookupPageId = "Meter Prices";
    DrillDownPageId = "Meter Prices";


    fields
    {
        field(1; "Type"; Enum "Meter Price Type")
        {
            Caption = 'Meter Price Type';
            DataClassification = ToBeClassified;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
            TableRelation = IF (Type = CONST(Meter)) Meter
            ELSE
            IF (Type = CONST("Group(Meter)")) "Meter Group";

            trigger OnValidate()
            begin
                if ("No." <> '') and (Type = Type::All) then
                    FieldError("No.", StrSubstNo(Text000, FieldCaption(Type), Format(Type)));
            end;
        }
        field(3; "Meter Activity Code"; Code[10])
        {
            Caption = 'Meter Activity Code';
            DataClassification = ToBeClassified;
            TableRelation = "Meter Activity" where(Reading = CONST(false));
        }
        field(4; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = ToBeClassified;
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
        }
        field(6; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(9; "Sales Type"; Enum "Sales Price Type")
        {
            Caption = 'Sales Type';
            trigger OnValidate()
            begin
                if "Sales Type" <> xRec."Sales Type" then begin
                    Validate("Sales Code", '');
                    //UpdateValuesFromItem();
                end;
            end;
        }
        field(10; "Sales Code"; Code[20])
        {
            Caption = 'Sales Code';
            TableRelation = IF ("Sales Type" = CONST("Customer Price Group")) "Customer Price Group"
            ELSE
            IF ("Sales Type" = CONST(Customer)) Customer;

            trigger OnValidate()
            begin
                if "Sales Code" <> '' then
                    case "Sales Type" of
                        "Sales Type"::"All Customers":
                            Error(Text001, FieldCaption("Sales Code"));
                        "Sales Type"::"Customer Price Group":
                            begin
                                //CustPriceGr.Get("Sales Code");
                                //OnValidateSalesCodeOnAfterGetCustomerPriceGroup(Rec, CustPriceGr);
                                //"Price Includes VAT" := CustPriceGr."Price Includes VAT";
                                //"VAT Bus. Posting Gr. (Price)" := CustPriceGr."VAT Bus. Posting Gr. (Price)";
                                //"Allow Line Disc." := CustPriceGr."Allow Line Disc.";
                                //"Allow Invoice Disc." := CustPriceGr."Allow Invoice Disc.";
                            end;
                        "Sales Type"::Customer:
                            begin
                                Cust.Get("Sales Code");
                                "Currency Code" := Cust."Currency Code";
                                //"Price Includes VAT" := Cust."Prices Including VAT";
                                //"VAT Bus. Posting Gr. (Price)" := Cust."VAT Bus. Posting Group";
                                //"Allow Line Disc." := Cust."Allow Line Disc.";
                            end;
                    end;
            end;

        }
    }



    keys
    {
        key(PK; "Type", "No.", "Sales Type", "Sales Code", "Meter Activity Code")
        {
            Clustered = true;
        }
    }


    var
        Cust: record Customer;
        Text000: TextConst ENU = 'cannot be specified when %1 is %2';
        Text001: TextConst ENU = '%1 must be blank.';
        Text003: TextConst ENU = '%1 cannot be after %2';
        Text002: TextConst ENU = 'If Sales Type = %1, then you can only change Starting Date and Ending Date from the Campaign Card.';
}
table 50123 "Resource Customer Price"
{
    Caption = 'Resource Customer Price';
    DataClassification = ToBeClassified;
    LookupPageId = "Resource Customer Prices";
    DrillDownPageId = "Resource Customer Prices";
    Permissions = TableData Resource = rimd,
                tabledata "Resource Customer Price" = rimd;



    fields
    {
        field(1; "Type"; enum "Resource Price Type")
        {
            Caption = 'Resource Type';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                If (rec."Type") <> (xRec."Type") then
                    "No." := '';
            end;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
            TableRelation = IF (Type = CONST(Resource)) Resource
            ELSE
            IF (Type = CONST("Group(Resource)")) "Resource Group";

            trigger OnValidate()
            begin
                if ("No." <> '') and (Type = Type::All) then
                    FieldError("No.", StrSubstNo(Text000, FieldCaption(Type), Format(Type)));

                If Type = Type::Resource then
                    If Res.GET("No.") then begin
                        "Resource Name" := Res.Name;
                        Rental := Res.Rental;
                        "Unit Of Measure Code" := Res."Base Unit of Measure";
                    end;

                If Type = Type::"Group(Resource)" then
                    If ResGrp.GET("No.") then begin
                        "Resource Name" := ResGrp.Name;
                        Rental := ResGrp.Rental;
                    end;
            end;

        }
        field(3; "Sales Type"; Enum "Sales Price Type")
        {
            Caption = 'Sales Type';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if "Sales Type" <> xRec."Sales Type" then begin
                    Validate("Sales Code", '');
                end;

                If "Sales Type" = "Sales Type"::"All Customers" then
                    "Sales Name" := 'All Customers';
            end;
        }
        field(4; "Sales Code"; Code[20])
        {
            Caption = 'Sales Code';
            DataClassification = ToBeClassified;
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
                                IF CustPrGrp.get("Sales Code") then
                                    "Sales Name" := CustPrGrp.Description;
                            end;
                        "Sales Type"::Customer:
                            begin
                                If Cust.Get("Sales Code") then begin
                                    "Sales Name" := Cust.Name;
                                    "Currency Code" := Cust."Currency Code";
                                end;
                            end;
                    end;
            end;
        }
        field(5; Rental; Boolean)
        {
            Caption = 'Rental';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = ToBeClassified;
            TableRelation = Currency;
        }
        field(7; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = ToBeClassified;
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
        }
        field(8; "Starting Date"; date)
        {
            Caption = 'Starting Date';
            DataClassification = ToBeClassified;
        }
        field(9; "Ending Date"; date)
        {
            Caption = 'Ending Date';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            Var
                StartDate: Date;
            begin
                StartDate := "Starting Date";
                IF StartDate <> 0D then
                    if "Ending Date" < StartDate then
                        error(Text002);
            end;
        }
        field(10; "Work Type Code"; code[10])
        {
            Caption = 'Work Type Code';
            DataClassification = ToBeClassified;
            TableRelation = "Work Type";
        }
        field(11; "Unit Of Measure Code"; code[10])
        {
            Caption = 'Unit Of Measure Code';
            DataClassification = ToBeClassified;
            tablerelation = if (Type = CONST("Group(Resource)")) "Unit Of Measure".Code
            else
            IF (Type = CONST(Resource)) "Resource Unit of Measure".Code where("Resource No." = field("No."));
        }
        field(12; "Resource Name"; code[100])
        {
            Caption = 'Resource Name';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(13; "Sales Name"; code[50])
        {
            Caption = 'Sales Name';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "Starting Time"; time)
        {
            Caption = 'Starting Time';
            DataClassification = ToBeClassified;
        }
        field(15; "Ending Time"; time)
        {
            Caption = 'Endint Time';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            Var
                StartTime: Time;
            begin
                StartTime := "Starting Time";
                IF StartTime <> 0T then
                    if "Ending Time" < StartTime then
                        error(Text003);
            end;
        }
    }


    keys
    {
        key(PK; "Type", "No.", "Sales Type", "Sales Code", "Work Type Code", "Unit Of Measure Code", "Starting Date", "Starting Time")
        {
            Clustered = true;
        }
    }


    var
        Cust: record Customer;
        Res: record Resource;
        ResGrp: record "Resource Group";
        CustPrGrp: record "Customer Price Group";
        Text000: TextConst ENU = 'cannot be specified when %1 is %2';
        Text001: TextConst ENU = '%1 must be blank.';
        Text002: TextConst ENU = 'Ending Date cannnot be less than Starting Date';
        Text003: TextConst ENU = 'Ending Time cannot be less than Starting Time';

}

table 50122 "Associated Resource"
{
    Caption = 'Associated Resources';
    DataClassification = ToBeClassified;
    LookupPageId = "Associated Resources";
    DrillDownPageId = "Associated Resources";

    fields
    {
        field(1; "Resource No."; Code[20])
        {
            Caption = 'Source No.';
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(2; "Associated No."; Code[20])
        {
            Caption = 'Associated No.';
            DataClassification = ToBeClassified;
            NotBlank = true;

            TableRelation = if ("Assoc. Type" = const(" ")) "Standard Text"
            else
            if ("Assoc. Type" = const("G/L Account")) "G/L Account" //where(Blocked = const(false))
            else
            if ("Assoc. Type" = const(Resource)) Resource where(Blocked = const(false))
            else
            if ("Assoc. Type" = const("Fixed Asset")) "Fixed Asset"
            else
            if ("Assoc. Type" = const("Charge (Item)")) "Item Charge"
            else
            if ("Assoc. Type" = const("Allocation Account")) "Allocation Account"
            else
            if ("Assoc. Type" = const(Item)) Item where(Blocked = const(false));
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                case "Assoc. Type" of
                    "Assoc. Type"::" ":
                        begin

                        end;
                    "Assoc. Type"::"G/L Account":
                        begin
                            IF GLAcct.get("Associated No.") then begin
                                Name := GLAcct.Name;
                                "Name 2" := '';
                                "Base Unit of Measure" := '';
                            end;
                        end;
                    "Assoc. Type"::Item:
                        begin
                            IF Item.get("Associated No.") then begin
                                Name := Item.Description;
                                "Name 2" := Item."Description 2";
                                "Base Unit of Measure" := Item."Base Unit of Measure";
                            end;
                        end;
                    "Assoc. Type"::Resource:
                        begin
                            IF Res.get("Associated No.") then begin
                                Name := Res.Name;
                                "Name 2" := res."Name 2";
                                "Base Unit of Measure" := Res."Base Unit of Measure";
                            end;
                        end;
                    "Assoc. Type"::"Fixed Asset":
                        begin
                            exit;
                        end;
                    "Assoc. Type"::"Charge (Item)":
                        begin
                            IF ChrgItem.get("Associated No.") then begin
                                Name := chrgitem.Description;
                                "Name 2" := '';
                                "Base Unit of Measure" := '';
                            end;
                        end;
                end;
            end;
        }
        field(3; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
        field(4; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
            DataClassification = ToBeClassified;
        }
        field(5; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            DataClassification = ToBeClassified;
            TableRelation = "Unit of Measure";
        }
        field(6; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
        }
        field(7; Rental; boolean)
        {
            Caption = 'Rental';
            DataClassification = ToBeClassified;
        }
        field(15; "Assoc. Type"; Enum "Sales Line Type")
        {
            Caption = 'Associated Type';
        }

    }



    keys
    {
        key(PK; "Resource No.", "Assoc. Type", "Associated No.")
        {
            Clustered = true;
        }
    }


    var
        Res: record Resource;
        GLAcct: record "G/L Account";
        Item: record Item;
        ChrgItem: record "Item Charge";
        FA: record "Fixed Asset";
}

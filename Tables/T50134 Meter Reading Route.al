table 50134 "Meter Reading Route"
{
    Caption = 'Meter Reading Route';
    DataClassification = ToBeClassified;
    LookupPageId = "Meter Reading Routes";
    DrillDownPageId = "Meter Reading Routes";

    fields
    {
        field(1; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            DataClassification = ToBeClassified;
            TableRelation = resource."No." where(type = const(Person));
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(3; "Route No."; Integer)
        {
            Caption = 'Route No.';
            DataClassification = ToBeClassified;
            TableRelation = Route."No." where("Customer No." = field("Customer No."));
        }
        field(10; "Meter No."; code[20])
        {
            Caption = 'Meter No.';
            DataClassification = ToBeClassified;
            TableRelation = Meter;
        }
        field(15; "Ship-to Code"; code[10])
        {
            Caption = 'Property No.';
            DataClassification = ToBeClassified;
            TableRelation = "Ship-to Address".Code;
        }
        field(20; Address; text[100])
        {
            Caption = 'Address';
            DataClassification = ToBeClassified;
        }
        field(25; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
            DataClassification = ToBeClassified;
        }
        field(30; City; Text[30])
        {
            Caption = 'City';
            DataClassification = ToBeClassified;
        }
        field(35; County; Text[30])
        {
            Caption = 'State';
            DataClassification = ToBeClassified;
        }
        field(40; "Post Code"; code[10])
        {
            Caption = 'ZIP Code';
            DataClassification = ToBeClassified;
        }
        field(45; "Serial No."; code[20])
        {
            Caption = 'Serial No.';
            DataClassification = ToBeClassified;
        }
        field(50; "Location Stop"; Code[20])
        {
            caption = 'Location Stop';
            DataClassification = ToBeClassified;
        }
        field(55; "Reading Date"; date)
        {
            caption = 'Meter Reading Date';
            DataClassification = ToBeClassified;
        }
        field(60; "Smart Meter"; Boolean)
        {
            caption = 'Smart Meter';
            DataClassification = ToBeClassified;
        }
        field(70; "Meter Journal Template"; code[10])
        {
            caption = 'Meter Journal Template';
            DataClassification = ToBeClassified;
            TableRelation = "Meter Journal Template";
        }
        field(80; "Meter Journal Batch"; Code[10])
        {
            caption = 'Meter Journal Batch';
            DataClassification = ToBeClassified;
            TableRelation = "Meter Journal Batch".Name where("Journal Template Name" = FIELD("Meter Journal Template"));
        }
        field(85; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = const(false));

            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(90; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          Blocked = const(false));

            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(95; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                Rec.ShowDimensions();
            end;

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;
        }
        field(100; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
    }



    keys
    {
        key(PK; "Resource No.", "Customer No.", "Route No.", "Location Stop")
        {
            Clustered = true;
        }
    }


    var
        DimMgt: Codeunit DimensionManagement;




    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        //OnBeforeValidateShortcutDimCode(Rec, xRec, FieldNumber, ShortcutDimCode, IsHandled);
        if IsHandled then
            exit;

        //TestField("Check Printed", false);
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");

        //OnAfterValidateShortcutDimCode(Rec, xRec, FieldNumber, ShortcutDimCode, CurrFieldNo);
    end;


    procedure ShowDimensions() IsChanged: Boolean
    var
        OldDimSetID: Integer;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        //OnBeforeShowDimensions(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            Rec, "Dimension Set ID", StrSubstNo('%1 %2 %3', "Meter Journal Template", "Meter Journal Batch", "Line No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

        IsChanged := OldDimSetID <> "Dimension Set ID";
    end;

}

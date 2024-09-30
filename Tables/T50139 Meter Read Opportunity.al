table 50139 "Meter Read Opportunity"
{
    Caption = 'Meter Read Opportunity';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            DataClassification = ToBeClassified;
            TableRelation = "Meter Journal Template";
        }
        field(2; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            DataClassification = ToBeClassified;
            TableRelation = "Meter Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name"));
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }

        field(10; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(20; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            DataClassification = ToBeClassified;
            TableRelation = "Ship-to Address".code where("Customer No." = FIELD("Customer No."));
        }
        field(30; "Meter No."; Code[20])
        {
            Caption = 'Meter No.';
            DataClassification = ToBeClassified;
            TableRelation = meter."No." where("Customer No." = field("Customer No."), "Ship-to Code" = field("Ship-to Code"));
        }
        field(40; "Date Read"; Date)
        {
            Caption = 'Date Read';
            DataClassification = ToBeClassified;
        }
        field(50; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            DataClassification = ToBeClassified;
            TableRelation = resource where(Type = const(person));
        }
        field(60; "Trouble Code"; Code[10])
        {
            Caption = 'Trouble Code';
            DataClassification = ToBeClassified;
            TableRelation = "Trouble Code";

            trigger OnValidate()
            begin
                If TroubleCode.get("Trouble Code") then
                    Replace := TroubleCode.replace;
            end;
        }
        field(70; "Skip Code"; Code[10])
        {
            Caption = 'Skip Code';
            DataClassification = ToBeClassified;
            TableRelation = "Skip Code";
        }
        field(80; "Work Order Created"; Boolean)
        {
            Caption = 'Work Order Created';
            DataClassification = ToBeClassified;
        }
        field(90; Replace; Boolean)
        {
            Caption = 'Replace';
            DataClassification = ToBeClassified;
        }
        field(100; "Shortcut Dimension 1 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(110; "Shortcut Dimension 2 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(120; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Set Entry";
            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }



    }
    keys
    {
        key(PK; "Journal Template Name", "Journal Batch Name", "Line No.")
        {
            Clustered = true;
        }
    }



    var
        TroubleCode: record "Trouble Code";
        DimMgt: codeunit DimensionManagement;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; VAR ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;


    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2 %3', "Journal Template Name", "Journal Batch Name", "Line No."));
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

}

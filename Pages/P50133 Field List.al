page 50133 "Field List"
{
    ApplicationArea = All;
    Caption = 'Field List';
    PageType = List;
    SourceTable = "Fields 2";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Table No."; Rec."Table No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the TableNo field.';
                }
                field("Table Name"; Rec."Table Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the TableName field.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Field Name"; Rec."Field Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the FieldName field.';
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("Type Name"; Rec."Type Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type Name field.';
                }
                field(Length; Rec.Length)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Len field.';
                }
                field("Field Caption"; Rec."Field Caption")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Field Caption field.';
                }
                field("Is Part Of Primary Key"; Rec."Is Part Of Primary Key")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the IsPartOfPrimaryKey field.';
                }
                field("App Package ID"; Rec."App Package ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the App Package ID field.';
                }
                field("App Runtime Package ID"; Rec."App Runtime Package ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the App Runtime Package ID field.';
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Class field.';
                }
                field("Data Classification"; Rec."Data Classification")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DataClassification field.';
                }
                field(Enabled; Rec.Enabled)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Enabled field.';
                }
                field("Obsolete Reason"; Rec."Obsolete Reason")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ObsoleteReason field.';
                }
                field("Obsolete State"; Rec."Obsolete State")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ObsoleteState field.';
                }
                field("Option String"; Rec."Option String")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the OptionString field.';
                }
                field("Relation Field No."; Rec."Relation Field No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the RelationFieldNo field.';
                }
                field("Relation Table No."; Rec."Relation Table No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the RelationTableNo field.';
                }
                field("SQL Data Type"; Rec."SQL Data Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SQLDataType field.';
                }
            }
        }
    }
}

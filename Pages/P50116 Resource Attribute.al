page 50116 "Resource Attribute"
{
    Caption = 'Resource Attribute';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Resource Attribute";
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            group(Control9)
            {
                ShowCaption = false;
                group(Control2)
                {
                    ShowCaption = false;
                    field(Name; Rec.Name)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the name of the resource attribute.';
                    }
                    field(Type; Rec.Type)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the type of the resource attribute.';

                        trigger OnValidate()
                        begin
                            UpdateControlVisibility();
                        end;
                    }
                    field(Blocked; rec.Blocked)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies that the attribute cannot be assigned to a resource. Resources to which the attribute is already assigned are not affected.';
                    }
                }
                group(Control11)
                {
                    ShowCaption = false;
                    Visible = ValuesDrillDownVisible;
                    field(Values; rec.GetValues())
                    {
                        ApplicationArea = All;
                        Caption = 'Values';
                        Editable = false;
                        ToolTip = 'Specifies the values of the resource attribute.';

                        trigger OnDrillDown()
                        begin
                            rec.OpenResAttributeValues();
                        end;
                    }
                }
                group(Control13)
                {
                    ShowCaption = false;
                    Visible = UnitOfMeasureVisible;
                    field("Unit of Measure"; Rec."Unit of Measure")
                    {
                        ApplicationArea = Basic, Suite;
                        DrillDown = false;
                        ToolTip = 'Specifies the name of the resource''s unit of measure, such as piece or hour.';

                        trigger OnDrillDown()
                        begin
                            rec.OpenResAttributeValues();
                        end;
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ResAttributeValues)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Resource Attribute &Values';
                Enabled = ValuesDrillDownVisible;
                Image = CalculateInventory;
                RunObject = Page "Resource Attribute Values";
                RunPageLink = "Attribute ID" = FIELD(ID);
                ToolTip = 'Opens a window in which you can define the values for the selected resource attribute.';
            }
            action(ResAttributeTranslations)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Translations';
                Image = Translations;
                RunObject = Page "Res. Attribute Translations";
                RunPageLink = "Attribute ID" = FIELD(ID);
                ToolTip = 'Opens a window in which you can define the translations for the selected resource attribute.';
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(ResAttributeValues_Promoted; ResAttributeValues)
                {
                }
                actionref(ResAttributeTranslations_Promoted; ResAttributeTranslations)
                {
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateControlVisibility();
    end;

    trigger OnOpenPage()
    begin
        UpdateControlVisibility();
    end;

    var
        ValuesDrillDownVisible: Boolean;
        UnitOfMeasureVisible: Boolean;

    local procedure UpdateControlVisibility()
    begin
        ValuesDrillDownVisible := (rec.Type = rec.Type::Option);
        UnitOfMeasureVisible := (rec.Type = rec.Type::Decimal) or (rec.Type = rec.Type::Integer);
    end;
}


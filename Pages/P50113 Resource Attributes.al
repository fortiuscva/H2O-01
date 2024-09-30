page 50113 "Resource Attributes"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Resource Attributes';
    CardPageID = "Resource Attribute";
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Resource Attribute";
    UsageCategory = Lists;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
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
                }
                field(Values; rec.GetValues())
                {
                    ApplicationArea = All;
                    Caption = 'Values';
                    ToolTip = 'Specifies the values of the resource attribute.';

                    trigger OnDrillDown()
                    begin
                        rec.OpenResAttributeValues();
                    end;
                }
                field(Blocked; rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that the attribute cannot be assigned to a resource. Resources to which the attribute is already assigned are not affected.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Attribute")
            {
                Caption = '&Attribute';
                action(ResAttributeValues)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Resource Attribute &Values';
                    Enabled = (rec.Type = rec.Type::Option);
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
}


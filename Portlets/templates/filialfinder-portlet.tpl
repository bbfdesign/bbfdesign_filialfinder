{* OPC Portlet Template – BBF Filialfinder *}
{bbf_filialfinder
    layout=$instance->getProperty('layout')|default:'default'
    branches=$instance->getProperty('branches')|default:'all'
    show_title=$instance->getProperty('show_title')|default:'true'
    title=$instance->getProperty('title')|default:''
    show_map=$instance->getProperty('show_map')|default:'true'
    map_height=$instance->getProperty('map_height')|default:'450'
    limit=$instance->getProperty('limit')|default:'0'
    class=$instance->getProperty('css_class')|default:''
}

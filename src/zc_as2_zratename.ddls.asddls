@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption view for ZI_AS2_ZRATENAME'
@Metadata.allowExtensions: true
define root view entity ZC_AS2_ZRATENAME
  provider contract transactional_query as projection on ZI_AS2_ZRATENAME
{
    key ID,
    Zrateid,
    Zrateid2,
    Zratename,
    Zabbreviation,
    Zcycle,
    Zzone,
    Erdat,
    Ernam,
    Aedat,
    Aenam,
    LastChangeAt,
    /* Associations */
    _RateData : redirected to composition child ZC_AS2_ZRATEDATA
}
